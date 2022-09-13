#!/bin/bash

set -o errexit
set -o posix

CLEAN=false
FILE="./test.config"

NAME="reverse"
DURATION=200
DURATION_BUFFER=50
MIN_USERS=10
MAX_USERS=100
WORKERS=4

CALLS=2
FANOUT=1
PAYLOAD_SIZE=100

CPU=1.5
MEMORY=3.5
REPLICAS=1

while getopts 'cf:' OPTION; do
  case "$OPTION" in
    c)
      CLEAN=true
      ;;
    n)
      FILE="$OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-c] [-f config_file]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

source $FILE

PAYLOAD=$(printf '=%.0s' $(seq 1 $(($PAYLOAD_SIZE / 5))))

DATE=$(date +%Yy%mm%dd-%Hh%Mm%Ss)

mkdir -p ./$NAME/$DATE/

cp -a $FILE ./$NAME/$DATE/

cp -a ../experiments/$NAME ../tmp/
cd ../tmp/$NAME




grep -RiIl "{{ my_test_job_name }}" | xargs sed -i "s|{{ my_test_job_name }}|$DATE|g"
grep -RiIl "{{ my_test_job_duration }}" | xargs sed -i "s|{{ my_test_job_duration }}|$DURATION|g"
grep -RiIl "{{ my_test_job_duration_buffer }}" | xargs sed -i "s|{{ my_test_job_duration_buffer }}|$DURATION_BUFFER|g"
grep -RiIl "{{ my_test_job_min_users }}" | xargs sed -i "s|{{ my_test_job_min_users }}|$MIN_USERS|g"
grep -RiIl "{{ my_test_job_max_users }}" | xargs sed -i "s|{{ my_test_job_max_users }}|$MAX_USERS|g"
grep -RiIl "{{ my_test_job_workers }}" | xargs sed -i "s|{{ my_test_job_workers }}|$WORKERS|g"

grep -RiIl "{{ my_test_job_max_calls }}" | xargs sed -i "s|{{ my_test_job_max_calls }}|$CALLS|g"
grep -RiIl "{{ my_test_job_fanout }}" | xargs sed -i "s|{{ my_test_job_fanout }}|$FANOUT|g"
grep -RiIl "{{ my_test_job_payload }}" | xargs sed -i "s|{{ my_test_job_payload }}|$PAYLOAD|g"

grep -RiIl "{{ my_test_job_limit_cpu }}" | xargs sed -i "s|{{ my_test_job_limit_cpu }}|$CPU|g"
grep -RiIl "{{ my_test_job_limit_mem }}" | xargs sed -i "s|{{ my_test_job_limit_mem }}|$MEMORY|g"

grep -RiIl "{{ my_test_job_replicas }}" | xargs sed -i "s|{{ my_test_job_replicas }}|$REPLICAS|g"

cd target

echo -e "\e[1;42m Deploying target \e[0m"
source ./deploy_target.sh

echo -e "\e[1;42m Waiting for target \e[0m"
source ./wait_target.sh

cd ..



cd workload

echo -e "\e[1;42m Deploying workload \e[0m"
source ./deploy_workload.sh

echo -e "\e[1;42m Waiting for workload \e[0m"
source ./wait_workload.sh

cd ..



cd metrics

source ./extract.sh "../../../tests/$NAME/$DATE/"

echo -e "\e[1;42m Metrics extracted \e[0m"

cd ..



if $CLEAN ; then
    echo -e "\e[1;42m Cleaning up experiment \e[0m"
    cd target
    source ./clean_target.sh
    cd ..

    cd workload
    source ./clean_workload.sh 
    cd ..

    cd ..
    rm -r ./$NAME
fi


