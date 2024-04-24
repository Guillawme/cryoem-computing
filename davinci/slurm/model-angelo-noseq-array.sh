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
#SBATCH --array=00-99

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

MASK=mask.mrc
if [[ ${SLURM_ARRAY_TASK_ID} -lt 10 ]]; then
	# Cannot zero-pad $SLURM_ARRAY_TASK_ID, so this hack is necessary
	# The other option would be to rename the files, but this is annoying
	MAP=J102_class_0${SLURM_ARRAY_TASK_ID}_00019_volume.mrc
	OUTPUT=J102_class_0${SLURM_ARRAY_TASK_ID}
else
	MAP=J102_class_${SLURM_ARRAY_TASK_ID}_00019_volume.mrc
	OUTPUT=J102_class_${SLURM_ARRAY_TASK_ID}
fi

# This is a global, shared location and should be adjusted to the host system
WEIGHTS=$HOME/opt/model-angelo-1.0.12/hub/checkpoints/model_angelo_v1.0/nucleotides_no_seq

module purge
module load model-angelo/1.0.12

srun model_angelo build_no_seq \
	-v $MAP \
	-m $MASK \
	-o $OUTPUT \
	--model-bundle-path $WEIGHTS

PROTEOME_FASTA=reference-proteome.fasta
OUT_DIR=${OUTPUT}/protein-identification
ALPHABET=amino #possible other values: DNA, RNA

srun model_angelo hmm_search \
	--input-dir $OUTPUT \
	--fasta-path $PROTEOME_FASTA \
	--output-dir $OUT_DIR \
	--alphabet $ALPHABET

# Send notification upon job completion
source $HOME/opt/slurm/slurm-completion.sh

