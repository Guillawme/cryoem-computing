#!/usr/bin/env bash

#SBATCH --job-name=preprocess
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128GB
#SBATCH --oversubscribe
#SBATCH --output=preprocessing.log
#SBATCH --error=preprocessing.log
#SBATCH --open-mode=append

# Configuration options
PARTICLES=/path/to/star/cs/or/mrcs
DATA_DIR=/path/to/CSproject/or/RELIONjob
IMG_DIM=128
OUT_PARTICLES=new-stack-128px.mrcs
ORIGINAL_IMG_DIM=500
OUT_POSES=poses.pkl
OUT_CTF=ctf.pkl
OUT_BACKPROJECTION=check-map.mrc

module purge
module load cryodrgn/1.1.0

srun cryodrgn downsample $PARTICLES --datadir $DATA_DIR -D $IMG_DIM -o $OUT_PARTICLES

srun cryodrgn parse_pose_csparc $PARTICLES -o $OUT_POSES -D $ORIGINAL_IMG_DIM

srun cryodrgn parse_ctf_csparc $PARTICLES -o $OUT_CTF

srun cryodrgn backproject_voxel \
	$OUT_PARTICLES \
	--poses $OUT_POSES \
	--ctf $OUT_CTF \
	-o $OUT_BACKPROJECTION

