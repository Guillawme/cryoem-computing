#!/usr/bin/env bash

#SBATCH --job-name=servalcat-spa
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

# Required options
HALF_MAPS=map_half_?.mrc
MASK=mask.mrc
MODEL=model.cif
RESOLUTION=1.8

# Advanced options
POINT_GROUP=C1
CYCLES=10 # default, should not need to be changed
HYDROGENS=all # all: add riding hydrogen atoms, yes: use hydrogen atoms if present, no: remove hydrogen atoms in input. Default: all

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load servalcat/0.4.60

srun servalcat refine_spa \
	--halfmaps $HALF_MAPS \
	--mask $MASK \
	--model $MODEL \
	--resolution $RESOLUTION \
	--mask_for_fofc $MASK \
	--pg $POINT_GROUP \
	--ncycle $CYCLES \
	--hydrogen $HYDROGENS \
	--output_prefix $MODEL

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

