#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/2022y09m11d-19h50m41s --timeout=1200s