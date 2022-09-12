#!/usr/bin/env bash

#SBATCH --job-name=<jobname>
#SBATCH --partition=main
#SBATCH --gres=gpu:1
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

srun topaz denoise $DATA_PATH --model unet --device 0 --format mrc --patch-size 1536 --patch-padding 384 --normalize --output $OUT_PATH

