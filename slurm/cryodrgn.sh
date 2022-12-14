#!/usr/bin/env bash

## Template job submission script for SLURM
## for a cryoDRGN training job

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=
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

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitely (e.g. module/1.2.0)
module purge
module load cryodrgn

# Copy particles to a unique scratch directory
# Only useful if using the --lazy option below
SCRATCH_DIR=/scratch/cryodrgn/$SLURM_JOBID-$SLURM_JOB_NAME
mkdir -p $SCRATCH_DIR
rsync -auh $PARTICLES $SCRATCH_DIR/

# If continuing a previous run, add this option to the command:
# --load $SLURM_JOB_NAME/weights.49.pkl \

# Run training
srun cryodrgn train_vae \
	$SCRATCH_DIR/$PARTICLES \
	--lazy \ # only necessary if particles are on an SSD and won't fit in RAM
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

