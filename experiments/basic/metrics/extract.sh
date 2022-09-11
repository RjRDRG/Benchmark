#!/bin/bash

set -o errexit

promql "$(sed -n 1p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/cpu.csv
promql "$(sed -n 2p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/memory.csv
promql "$(sed -n 3p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/bandwidth_received.csv
promql "$(sed -n 4p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/bandwidth_sent.csv

promql "$(sed -n 5p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/thourghput.csv
promql "$(sed -n 6p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/timeouts.csv
promql "$(sed -n 7p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/errors.csv

promql "$(sed -n 8p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/users.csv
promql "$(sed -n 9p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_min.csv
promql "$(sed -n 10p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_max.csv

promql "$(sed -n 11p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_p50.csv
promql "$(sed -n 12p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_p75.csv
promql "$(sed -n 13p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_p90.csv
promql "$(sed -n 14p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_p95.csv
promql "$(sed -n 15p ./query.promql)" --host "http://localhost:9090" --start {{ my_test_job_duration }}s --step 5s --output csv > $1/latency_p99.csv