#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/2022y09m11d-20h18m06s --timeout=1200s