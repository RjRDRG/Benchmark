#!/bin/bash

set -o errexit

kubectl wait deployment -n 2022y09m12d-15h07m15s app1 --for condition=Available=True --timeout=300s
kubectl wait deployment -n 2022y09m12d-15h07m15s app2 --for condition=Available=True --timeout=300s
kubectl wait deployment -n 2022y09m12d-15h07m15s app3 --for condition=Available=True --timeout=300s
kubectl wait deployment -n 2022y09m12d-15h07m15s app4 --for condition=Available=True --timeout=300s