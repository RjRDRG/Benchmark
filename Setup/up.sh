#!/bin/bash

set -o errexit
set -o posix

kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade -i prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --set grafana.plugins=grafana-image-renderer

helm upgrade -i prometheus-pushgateway --atomic --set serviceMonitor.enabled=true prometheus-community/prometheus-pushgateway

kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000:80 &
kubectl port-forward svc/prometheus-pushgateway 9091 &

cd artillery-operator

source ./operator-deploy.sh

kubectl -n artillery-operator-system set env deployments/artillery-operator-controller-manager ARTILLERY_DISABLE_TELEMETRY=true

cd ..