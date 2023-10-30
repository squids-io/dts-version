#!/bin/bash

set -e

build_dir="public"
mkdir -p $build_dir
cd $build_dir
for chart in ../charts/*/; do
  if [[ -f "$chart"/Chart.yaml ]]; then
    helm package -u $chart
  fi
done
helm repo index --merge index.yaml --url https://squids-io.github.io/dts-version/ ./

cat > index.html <<EOF
<html>
<head>
    <title>Chart repo</title>
</head>
<body>
<h1>Dts Charts Repo</h1>
<p>Point Helm at this repo to see charts.</p>
</body>
</html>
EOF