#!/usr/bin/env bash

## Template job submission script for SLURM
## for a cryoDRGN training job

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=cryodrgn
#SBATCH --partition=main
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=run.log
#SBATCH --error=run.log
#SBATCH --open-mode=append

# Configuration options
OUTPUT_DIR=$SLURM_JOB_NAME
PARTICLES=
POSES=
CTF=
ZDIM=8
LAYERS=3
DIM=128
EPOCHS=20

# If continuing a previous run, add this option to the command:
# (make sure you specify the correct epoch as new starting point)
# --load $SLURM_JOB_NAME/weights.49.pkl \

# Load cryodrgn
module purge
module load cryodrgn/1.1.0

# Copy particles to a unique scratch directory
# This is only relevant when using the --lazy option
# as without --lazy the particles are read in RAM
SCRATCH_DIR=/scratch/cryodrgn/$SLURM_JOBID-$SLURM_JOB_NAME
mkdir -p $SCRATCH_DIR
rsync -auh $PARTICLES $SCRATCH_DIR/

# Run training
srun cryodrgn train_vae \
	$SCRATCH_DIR/$PARTICLES \
	--lazy \ # only necessary if using a scratch directory
	--multigpu \ # only necessary if requesting more than 1 GPU
	--max-threads 32 \ # set this to the same value as --cpus-per-task
	--outdir $OUTPUT_DIR \
	--poses $POSES \
	--ctf $CTF \
	--num-epochs $EPOCHS \
	--zdim $ZDIM \
	--enc-layers $LAYERS \
	--enc-dim $DIM \
	--dec-layers $LAYERS \
	--dec-dim $DIM

# Clear scratch space
rm -r $SCRATCH_DIR

