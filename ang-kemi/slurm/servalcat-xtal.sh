#!/usr/bin/env bash

#SBATCH --job-name=servalcat-xtal
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

BASE_DIR=/path/to/your/project

DATA=${BASE_DIR}/data
MODELS=${BASE_DIR}/models

# Required options
HKLIN=${DATA}/structure-factors.cif
MODEL=${MODELS}/atomic-model.cif
OUTPUT_PREFIX=atomic-model_refined
RESOLUTION=2.44

# Advanced options
CYCLES=10 # default, should not need to be changed
HYDROGENS=all # all: add riding hydrogen atoms, yes: use hydrogen atoms if present, no: remove hydrogen atoms in input. Default: all

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load servalcat/0.4.118

srun servalcat refine_xtal_norefmac \
	--hklin $HKLIN \
	--model $MODEL \
	--hydrogen $HYDROGENS \
	--ncycle $CYCLES \
	--adp iso \
	--source xray \
	--output_prefix $OUTPUT_PREFIX
	#--d_min $RESOLUTION
	#--labin FP,SIGFP,FreeR_flag \

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

