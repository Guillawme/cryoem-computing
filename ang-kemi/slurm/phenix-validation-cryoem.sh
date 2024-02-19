#!/usr/bin/env bash

#SBATCH --job-name=phenix-validation-cryoem
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=20GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

MODEL=model.cif
FULL_MAP=
HALF_MAP_1=
HALF_MAP_2=
RESOLUTION=3.0

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load phenix/1.21-5207

srun phenix.validation_cryoem \
	$MODEL \
	$FULL_MAP \
	$HALF_MAP_1 \
	$HALF_MAP_2 \
	resolution=$RESOLUTION

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

