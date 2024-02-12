#!/usr/bin/env bash

#SBATCH --job-name=denoise
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
# unet, unet-small, fcnn, affine, unet-v0.2.1
# or a full path to a .sav file from a custom training run
MODEL=unet 

# OUT_FORMAT can be one of:
# mrc, png, tiff, jpg
OUT_FORMAT=mrc 

# Only change PATCH_SIZE and PATCH_PADDING if you know you need it
# The default values are good in most cases
PATCH_SIZE=1536
PATCH_PADDING=384

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load topaz

if [[ ! -d ${OUT_PATH} ]]; then                                                 
        mkdir -p ${OUT_PATH}                                                    
fi                                                                              
                                                                                
# Option '--device -2' will use all GPUs requested with --gres=gpu:
# Option '-j -1' will use all cores requested with --cpus-per-task
srun topaz denoise \
	$DATA_PATH \
	--model $MODEL \
	--device -2 \ 
	-j -1 \ 
	--format $OUT_FORMAT \
	--patch-size $PATCH_SIZE \
	--patch-padding $PATCH_PADDING \
	--normalize \
	--output $OUT_PATH

