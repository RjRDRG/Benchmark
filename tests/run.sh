#!/bin/bash

set -o errexit
set -o posix

NAME="basic"
CLEAN=false

while getopts 'cn:' OPTION; do
  case "$OPTION" in
    c)
      CLEAN=true
      ;;
    n)
      NAME="$OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-c] [-n experiment]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"



cd ../experiments/$NAME



cd target

echo "Deploying target"
source deploy_target.sh

echo "Waiting for target"
source wait_target.sh

cd ..



cd workload

DATE=$(date +%Yy%mm%dd_%Hh%Mm%Ss)

grep -RiIl "{{ my_test_job_name }}" | xargs sed -i "s|{{ my_test_job_name }}|$DATE|g"

echo "Deploying workload"
source deploy_workload.sh

echo "Waiting for workload"
source wait_workload.sh

grep -RiIl "$DATE" | xargs sed -i "s|$DATE|{{ my_test_job_name }}|g"

cd ..




cd metrics

mkdir -p ../../../tests/$NAME/$DATE

source extract.sh "../../../tests/$NAME/$DATE/"

echo "Metrics extracted"

cd ..



if $CLEAN ; then
    echo "Cleaning up experiment"
    source target/clean_target.sh
    source workload/clean_workload.sh 
fi
