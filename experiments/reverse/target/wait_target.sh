#!/bin/bash

set -o errexit

kubectl wait deployment -n {{ my_test_job_name }} app1 --for condition=Available=True --timeout=300s
kubectl wait deployment -n {{ my_test_job_name }} app2 --for condition=Available=True --timeout=300s
kubectl wait deployment -n {{ my_test_job_name }} app3 --for condition=Available=True --timeout=300s
kubectl wait deployment -n {{ my_test_job_name }} app4 --for condition=Available=True --timeout=300s