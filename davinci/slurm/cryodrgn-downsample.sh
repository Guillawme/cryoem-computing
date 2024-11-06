#!/usr/bin/env bash

#SBATCH --job-name=cryodrgn-preprocess
#SBATCH --partition=regular
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# Configuration options
PARTICLES=/home/guillaume/cryosparc-projects/CS-gg25/exports/groups/J130_particles/J130_particles_exported.cs
DATA_DIR=/home/guillaume/cryosparc-projects/CS-gg25/exports/groups/J130_particles/J130/extract
RELION_OR_CRYOSPARC=cs # cs if passing a .cs file, rln if passing a .star file
IMG_DIM=140
OUT_PARTICLES=P306-J130_particles_box140.mrcs
ORIGINAL_IMG_DIM=512
OUT_POSES=P306-J130_poses.pkl
OUT_CTF=P306-J130_ctf.pkl
OUT_BACKPROJECTION=P306-J130_check-map.mrc

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module purge
module load cryodrgn/3.4.1

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
	$OUT_PARTICLES \
	--poses $OUT_POSES \
	--ctf $OUT_CTF \
	-o $OUT_BACKPROJECTION

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

