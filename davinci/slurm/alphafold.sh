#!/usr/bin/env bash

## Template job submission script for SLURM
## for an AlphaFold prediction job

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=alphafold
#SBATCH --partition=slow
#SBATCH --constraint=RTX2080Ti
#SBATCH --gres=gpu:4
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# Configuration options
# See the documentation at: 
# https://github.com/google-deepmind/alphafold#running-alphafold
# https://github.com/google-deepmind/alphafold#examples
FASTA=lysozyme.fasta
MODEL=monomer # options are: monomer, monomer_casp14, monomer_ptm, multimer
NUM_MULTIMER_PREDICTIONS_PER_MODEL=1 # default is 5, try lower numbers if slurm job times out
MAX_TEMPLATE_DATE=2024-01-01
DB_PRESET=reduced_dbs # options are: reduced_dbs, full_dbs
RELAX_PREDICTED_MODEL=best # options are: best, all, none
RELAX_ON_GPU=true # default is true, faster but possibly less numerically stable than relaxing on CPU (set to false for this)
DATA_DIR=/scratch/burst/alphafold_data_2.3.1 # where the databases have been downloaded (installation-specific)
OUTPUT_DIR=run-01

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module purge
module load AlphaFold/2.3.2

srun run_alphafold.sh \
	-f $FASTA \
	-t $MAX_TEMPLATE_DATE \
	-m $MODEL \
	-l $NUM_MULTIMER_PREDICTIONS_PER_MODEL \
	-c $DB_PRESET \
	-d $DATA_DIR \
	-o $OUTPUT_DIR \
	-r $RELAX_PREDICTED_MODEL \
	-e $RELAX_ON_GPU \
	-g true \
	-a $CUDA_VISIBLE_DEVICES

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

