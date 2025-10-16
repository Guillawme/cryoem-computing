#!/usr/bin/env bash

#SBATCH --job-name=phenix-molprobity
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=20GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

BASE_DIR=/home/you/project

MAPS=${BASE_DIR}/maps
MODELS=${BASE_DIR}/models
VALIDATION=${BASE_DIR}/validation

# Inputs
MODEL=${MODELS}/model.cif

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load phenix/1.21.2-5419

srun phenix.molprobity \
	$MODEL \

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

