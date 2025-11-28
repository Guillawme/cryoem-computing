#!/usr/bin/env bash

#SBATCH --job-name=modelangelo-noseq
#SBATCH --partition=fast
#SBATCH --constraint=RTX2080Ti
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --oversubscribe
#SBATCH --output=%x-%j-%a.log
#SBATCH --error=%x-%j-%a.log
#SBATCH --open-mode=append
#SBATCH --array=0,99

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# This script runs ModelAngelo with no sequence information,
# followed by hmm search against a reference proteome.
# It was set up to run a SLURM array job to analyze many maps
# in parallel, to determine which subunits of a complex are
# present in reconstruction from different 3D classes, in a
# situation where some particles were missing subunits.

BASE_DIR=/home/you/project

MAPS=${BASE_DIR}/maps
MODELANGELO=${BASE_DIR}/modelangelo

MASK=${MAPS}/mask.mrc

if [[ ${SLURM_ARRAY_TASK_ID} -lt 10 ]]; then
	# Cannot zero-pad $SLURM_ARRAY_TASK_ID, so this hack is necessary
	# The other option would be to rename the files, but this is annoying
	MAP=${MAPS}/J102_class_0${SLURM_ARRAY_TASK_ID}_00019_volume.mrc
	OUTPUT=J102_class_0${SLURM_ARRAY_TASK_ID}
else
	MAP=${MAPS}/J102_class_${SLURM_ARRAY_TASK_ID}_00019_volume.mrc
	OUTPUT=J102_class_${SLURM_ARRAY_TASK_ID}
fi

# This is a global, shared location and should not be changed
WEIGHTS=$HOME/opt/model-angelo-1.0.12/hub/checkpoints/model_angelo_v1.0/nucleotides_no_seq

module purge
module load model-angelo/1.0.12

srun model_angelo build_no_seq \
	-v $MAP \
	-m $MASK \
	-o $OUTPUT \
	--model-bundle-path $WEIGHTS

PROTEOME_FASTA=${BASE_DIR}/reference-proteome.fasta
OUT_DIR=${OUTPUT}/protein-identification
ALPHABET=amino #possible other values: DNA, RNA

srun model_angelo hmm_search \
	--input-dir $OUTPUT \
	--fasta-path $PROTEOME_FASTA \
	--output-dir $OUT_DIR \
	--alphabet $ALPHABET

# Send notification upon job completion
source $HOME/opt/slurm/slurm-completion.sh

