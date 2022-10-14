#!/usr/bin/env bash

#SBATCH --job-name=aretomo
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=run.log
#SBATCH --error=run.log
#SBATCH --open-mode=append

BASE_NAME=position-4
TILT_SERIES=${BASE_NAME}-tilt-series.mrc
OUT_TOMOGRAM=${BASE_NAME}-tomogram.mrc
TILT_RANGE="-60 60"
TILT_AXIS="-89.81"
VOL_Z=0
OUT_BINNING=4

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load aretomo

srun aretomo \
	-InMrc $TILT_SERIES \
	-OutMrc $OUT_TOMOGRAM \
	-TiltRange $TILT_RANGE \
	-TiltAxis $TILT_AXIS \
	-VolZ $VOL_Z \
	-OutBin $OUT_BINNING \
	-FlipVol 1 

