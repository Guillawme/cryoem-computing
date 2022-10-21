#!/usr/bin/env bash

#SBATCH --job-name=dm2mrc
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16GB
#SBATCH --oversubscribe
#SBATCH --output=dm2mrc.log
#SBATCH --error=dm2mrc.log
#SBATCH --open-mode=append

DM_EXTENSION=dm3 # this depends on the version of Digital Micrograph
RAW_DATA_DIR=raw
OUTPUT_DIR=mrc

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load imod

if [[ ! -d $OUTPUT_DIR ]]; then
	mkdir -p $OUTPUT_DIR
fi

for dmfile in ${RAW_DATA_DIR}/*.${DM_EXTENSION}; do
	dm2mrc $dmfile ${OUTPUT_DIR}/${dmfile}.mrc
done

