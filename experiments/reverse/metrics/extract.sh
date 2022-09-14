#!/bin/bash

set -o errexit

END=$(date --date="-{{ my_test_job_duration_buffer }} sec" --iso-8601="seconds")
START=$(date --date="-$(({{ my_test_job_duration }} - {{ my_test_job_duration_buffer }})) sec" --iso-8601="seconds")

promql "$(sed -n 1p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/cpu.csv
promql "$(sed -n 2p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/memory.csv

promql "$(sed -n 3p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/thourghput.csv
promql "$(sed -n 4p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/timeouts.csv

promql "$(sed -n 5p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_min.csv
promql "$(sed -n 6p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_max.csv
promql "$(sed -n 7p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_p50.csv
promql "$(sed -n 8p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_p75.csv
promql "$(sed -n 9p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_p90.csv
promql "$(sed -n 10p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_p95.csv
promql "$(sed -n 11p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/latency_p99.csv
promql "$(sed -n 12p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/bandwidth.csv
promql "$(sed -n 13p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/requests.csv
promql "$(sed -n 14p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/200.csv
promql "$(sed -n 15p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/econnreset.csv
promql "$(sed -n 16p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/users_completed.csv
promql "$(sed -n 17p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/users_created.csv
promql "$(sed -n 18p ./query.promql)" --host "http://localhost:9090" --start $START --end $END --step 5s --output csv > $1/500.csv

for f in $1/*.csv
do
    # filename without path (on_time.txt)
    filename=$(basename "$f")

    # remove extension of filename (on_time)
    filename_woext="${filename%.*}"

    # replace all occurrences of "replace" with "on_time" in file
    sed -i -e "s/value/$filename_woext/g" $1/$filename

    if [ -z "$(sed -n 2p $1/$filename)" ]
        mv $1/$filename $1/$filename_woext.txt
    fi

done

csvjoin --left -c timestamp $1/*.csv > $1/all.csv