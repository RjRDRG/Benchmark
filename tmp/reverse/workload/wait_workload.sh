#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/2022y09m12d-11h34m02s --timeout=1200s