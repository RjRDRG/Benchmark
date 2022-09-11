#!/bin/bash

set -o errexit

kubectl wait --for=condition=complete job/{{ my_test_job_name }} --timeout=1200s