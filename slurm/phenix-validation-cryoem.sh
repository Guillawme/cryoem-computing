#!/usr/bin/env bash

#SBATCH --job-name=validation
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=run.log
#SBATCH --error=run.log
#SBATCH --open-mode=append

MODEL=model.cif
FULL_MAP=map.mrc
HALF_MAP_1=map_half_1.mrc
HALF_MAP_2=map_half_2.mrc
RESOLUTION=3.0

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load phenix

srun phenix.validation_cryoem \
	$MODEL \
	$FULL_MAP \
	$HALF_MAP_1 \
	$HALF_MAP_2 \
	$RESOLUTION

