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
OUTPUT_DIR=./mcor2/
PATCH="5 5"
PIXSIZE=4.54
KV=200
#FMDOSE=0.28 # uncomment this and set dose per frame to use dose weighting
FTBIN=2

# Make sure output directory exists (MotionCor2 won't create it if it does not already exist...)
if [[ ! -d $OUTPUT_DIR ]]; then
	mkdir -p $OUTPUT_DIR
fi

module purge
module load motioncor2/1.5.0

if [[ -v FMDOSE ]]; then
	srun MotionCor2 -InMrc $RAW_DATA_DIR -OutMrc $OUTPUT_DIR -Serial 1 -LogDir $OUTPUT_DIR -Patch $PATCH -PixSize $PIXSIZE -Kv $KV -FmDose $FMDOSE -FtBin $FTBIN -Gpu 0 1 2 3
else
	srun MotionCor2 -InMrc $RAW_DATA_DIR -OutMrc $OUTPUT_DIR -Serial 1 -LogDir $OUTPUT_DIR -Patch $PATCH -PixSize $PIXSIZE -Kv $KV -FtBin $FTBIN -Gpu 0 1 2 3
fi
