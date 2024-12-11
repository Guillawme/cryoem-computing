#!/usr/bin/env bash

#SBATCH --job-name=tempy-reff-ensemble
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

BASE_DIR=

MAP=${BASE_DIR}/maps/map.mrc
MODEL=${BASE_DIR}/models/model.mmcif
OUTPUT_DIR=${BASE_DIR}/tempy-reff/run-01/ensemble
RESOLUTION=2.73

ENSEMBLE_SIZE=10 # How many models to include in the ensemble. Default: 10
ENSEMBLE_DENSITY_K=5.0 # Strength of density force. Default: 5.0

module purge
module load tempy-reff/1.1.0a0

srun python $TEMPY_REFF_SCRIPTS/ensemble.py \
	--pdb $MODEL \
	--map $MAP \
	--output-dir $OUTPUT_DIR \
	--platform-cuda \
	--forcefield-amber \
	--keep-hydrogens \
	--resolution $RESOLUTION \
	--ensemble-size $ENSEMBLE_SIZE \
	--ensemble-density-k $ENSEMBLE_DENSITY_K

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

