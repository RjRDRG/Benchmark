#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/2022y09m12d-03h07m18s --timeout=1200s