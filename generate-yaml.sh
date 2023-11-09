#!bin/sh
rm -rf ./install/install.yaml
helm template dts-api-server charts/dts-api-server -n dts --set $1 --set $2  > ./yaml/dts-api-server.yaml
helm template dts-ui charts/dts-ui -n dts > ./yaml/dts-ui.yaml
helm template grafana charts/grafana -n dts > ./yaml/grafana.yaml
helm template monitor charts/monitor -n dts > ./yaml/monitor.yaml
helm template elasticsearch charts/elasticsearch -n dts > ./yaml/elasticsearch.yaml
helm template fluentbit charts/fluentbit -n dts > ./yaml/fluentbit.yaml

cat ./charts/namespace.yaml >> ./install/install.yaml

for file in ./yaml/*
do
    if echo "$file" | grep -q -E '\.yaml$'
    then
        cat $file >> ./install/install.yaml
    fi
done

tar -czvf install.tar.gz ./install