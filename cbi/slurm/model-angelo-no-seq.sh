#!/usr/bin/env bash

#SBATCH --job-name=angelo
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=496
#SBATCH --oversubscribe
#SBATCH --output=run.log
#SBATCH --error=run.log
#SBATCH --open-mode=append

MAP=map.mrc
MASK=mask.mrc # optional, delete '-m $MASK' in command below if not using a mask

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load model-angelo

srun model_angelo build_no_seq -v $MAP -m $MASK

