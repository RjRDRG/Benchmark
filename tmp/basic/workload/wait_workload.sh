#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/2022y09m12d-09h54m20s --timeout=1200s