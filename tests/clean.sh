#!/bin/bash

if (( $# != 1 ))
then
  echo "Usage: ./clean.sh [experiment name]"
  exit 1
fi

cd ../tmp/$1

cd target
source ./clean_target.sh
cd ..

cd workload
source ./clean_workload.sh 
cd ..

cd ..
rm -r ./$1