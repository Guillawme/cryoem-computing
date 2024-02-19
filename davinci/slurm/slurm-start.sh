#!/usr/bin/env bash

# Send a notification upon job start
# Use this by adding this line at the beginning of any script:
# source slurm-start.sh

# Configuration options:
HOSTNAME=davinci
NTFY_TOPIC=

curl \
	--silent \
	-H "Title: 🔄 Job started on ${HOSTNAME}" \
	-H "Tags: in-progress" \
	-d "Job ${SLURM_JOB_NAME} (${SLURM_JOB_ID}) just started." \
	ntfy.sh/${NTFY_TOPIC}

