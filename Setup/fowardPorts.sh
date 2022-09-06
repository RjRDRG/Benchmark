#!/bin/bash

kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000:80
kubectl --namespace monitoring port-forward svc/prometheus-pushgateway 9091

kubectl --namespace monitoring port-forward svc/prometheus-kube-prometheus-prometheus 9090