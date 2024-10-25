#!/usr/bin/env bash

#SBATCH --job-name=phenix-varref
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=30GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

# See documentation at
# https://phenix-online.org/documentation/reference/varref.html

BASE_DIR=/home/you/project

MAPS=${BASE_DIR}/maps
MODELS=${BASE_DIR}/models
VARREF=${BASE_DIR}/phenix/varref

# Settings for model building
MAP_SERIES=${MAPS}/series/J335_component_000_frame_???.mrc
MODEL=${MODELS}/model.cif
PARAMS=${varref}/run-01/params.eff
RESOLUTION=3.0
N_PROC=16 #set the same as --cpus-per-task=
MODELS_PER_MAP=10

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load phenix/1.21.2-5419

srun phenix.varref \
	$MODEL \
	$MAP_SERIES \
	resolution=$RESOLUTION \
	nproc=$N_PROC \
	models_per_map=$MODELS_PER_MAP

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

