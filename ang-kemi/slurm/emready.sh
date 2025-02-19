#!/usr/bin/env bash

#SBATCH --job-name=emready
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
EMREADY=${BASE_DIR}/emready

MAP=${MAPS}/map.mrc
MASK=${MAPS}/mask.mrc
OUTPUT=${EMREADY}/output-map.mrc

module purge
module load emready/1.2.1

srun EMReady.sh \
	$MAP \
	$OUTPUT \
	-m $MASK \
	--interp_back

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

