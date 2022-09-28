#!/usr/bin/env bash

## Template job submission script for SLURM

## Fill in missing info below
## (replace <placeholders> with adequate values)
## Once this script is ready, save it in your job directory
## and run it with the command: sbatch job-script.sh
## You can see the status of your job in the queue with the command: squeue

#SBATCH --job-name=<your job name (no spaces)>
#SBATCH --partition=main
#SBATCH --gres=gpu:<number of GPUs (max 4)>
#SBATCH --ntasks=<number of MPI processes, or number of commands in this file that can run concurrently (set to 1 if not using OpenMPI and using a single command or multiple commands that must run sequentially)>
#SBATCH --cpus-per-task=<number of threads (the value of ntasks * cpus-per-task cannot exceed 80)>
#SBATCH --mem=<RAM in GB (max 720, safe to request more than what you think your job needs)>GB
#SBATCH --oversubscribe
#SBATCH --output=</path/to/your/working/directory/run.log>
#SBATCH --error=</path/to/you/working/directory/run.err>
#SBATCH --open-mode=append

# Indicate the adequate modules to load for your job here (if not using any module, simply delete these two lines)
module purge
module load #<module1> <module2>

# Activate the adequate conda environment for your job here (if not using conda, simply delete these two lines)
conda deactivate
conda activate #<conda-env>

# Write your commands below

srun # command 1
srun # command 2, etc.

