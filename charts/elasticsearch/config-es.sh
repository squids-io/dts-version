#!/usr/bin/bash

set -ex

# get parameters from environment variable
SERVICE_NAME=${SERVICE_NAME:-"elasticsearch-discovery"}
NAMESPACE=${NAMESPACE:-"qfusion"}
ES_PORT=${ES_PORT:-"9200"}

# kubernetes config
APISERVER=https://kubernetes.default.svc
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
TOKEN=$(cat ${SERVICEACCOUNT}/token)
CACERT=${SERVICEACCOUNT}/ca.crt

ES_URL=http://$SERVICE_NAME:$ES_PORT

# wait for elasticsearch status to be green or yellow
until [[ "$(curl $ES_URL/_cat/health?h=status)" =~ green|yellow ]]; do
  echo "Waiting for Elasticsearch status to be ready..."
  sleep 10
done

for template in $(find /log-templates -name "*.json" -type f -exec basename {} \;); do
  echo "Applying elasticsearch template: $template"
  if [ "$(curl -X PUT -o /dev/null -w ''%{http_code}'' "$ES_URL/_template/${template%.json}?pretty" -H 'Content-Type: application/json' -d @/log-templates/$template)" != "200" ]; then
    echo "create template failed"
    exit 1
  fi
  echo "Apply template success"
done

# 标记已经初始化完成，初始化完成之后，es再对外提供服务
if ! curl --fail "$ES_URL/.qf-ack-index-3.13.10"; then
  if ! curl --fail -X PUT "$ES_URL/.qf-ack-index-3.13.10"; then
    echo "create index qf ack failed"
    exit 1
  fi
fi

echo "success to config elasticsearch"
