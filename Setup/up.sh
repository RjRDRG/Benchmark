#!/bin/bash

set -o errexit
set -o posix

kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus-pushgateway --atomic prometheus-community/prometheus-pushgateway --namespace monitoring

helm install prometheus --atomic prometheus-community/kube-prometheus-stack --namespace monitoring --values pushgateway_values.yaml

cd artillery-operator

source ./operator-deploy.sh

kubectl -n artillery-operator-system set env deployments/artillery-operator-controller-manager ARTILLERY_DISABLE_TELEMETRY=true

sleep 30

kubectl create clusterrolebinding artillery-cluster-admin --clusterrole=cluster-admin --serviceaccount=artillery-operator-system:artillery-operator-controller-manager

cd ..