#!/usr/bin/env bash

#SBATCH --job-name=phenix-validation-cryoem
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8GB
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
FULL_MAP=${MAPS}/cryosparc_P306_J130_011_volume_map.mrc
HALF_MAPS=${MAPS}/cryosparc_P306_J130_011_volume_map_half_?.mrc
MODEL=${MODELS}/model.cif
PARAMS=${VALIDATION}/params.eff
RESOLUTION=3.0

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load phenix/1.21.2-5419

srun phenix.validation_cryoem \
	$MODEL \
	$FULL_MAP \
	$HALF_MAPS \
	resolution=$RESOLUTION \
	$PARAMS

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

