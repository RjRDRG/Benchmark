#!/bin/bash

set -o errexit
set -o posix

mkdir -p $1

promql "$(sed -n 1p ./query.promql)" --host "http://localhost:9090" --start 2m --output csv > $1/cpu.csv
promql "$(sed -n 2p ./query.promql)" --host "http://localhost:9090" --start 2m --output csv > $1/memory.csv
promql "$(sed -n 3p ./query.promql)" --host "http://localhost:9090" --start 2m --output csv > $1/bandwidth_received.csv
promql "$(sed -n 4p ./query.promql)" --host "http://localhost:9090" --start 2m --output csv > $1/bandwidth_sent.csv