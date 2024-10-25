#!/usr/bin/env bash

#SBATCH --job-name=modelangelo-noseq
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

BASE_DIR=/home/you/project

MAPS=${BASE_DIR}/maps
MODELANGELO=${BASE_DIR}/modelangelo

# Settings for model building
MAP=${MAPS}/cryosparc_P306_J130_011_volume_map.mrc
MASK=${MAPS}/cryosparc_P306_J130_011_volume_mask_refine.mrc
OUTPUT=$MODELANGELO

# This is a global, shared location and should not be changed
WEIGHTS=/opt/model-angelo-1.0.13/hub/checkpoints/model_angelo_v1.0/nucleotides_no_seq

module purge
module load model-angelo/1.0.13

srun model_angelo build_no_seq \
	-v $MAP \
	-m $MASK \
	-o $OUTPUT \
	--model-bundle-path $WEIGHTS

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

