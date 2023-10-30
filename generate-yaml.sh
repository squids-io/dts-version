#!bin/sh
rm -rf install-dts.yaml install-es-monitor.yaml
helm template dts-api-server charts/dts-api-server -n qfusion > ./dtsyaml/dts-api-server.yaml
helm template dts-ui charts/dts-ui -n qfusion > ./dtsyaml/dts-ui.yaml
helm template grafana charts/grafana -n dts > ./yaml/grafana.yaml
helm template monitor charts/monitor -n dts > ./yaml/monitor.yaml
helm template elasticsearch charts/elasticsearch -n dts > ./yaml/elasticsearch.yaml
helm template fluentbit charts/fluentbit -n dts > ./yaml/fluentbit.yaml

for file in ./dtsyaml/*
do
    if echo "$file" | grep -q -E '\.yaml$'
    then
        cat $file >> ./install-dts.yaml
    fi
done

for file in ./yaml/*
do
    if echo "$file" | grep -q -E '\.yaml$'
    then
        cat $file >> ./install-es-monitor.yaml
    fi
done