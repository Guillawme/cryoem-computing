#!/usr/bin/env bash

#SBATCH --job-name=modelangelo-hmm
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

INPUT=
PROTEOME_FASTA=
OUT_DIR=
ALPHABET=amino #possible other values: DNA, RNA

module purge
module load model-angelo/1.0.12

srun model_angelo hmm_search \
	--input-dir $INPUT \
	--fasta-path $PROTEOME_FASTA \
	--output-dir $OUT_DIR \
	--alphabet $ALPHABET

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

