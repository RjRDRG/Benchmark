#!/bin/bash

set -o errexit
set -o posix


source ./run.sh -c -f ./u2.config
sleep 20

source ./run.sh -c -f ./u4.config
sleep 20

source ./run.sh -c -f ./u8.config
sleep 20

source ./run.sh -c -f ./u16.config
sleep 20

source ./run.sh -c -f ./u32.config
sleep 20




source ./run.sh -c -f ./p100.config
sleep 20

source ./run.sh -c -f ./p300.config
sleep 20

source ./run.sh -c -f ./p600.config
sleep 20

source ./run.sh -c -f ./p1200.config
sleep 20

source ./run.sh -c -f ./p2400.config
sleep 20