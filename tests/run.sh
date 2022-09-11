#!/bin/bash

set -o errexit
set -o posix

TC_GRD=$'\x1B[0;30;42m'

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

echo -e "\e[1;42m Deploying target \e[0m"
source ./deploy_target.sh

echo -e "\e[1;42m Waiting for target \e[0m"
source ./wait_target.sh

cd ..



cd workload

DATE=$(date +%Yy%mm%dd-%Hh%Mm%Ss)

echo -e "\e[1;42m Deploying workload \e[0m"

grep -RiIl "{{ my_test_job_name }}" | xargs sed -i "s|{{ my_test_job_name }}|$DATE|g"

source ./deploy_workload.sh

echo -e "\e[1;42m Waiting for workload \e[0m"
source ./wait_workload.sh

grep -RiIl "2022y09m11d_15h39m51s" | xargs sed -i "s|2022y09m11d_15h39m51s|{{ my_test_job_name }}|g"

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
fi
