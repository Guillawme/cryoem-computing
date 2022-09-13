#!/usr/bin/env bash

#SBATCH --job-name=stack
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=newstack.log
#SBATCH --error=newstack.log
#SBATCH --open-mode=append

RAW_DATA_DIR=frames/
OUTPUT_FILE=new-stack.mrc
BIN=1 #leave this to 1 if binning was done by MotionCor2

module purge
module load imod

# Correct sorting depends on the filename pattern.
# You may need to adjust the sort command for your files.
srun newstack $(ls $RAW_DATA_DIR/*.mrc | sort -t [ -n -k 2) -bin $BIN $OUTPUT_FILE

