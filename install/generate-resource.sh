#update 数据库表 casbin_rule
for name in qfusion-cmdb00-0  qfusion-cmdb01-0
do
  isMaster=`(kubectl -nqfusion  describe pod $name | grep IsMaster)`
  if echo "$isMaster" | grep -E 'IsMaster=true'
  then
    pod_status=$(kubectl get pods -n qfusion -o=jsonpath="{.items[?(@.metadata.name == '$name')].status.phase}")
    echo $pod_status
    while [ ! "$pod_status" == "Running" ]
    do
      sleep 20
      pod_status=$(kubectl get pods -n qfusion  -o=jsonpath="{.items[?(@.metadata.name == '$name')].status.phase}")
    done
   `(kubectl -nqfusion exec -it $name bash -cmysql  -- mysql -uroot -pletsg0 < ./casbin_rule.sql)`
   fi
done

#update secret username
username=`(kubectl -nqfusion get secret qfusion-cmdb0-root-suffix -oyaml | grep username)`
sed "0,/  username: XXXXXX/s//${username}/" ./yaml/secret.yaml > ./yaml/secret.back.yaml
mv ./yaml/secret.back.yaml  ./yaml/secret.yaml

#update secret password
password=`(kubectl -nqfusion get secret qfusion-cmdb0-root-suffix -oyaml | grep password)`
sed "0,/  password: XXXXXX/s//${password}/" ./yaml/secret.yaml > ./yaml/secret.back.yaml
mv ./yaml/secret.back.yaml  ./yaml/secret.yaml

caBundle=`(kubectl -nqfusion get mutatingwebhookconfigurations qfusion-vmi-injector -oyaml | grep -m 1 caBundle:)`
sed  "s/  caBundle: XXXXXX/${caBundle}/g" ./yaml/mutatingWebhookConfiguration.yaml > ./yaml/mutatingWebhookConfiguration.back.yaml
mv ./yaml/mutatingWebhookConfiguration.back.yaml  ./yaml/mutatingWebhookConfiguration.yaml

#update resource
for file in  namespace.yaml  ciliumnetworkpolicy.yaml  secret.yaml cert.yaml mutatingWebhookConfiguration.yaml dts-api-server.yaml  dts-ui.yaml  elasticsearch.yaml  fluentbit.yaml  grafana.yaml  istio.yaml  monitor.yaml
do
    if echo "$file" | grep -q -E '\.yaml$'
    then
        kubectl apply -f  ./yaml/$file
    fi
done

