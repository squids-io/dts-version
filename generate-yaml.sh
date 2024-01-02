#!bin/sh
rm -rf ./install/install.yaml
rm -rf ./install/yaml
mkdir ./install/yaml
helm template istio charts/istio -n dts  > ./install/yaml/istio.yaml
helm template dts-api-server charts/dts-api-server -n dts  > ./install/yaml/dts-api-server.yaml
helm template dts-ui charts/dts-ui -n dts > ./install/yaml/dts-ui.yaml
helm template grafana charts/grafana -n dts > ./install/yaml/grafana.yaml
helm template monitor charts/monitor -n dts > ./install/yaml/monitor.yaml
helm template elasticsearch charts/elasticsearch -n dts > ./install/yaml/elasticsearch.yaml
helm template fluentbit charts/fluentbit -n dts > ./install/yaml/fluentbit.yaml

cat ./charts/namespace.yaml >> ./install/yaml/namespace.yaml
cat ./charts/secret.yaml >> ./install/yaml/secret.yaml
cat ./charts/ciliumnetworkpolicy.yaml >> ./install/yaml/ciliumnetworkpolicy.yaml
cat ./charts/mutatingWebhookConfiguration.yaml >> ./install/yaml/mutatingWebhookConfiguration.yaml
cat ./charts/cert.yaml >> ./install/yaml/cert.yaml