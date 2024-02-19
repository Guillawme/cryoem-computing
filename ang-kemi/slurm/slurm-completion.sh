#!/usr/bin/env bash

# Send a notification upon job completion
# Use this by adding this line at the end of any script:
# source slurm-completion.sh

# This line must come first, to catch
# the last exit code from the calling script
LAST_EXIT_CODE=$?

# Configuration options:
HOSTNAME=ang-kemi
NTFY_TOPIC=

# Customize notification depending on the exit code
# of the last command in the calling script
if [[ $LAST_EXIT_CODE == 0 ]]; then
        curl \
                --silent \
                -H "Title: ✅ Job complete on ${HOSTNAME}" \
                -H "Tags: done" \
                -d "Job ${SLURM_JOB_NAME} (${SLURM_JOB_ID}) just terminated." \
                ntfy.sh/${NTFY_TOPIC}
else
        curl \
                --silent \
                -H "Title: ❌ Job failed on ${HOSTNAME}" \
                -H "Tags: failed" \
                -d "Job ${SLURM_JOB_NAME} (${SLURM_JOB_ID}) failed with exit code ${LAST_EXIT_CODE}." \
                ntfy.sh/${NTFY_TOPIC}
fi

