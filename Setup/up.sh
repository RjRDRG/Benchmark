#!/bin/bash

set -o errexit
set -o posix

kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --values grafana_values.yaml

helm install prometheus-pushgateway --atomic --set serviceMonitor.enabled=true prometheus-community/prometheus-pushgateway --namespace monitoring

cd artillery-operator

source ./operator-deploy.sh

kubectl -n artillery-operator-system set env deployments/artillery-operator-controller-manager ARTILLERY_DISABLE_TELEMETRY=true

cd ..