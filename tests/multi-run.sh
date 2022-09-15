#!/bin/bash

set -o errexit
set -o posix


source ./run.sh ./u2.config
sleep 20

source ./run.sh ./u4.config
sleep 20

source ./run.sh ./s_u8.config
sleep 20

source ./run.sh ./s_u16.config
sleep 20

source ./run.sh ./s_u32.config
sleep 20




source ./run.sh ./s_p100.config
sleep 20

source ./run.sh ./s_p300.config
sleep 20

source ./run.sh ./s_p600.config
sleep 20

source ./run.sh ./s_p1200.config
sleep 20

source ./run.sh ./s_p2400.config
sleep 20