#!/bin/bash

set -o errexit

kubectl wait deployment -n apps app1 --for condition=Available=True --timeout=300s
kubectl wait deployment -n apps app2 --for condition=Available=True --timeout=300s
kubectl wait deployment -n apps app3 --for condition=Available=True --timeout=300s
kubectl wait deployment -n apps app4 --for condition=Available=True --timeout=300s