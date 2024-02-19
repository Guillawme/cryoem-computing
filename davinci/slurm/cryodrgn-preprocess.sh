#!/usr/bin/env bash

#SBATCH --job-name=cryodrgn-preprocess
#SBATCH --partition=cryoem
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# Configuration options
PARTICLES=/home/guillaume/cryosparc-projects/CS-2023-05-22-jl08/exports/groups/J74_particles/J74_particles_exported.cs
DATA_DIR=/home/guillaume/cryosparc-projects/CS-2023-05-22-jl08/exports/groups/J74_particles/J72/extract
RELION_OR_CRYOSPARC=cs # cs if passing a .cs file, rln if passing a .star file
IMG_DIM=128
OUT_PARTICLES=JL08-P189-J74_particles_box128.mrcs
ORIGINAL_IMG_DIM=400
OUT_POSES=JL08-P189-J74_poses.pkl
OUT_CTF=JL08-P189-J74_ctf.pkl
OUT_BACKPROJECTION=JL08-P189-J74_check-map.mrc

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module purge
module load cryodrgn/2.3.0

OPTIONS=("rln", "cs")

usage () {
	echo "Set a correct value for RELION_OR_CRYOSPARC in the submission script"
	echo "Possible values: rln, cs"                                         
	exit 1 
}

if [[ ! ${OPTIONS[*]} =~ $RELION_OR_CRYOSPARC  ]]; then
	usage
fi

srun cryodrgn downsample \
	$PARTICLES \
	--datadir $DATA_DIR \
	-D $IMG_DIM \
	-o rec_$OUT_PARTICLES

srun cryodrgn preprocess \
	$PARTICLES \
	--datadir $DATA_DIR \
	-D $IMG_DIM \
	-o $OUT_PARTICLES

if [[ $RELION_OR_CRYOSPARC = "rln" ]]; then
	srun cryodrgn parse_pose_star \
		$PARTICLES \
		-o $OUT_POSES \
		-D $ORIGINAL_IMG_DIM
	
	srun cryodrgn parse_ctf_star \
		$PARTICLES \
		-o $OUT_CTF

elif [[ $RELION_OR_CRYOSPARC = "cs"  ]]; then
	srun cryodrgn parse_pose_csparc \
		$PARTICLES \
		-o $OUT_POSES \
		-D $ORIGINAL_IMG_DIM
	
	srun cryodrgn parse_ctf_csparc \
		$PARTICLES \
		-o $OUT_CTF

else
	usage
fi

srun cryodrgn backproject_voxel \
	rec_$OUT_PARTICLES \
	--poses $OUT_POSES \
	--ctf $OUT_CTF \
	-o $OUT_BACKPROJECTION

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

