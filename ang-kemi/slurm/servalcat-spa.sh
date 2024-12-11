#!/usr/bin/env bash

#SBATCH --job-name=servalcat-spa
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10GB
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

# Required options
HALF_MAPS=${MAPS}/map_half_?.mrc
MASK=${MAPS}/mask.mrc
MODEL=${MODELS}/model.cif
RESOLUTION=1.8
OUTPUT_PREFIX=my-model

# Advanced options
POINT_GROUP=C1
CYCLES=10 # default, should not need to be changed
HYDROGENS=all # all: add riding hydrogen atoms, yes: use hydrogen atoms if present, no: remove hydrogen atoms in input. Default: all

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load servalcat/0.4.88

srun servalcat refine_spa_norefmac \
	--halfmaps $HALF_MAPS \
	--model $MODEL \
	--resolution $RESOLUTION \
	--output_prefix $OUTPUT_PREFIX \
	--mask_for_fofc $MASK \
	--pg $POINT_GROUP \
	--ncycle $CYCLES \
	--hydrogen $HYDROGENS \
	--hout \
	--adp iso

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

