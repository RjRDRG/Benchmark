#!/bin/bash

set -o errexit

END=$(date --date="-60 sec" --iso-8601="seconds")
START=$(date --date="-$((300 + 60)) sec" --iso-8601="seconds")

promql "$(sed -n 1p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/1-cpu.csv
promql "$(sed -n 2p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/2-memory.csv
promql "$(sed -n 3p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/3-bandwidth_received.csv
promql "$(sed -n 4p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/4-bandwidth_sent.csv

promql "$(sed -n 5p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/5-thourghput.csv
promql "$(sed -n 6p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/6-timeouts.csv
promql "$(sed -n 7p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/7-requests.csv

promql "$(sed -n 8p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/8-users.csv
promql "$(sed -n 9p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/9-latency_min.csv
promql "$(sed -n 10p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/10-latency_max.csv

promql "$(sed -n 11p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/11-latency_p50.csv
promql "$(sed -n 12p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/12-latency_p75.csv
promql "$(sed -n 13p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/13-latency_p90.csv
promql "$(sed -n 14p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/14-latency_p95.csv
promql "$(sed -n 15p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/15-latency_p99.csv

for f in $1/*.csv
do
    # filename without path (on_time.txt)
    filename=$(basename "$f")

    # remove extension of filename (on_time)
    filename_woext="${filename%.*}"

    # replace all occurrences of value
    sed -i -e "s/value/$filename_woext/g" $1/$filename

done

csvjoin --left -c timestamp $1/*.csv > $1/all.txt
sed -i -e "s/timestamp/0-timestamp/g" -e "s/,/\t/g" $1/all.txt