#!/usr/bin/env bash

#SBATCH --job-name=tempy-reff
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

BASE_DIR=/home/you/project

MAPS=${BASE_DIR}/maps
MODELS=${BASE_DIR}/models
TEMPY_REFF=${BASE_DIR}/tempy-reff

# Required options
MAP=${MAPS}/map.mrc
MODEL=${MODELS}/model.cif
OUTPUT_DIR=${TEMPY_REFF}/run-01
RESOLUTION=1.43 # Resolution of cryo-EM map, required if using CCC for as a convergence method

# GMM refinement options
GMM_K=5000 # Strenght of the GMM fitting force. Default: 5000
GMM_INIT_STEPS=50 # Number of iterations of B-factor refinement to run before starting positional refinement. Default: 50
GMM_BFACTOR_STEPS=3 # Number of GMM positional updates between MD simulation steps. Default: 3
GMM_MAX_BFACTOR=5.0 # Maximum allowable B-factor. Default: 5.0

# MD simulation options
SIMULATION_ISTEPS=1000 # Number of integration steps to use for each round of MD simulation. Default: 1000

# Convergence options
CONVERGENCE_TYPE=patience # {variance,patience} Which method to use to assess convergence. Default: variance
CONVERGENCE_TIMEOUT=100 # Maximum number of steps before refinement is forced to end: Default: 100
CONVERGENCE_RUNS=3 # Number of steps to run before checking for convergence: Default: 3
CONVERGENCE_THRESHOLD=1e-6 # Maximum allowed variance before refinement is considered converged, if using variance convergence method, and ended. Default: 1e-6
CONVERGENCE_PATIENCE=5 # Maximum number of allowed steps without an improvement in convergence metric, if using patience convergence method. Default: 5
METRIC=ccc # {ccc,bfactor-ccc,rmsd} Method to use to assess whether the refinement has converged. Default: CCC

module purge
module load tempy-reff/1.1.0a0

srun tempy-reff \
	--model $MODEL \
	--map $MAP \
	--output-dir $OUTPUT_DIR \
	--overwrite \
	--output-cif \
	--platform-cuda \
	--forcefield-amber \
	--keep-hydrogens \
	--fitting-gmm \
	--fitting-gmm-k $GMM_K \
	--fitting-gmm-init-steps $GMM_INIT_STEPS \
	--fitting-gmm-bfactor-steps $GMM_BFACTOR_STEPS \
	--fitting-gmm-max-bfactor $GMM_MAX_BFACTOR \
	--simulation-isteps $SIMULATION_ISTEPS \
	--convergence-type $CONVERGENCE_TYPE \
	--convergence-timeout $CONVERGENCE_TIMEOUT \
	--convergence-runs $CONVERGENCE_RUNS \
	--convergence-threshold $CONVERGENCE_THRESHOLD \
	--convergence-patience $CONVERGENCE_PATIENCE \
	--metric $METRIC \
	--resolution $RESOLUTION

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

