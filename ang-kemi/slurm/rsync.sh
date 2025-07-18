#!/usr/bin/env bash

#SBATCH --job-name=rsync
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

# This job sets up an unattended rsync transfer that can survive a logout

# Mind the trailing slash! Read the rsync manual.
# A trailing slash at the end of the source will copy the contents of that directory, without the enclosing directory
SRC=/path/to/your/data
DEST=/where/to/copy/your/data

echo "Copying ${SRC} to ${DEST}..."
rsync -auh --info=progress2 --chmod=D755,F644 ${SRC} ${DEST}

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

