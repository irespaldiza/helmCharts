#!/bin/bash
URL=${1:-'https://irespaldiza.github.io/helmCharts'}

# fail if not in helm3
helm version | grep -q v3
if [ $? -eq 1 ]; then 
  echo 'Error: helm v3 is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v yq)" ]; then
  echo 'Error: yq is not installed.' >&2
  exit 1
fi

set -e

for d in */ ; do
    helm lint $d
    helm package $d --destination $d
done

helm repo index --url $URL .
yq w -s devs.yaml index.yaml > index.yaml.generated
mv index.yaml.generated index.yaml
