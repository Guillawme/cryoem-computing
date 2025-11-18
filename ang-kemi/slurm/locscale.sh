#!/usr/bin/env bash

#SBATCH --job-name=locscale
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source /opt/slurm/slurm-start.sh

BASE_DIR=/home/you/project

MAPS=${BASE_DIR}/maps
LOCSCALE_DIR=${BASE_DIR}/locscale

HALF_MAPS=${MAPS}/cryosparc_P489_J38_010_volume_map_half_?.mrc
MASK=${MAPS}/cryosparc_P489_J38_010_volume_mask_refine.mrc
POINT_GROUP=D4
OUTPUT_PREFIX=locscale-fem

module purge
module load locscale/2.0

srun locscale feature_enhance \
	--halfmap_paths ${HALF_MAPS} \
	--mask ${MASK} \
	--symmetry ${POINT_GROUP} \
	--print_report \
	--report_filename ${OUTPUT_PREFIX}.pdf \
	--verbose \
	--gpu_ids 0 \
	--output_processing_files ${LOCSCALE_DIR} \
	-o ${OUTPUT_PREFIX}.mrc

# Send notification upon job completion
source /opt/slurm/slurm-completion.sh

