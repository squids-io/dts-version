#! /usr/bin/env bash

set -ex

function backup() {
  mkdir -p ".backup"
  cd .backup
  echo "backup cmdb"
  cmdb=$(kubectl -nqfusion get po -l IsMaster=true -oname | grep cmdb | head -1)
  cmdb=${cmdb:4}
  if [[ $cmdb == "" ]]; then
    echo "cmdb pod not found, please check pod status of cmdb"
    exit 1
  fi
  ts=$(date +%s)
  kubectl -n qfusion exec $cmdb -cmysql -- mysqldump -uroot -pletsg0 -h127.0.0.1 -P3306 --single-transaction --set-gtid-purged=ON --master-data=2 --triggers --events --routines --net-buffer-length=16M --all-databases >backup-$ts.sql
  ln -sf ./backup-$ts.sql backup.sql

  echo "success to backup cmdb"
  for rs in deploy sts cm svc ds; do
    echo "backup $rs resource"
    kubectl -nqfusion get $rs -oyaml >$rs-$ts.yaml
    ln -sf ./$rs-$ts.yaml $rs.yaml
  done
  cd -
}

backup