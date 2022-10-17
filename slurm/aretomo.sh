#!/usr/bin/env bash

#SBATCH --job-name=aretomo
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=run.log
#SBATCH --error=run.log
#SBATCH --open-mode=append

BASE_NAME=position-1
TILT_SERIES=${BASE_NAME}-tilt-series.mrc
OUT_ALN_TILT_SERIES=${BASE_NAME}-tilt-series-aligned.mrc
OUT_TOMOGRAM=${BASE_NAME}-tomogram.mrc
TILT_RANGE="-60 60"
TILT_AXIS="-89.81"
PATCH="0 0" # number of patches in X and Y for local motion cor (leave "0 0" to disable)
#ALN_FILE=${TILT_SERIES}.aln # provide an ALN file to skip alignment
VOL_Z=1200 # set to 0 to stop after alignment and skip tomogram reconstruction
OUT_BINNING=4

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load aretomo

if [[ (-v ALN_FILE) && ($VOL_Z = 0) ]]; then
	echo "Nothing to do"
	echo "You provided an ALN file, so skipping alignement"
	echo "You provided VOL_Z=$VOL_Z, so skipping reconstruction"
	echo "Check your submission script"
	exit 1
elif [[ (-v ALN_FILE) && ($VOL_Z > 0) ]]; then
	echo "Skip alignment: found ALN_FILE=$ALN_FILE"
	echo "Reconstruct: found VOL_Z=$VOL_Z"
	srun aretomo \
        	-InMrc $TILT_SERIES \
        	-OutMrc $OUT_TOMOGRAM \
		-TiltRange $TILT_RANGE \
                -TiltAxis $TILT_AXIS \
        	-VolZ $VOL_Z \
        	-OutBin $OUT_BINNING \
        	-FlipVol 1 \
		-Wbp 1 \
		-Align 0 \
		-AlnFile $ALN_FILE
elif [[ (! -v ALN_FILE) && ($VOL_Z = 0) ]]; then 
	echo "Align: found no ALN_FILE"
	echo "Skip reconstruction: found VOL_Z=$VOL_Z"
	srun aretomo \
        	-InMrc $TILT_SERIES \
        	-OutMrc $OUT_ALN_TILT_SERIES \
        	-TiltRange $TILT_RANGE \
        	-TiltAxis $TILT_AXIS \
		-Patch $PATCH \
        	-VolZ $VOL_Z \
        	-OutBin $OUT_BINNING \
		-Wbp 1
elif [[ (! -v ALN_FILE) && ($VOL_Z > 0) ]]; then
	echo "Align: found no ALN_FILE"
	echo "Reconstruct: found VOL_Z=$VOL_Z"
	srun aretomo \
                -InMrc $TILT_SERIES \
                -OutMrc $OUT_TOMOGRAM \
                -TiltRange $TILT_RANGE \
                -TiltAxis $TILT_AXIS \
		-Patch $PATCH \
                -VolZ $VOL_Z \
                -OutBin $OUT_BINNING \
                -FlipVol 1 \
                -Wbp 1
else
	echo "Unexpected error"
	echo "Check your submission script"
	exit 1
fi

