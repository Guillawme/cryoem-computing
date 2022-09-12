#!/usr/bin/env bash

#SBATCH --job-name=3denoise
#SBATCH --partition=main
#SBATCH --gres=gpu:2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128GB
#SBATCH --oversubscribe
#SBATCH --output=run.log
#SBATCH --error=run.log
#SBATCH --open-mode=append

DATA_PATH=/path/to/input/images/*.mrc
OUT_PATH=/path/to/output/folder


module purge
module load topaz/0.2.5

srun topaz denoise3d $DATA_PATH --model unet-3d-10a --device -2 -j 32 --gaussian 0 --patch-size 96 --patch-padding 48 --output $OUT_PATH

