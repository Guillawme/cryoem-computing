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

# MODEL can be one of:
# unet-3d-10a, unet-3d-20a
# or a full path to a .sav file from a custom training run
MODEL=unet-3d-10a

# Standard deviation of Gaussian filter applied after denoising
# Default 0
GAUSSIAN_FILTER=0

# Only change PATCH_SIZE and PATCH_PADDING if you know you need it              
# The default values are good in most cases                                     
PATCH_SIZE=96
PATCH_PADDING=48

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load topaz

if [[ ! -d ${OUT_PATH} ]]; then
	mkdir -p ${OUT_PATH}
fi

# Option '--device -2' will use all GPUs requested with --gres=gpu:
# Option '-j -1' will use all cores requested with --cpus-per-task
srun topaz denoise3d \
	$DATA_PATH \
	--model $MODEL \
	--device -2 \ 
	-j -1 \ 
	--gaussian $GAUSSIAN_FILTER \
	--patch-size $PATCH_SIZE \
	--patch-padding $PATCH_PADDING \
	--output $OUT_PATH

