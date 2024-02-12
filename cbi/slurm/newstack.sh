#!/usr/bin/env bash

#SBATCH --job-name=stack
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16GB
#SBATCH --oversubscribe
#SBATCH --output=newstack.log
#SBATCH --error=newstack.log
#SBATCH --open-mode=append

RAW_DATA_DIR=mcor2
BASE_NAME=position-1
OUTPUT_FILE=${BASE_NAME}-tilt-series.mrc
BIN=1 # leave this to 1 if binning was done by MotionCor2
TILT_RANGE="-60 2 60" # first angle, step, last angle

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load imod

seq $TILT_RANGE > ${BASE_NAME}-tilt-angles.txt

srun newstack \
	$(ls ${RAW_DATA_DIR}/*.mrc | sort -t [ -n -k 2) \
	-bin $BIN \
	-tilt ${BASE_NAME}-tilt-angles.txt \
	$OUTPUT_FILE

