#!/usr/bin/env bash

## Template job submission script for SLURM
## for a cryoDRGN job

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=cryodrgn-landscape
#SBATCH --partition=cryoem
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# Configuration options
WORK_DIR=run-01
EPOCH=29
APIX=2.33
DOWNSAMPLE=100
GMM_CLUSTERS=10

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module purge
module load cryodrgn/2.3.0

# Run analysis
srun cryodrgn analyze_landscape \
	--Apix $APIX \
	--downsample $DOWNSAMPLE \
	-M $GMM_CLUSTERS \
	$WORK_DIR \
	$EPOCH

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

