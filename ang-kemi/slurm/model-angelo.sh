#!/usr/bin/env bash

#SBATCH --job-name=modelangelo
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

MAP=map.mrc
MASK=mask.mrc
PROTEIN_FASTA=protein-sequences.fasta
DNA_FASTA=dna-sequences.fasta
RNA_FASTA=rna-sequences.fasta
OUTPUT=modelangelo

# This is a global, shared location and should not be changed
WEIGHTS=/opt/model-angelo-1.0.1/weights/hub/checkpoints/model_angelo_v1.0/nucleotides

module purge
module load model-angelo/1.0.1

srun model_angelo build \
	-v $MAP \
	-m $MASK \
	--protein-fasta $PROTEIN_FASTA \
	--dna-fasta $DNA_FASTA \
	--rna-fasta $RNA_FASTA \
	-o $OUTPUT \
	--model-bundle-path $WEIGHTS

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

