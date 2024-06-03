#!/usr/bin/env bash

#SBATCH --job-name=modelangelo-noseq
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

MAP=map.mrc
MASK=mask.mrc
OUTPUT=modelangelo

# This is a global, shared location and should not be changed
WEIGHTS=/opt/model-angelo-1.0.12/hub/checkpoints/model_angelo_v1.0/nucleotides_no_seq

module purge
module load model-angelo/1.0.12

srun model_angelo build_no_seq \
	-v $MAP \
	-m $MASK \
	-o $OUTPUT \
	--model-bundle-path $WEIGHTS

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

