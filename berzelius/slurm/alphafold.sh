#!/usr/bin/env bash

## Template job submission script for SLURM
## for an AlphaFold prediction job

#SBATCH --account=berzelius-2024-31
#SBATCH --job-name=test-af
#SBATCH --partition=berzelius
#SBATCH --constraint=thin
#SBATCH --gpus=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128GB
#SBATCH --time=3-0:0:0
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
MAX_TEMPLATE_DATE=2024-01-01 # don't use PDB entries released after this date as templates
DB_PRESET=full_dbs # options are: reduced_dbs (faster), full_dbs (richer MSA)
RELAX_PREDICTED_MODEL=all # options are: best, all, none
RELAX_ON_GPU=true # default is true, faster but possibly less numerically stable than relaxing on CPU (set to false for this)
DATA_DIR=/proj/berzelius-2024-31/users/x_guiga/alphafold-data-2.3.2 # where the databases have been downloaded (installation-specific)
OUTPUT_DIR=/proj/berzelius-2024-31/users/x_guiga

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module load AlphaFold/2.3.2-hpc1

srun run_alphafold.sh \
	-f $FASTA \
	-t $MAX_TEMPLATE_DATE \
	-m $MODEL \
	-p $DB_PRESET \
	-d $DATA_DIR \
	-o $OUTPUT_DIR \
	-r $RELAX_PREDICTED_MODEL \
	-g $RELAX_ON_GPU \
	-P 3 \
	-F false
#	-u true # re-use existing MSA

# Generate final GPU and power usage report for this job
jobgraph --overwrite --jobid $SLURM_JOB_ID --outfile ${SLURM_JOB_NAME}-${SLURM_JOB_ID}

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

