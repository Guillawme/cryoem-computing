#!/usr/bin/env bash

## Template job submission script for SLURM
## for a Boltz prediction job

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=boltz
#SBATCH --partition=cryoem
#SBATCH --constraint=RTXA5000
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# Configuration options
# See the documentation at: 
# https://github.com/jwohlwend/boltz/blob/main/docs/prediction.md

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module purge
module load boltz/2.2.1

srun boltz predict \
	*.yaml \
	--devices 1 \
	--use_msa_server \
	--use_potentials 

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

