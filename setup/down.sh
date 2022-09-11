#!/bin/bash

set -o errexit
set -o posix

kubectl delete namespace monitoring

kubectl delete namespace artillery-operator-system

kubectl delete namespace apps