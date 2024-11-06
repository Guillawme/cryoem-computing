#!/usr/bin/env bash

SLURM_JOB_NAME=test
SLURM_JOB_ID=01

source slurm-start.sh

echo "Success"
ls blah

source slurm-completion.sh

