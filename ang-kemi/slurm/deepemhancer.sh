#!/usr/bin/env bash

#SBATCH --job-name=deepemhancer
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

MAP1=half-map-1.mrc
MAP2=half-map-2.mrc # also works with a single full-map
MASK=mask.mrc
ML_MODEL=wideTarget # options are: wideTarget, tightTarget, highRes; incompatible with a mask
OUTPUT=output-map.mrc

# This is a global, shared location and should not be changed
WEIGHTS=/opt/deepemhancer-0.14/production_checkpoints

module purge
module load deepemhancer/0.14

srun deepemhancer \
	-i $MAP1 \
	-i2 $MAP2 \
	-m $MASK \
	-p $ML_MODEL \
	-o $OUTPUT \
	--deepLearningModelPath $WEIGHTS

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

