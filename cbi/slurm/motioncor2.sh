#!/usr/bin/env bash

#SBATCH --job-name=mcor2
#SBATCH --partition=main
#SBATCH --gres=gpu:4
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128GB
#SBATCH --oversubscribe
#SBATCH --output=mcor2.log
#SBATCH --error=mcor2.log
#SBATCH --open-mode=append

RAW_DATA_DIR=./raw/
GAIN_REF=gain.mrc
OUTPUT_DIR=./mcor2/
PATCH="5 5"
PIXSIZE=1.01
KV=200
#FMDOSE=0.28 # uncomment this and set dose per frame to perform dose weighting
FTBIN=1

# Make sure output directory exists (MotionCor2 won't create it
# if it does not already exist...)
if [[ ! -d $OUTPUT_DIR ]]; then
	mkdir -p $OUTPUT_DIR
fi

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load motioncor2

if [[ -v FMDOSE ]]; then
	srun MotionCor2 \
		-InMrc $RAW_DATA_DIR \
		-OutMrc $OUTPUT_DIR \
		-Gain $GAIN_REF \
		-Serial 1 \
		-LogDir $OUTPUT_DIR \
		-Patch $PATCH \
		-PixSize $PIXSIZE \
		-Kv $KV \
		-FmDose $FMDOSE \
		-FtBin $FTBIN \
		-Gpu 0 1 2 3
else
	srun MotionCor2 \
		-InMrc $RAW_DATA_DIR \
		-OutMrc $OUTPUT_DIR \
		-Gain $GAIN_REF \
		-Serial 1 \
		-LogDir $OUTPUT_DIR \
		-Patch $PATCH \
		-PixSize $PIXSIZE \
		-Kv $KV \
		-FtBin $FTBIN \
		-Gpu 0 1 2 3
fi

