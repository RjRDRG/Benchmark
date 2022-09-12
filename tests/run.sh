#!/bin/bash

set -o errexit
set -o posix

NAME="basic"
CLEAN=false
DURATION=300
MIN_USERS=5
MAX_USERS=50
WORKERS=4

while getopts 'cn:d:m:M:w:' OPTION; do
  case "$OPTION" in
    c)
      CLEAN=false
      ;;
    n)
      NAME="$OPTARG"
      ;;
    d)
      DURATION="$OPTARG"
      ;;
    m)
      MIN_USERS="$OPTARG"
      ;;
    M)
      MAX_USERS="$OPTARG"
      ;;
    w)
      WORKERS="$OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-c] [-n experiment] [-d duration]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"




cp -a ../experiments/$NAME ../tmp/
cd ../tmp/$NAME




cd target

echo -e "\e[1;42m Deploying target \e[0m"
source ./deploy_target.sh

echo -e "\e[1;42m Waiting for target \e[0m"
source ./wait_target.sh

cd ..




DATE=$(date +%Yy%mm%dd-%Hh%Mm%Ss)

grep -RiIl "{{ my_test_job_name }}" | xargs sed -i "s|{{ my_test_job_name }}|$DATE|g"
grep -RiIl "{{ my_test_job_duration }}" | xargs sed -i "s|{{ my_test_job_duration }}|$DURATION|g"
grep -RiIl "{{ my_test_job_min_users }}" | xargs sed -i "s|{{ my_test_job_min_users }}|$MIN_USERS|g"
grep -RiIl "{{ my_test_job_max_users }}" | xargs sed -i "s|{{ my_test_job_max_users }}|$MAX_USERS|g"
grep -RiIl "{{ my_test_job_workers }}" | xargs sed -i "s|{{ my_test_job_workers }}|$WORKERS|g"

cd workload

echo -e "\e[1;42m Deploying workload \e[0m"
source ./deploy_workload.sh

echo -e "\e[1;42m Waiting for workload \e[0m"
source ./wait_workload.sh

cd ..




cd metrics

mkdir -p ../../../tests/$NAME/$DATE

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


