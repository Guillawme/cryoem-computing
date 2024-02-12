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
RELION_OR_CRYOSPARC=cs # cs if passing a .cs file, rln if passing a .star file
IMG_DIM=128
OUT_PARTICLES=new-stack-128px.mrcs
ORIGINAL_IMG_DIM=500
OUT_POSES=poses.pkl
OUT_CTF=ctf.pkl
OUT_BACKPROJECTION=check-map.mrc

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load cryodrgn

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

