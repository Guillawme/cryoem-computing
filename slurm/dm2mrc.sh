#!/usr/bin/env bash

#SBATCH --job-name=dm2mrc
#SBATCH --partition=main
#SBATCH --gres=gpu:0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=dm2mrc.log
#SBATCH --error=dm2mrc.log
#SBATCH --open-mode=append

RAW_DATA_DIR=raw
OUTPUT_DIR=mrc

module purge
module load imod

if [[ ! -d $OUTPUT_DIR ]]; then
	mkdir -p $OUTPUT_DIR
fi

for dmfile in $RAW_DATA_DIR/*.dm3; do
	dm2mrc $dmfile $dmfile.mrc;
done

mv $RAW_DATA_DIR/*.mrc $OUTPUT_DIR/

