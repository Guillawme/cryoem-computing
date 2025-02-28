#!/usr/bin/env bash

## Template job submission script for SLURM
## for a cryoDRGN training job

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=cryodrgn
#SBATCH --partition=cryoem
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --oversubscribe
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.log
#SBATCH --open-mode=append

# Send notification when job actually starts
# (Sometimes it remains in pending status for a while)
source $HOME/opt/slurm/slurm-start.sh

# Configuration options
OUTPUT_DIR=run-01
PARTICLES=JL08-P189-J87_particles_box128.ft.txt
CTF=JL08-P189-J87_ctf.pkl
ZDIM=8
LAYERS=3
DIM=256
EPOCHS=50
BATCH_SIZE=4
RESUME_FROM=${OUTPUT_DIR}/weights.29.pkl
RESUME_POSES=${OUTPUT_DIR}/pose.29.pkl

# Remember to check which modulefile version is the default one
# You might want to specify a version explicitly (e.g. module/1.2.0)
module purge
module load cryodrgn/3.4.1

# If continuing a previous run, add this option to the command:
# --load $SLURM_JOB_NAME/weights.49.pkl \

# If the job runs out of memory, try increasing --mem in the SBATCH options above
# Alternatively, add the --lazy option to the command below (this reads particles
# from storage, without preloading them all in RAM; likely slower)

# Run training
srun cryodrgn abinit_het \
	--load $RESUME_FROM \
	--load-poses $RESUME_POSES \
	--preprocessed \
	--batch-size $BATCH_SIZE \
	--outdir $OUTPUT_DIR \
	--ctf $CTF \
	--num-epochs $EPOCHS \
	--zdim $ZDIM \
	--enc-layers $LAYERS \
	--enc-dim $DIM \
	--dec-layers $LAYERS \
	--dec-dim $DIM \
	$PARTICLES

# Send notification when job completes
source $HOME/opt/slurm/slurm-completion.sh

