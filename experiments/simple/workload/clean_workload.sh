#!/bin/bash

set -o errexit

kubectl delete -f job 2>/dev/null || true