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

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load topaz

srun topaz denoise3d \
	$DATA_PATH \
	--model unet-3d-10a \
	--device -2 \ # will use all GPUs requested with --gres=gpu:
	-j -1 \ # will use all cores requested with --cpus-per-task
	--gaussian 0 \
	--patch-size 96 \
	--patch-padding 48 \
	--output $OUT_PATH

