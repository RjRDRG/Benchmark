#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/2022y09m12d-15h07m15s --timeout=1200s