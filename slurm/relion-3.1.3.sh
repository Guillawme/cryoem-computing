#!/usr/bin/env bash

#SBATCH --job-name=XXXnameXXX
#SBATCH --partition=main
#SBATCH --gres=gpu:XXXextra1XXX
#SBATCH --ntasks=XXXmpinodesXXX
#SBATCH --cpus-per-task=XXXthreadsXXX
#SBATCH --mem=XXXextra2XXXGB
#SBATCH --oversubscribe
#SBATCH --output=XXXoutfileXXX
#SBATCH --error=XXXerrfileXXX
#SBATCH --open-mode=append

## Set up environment
module purge
module load relion/3.1.3

## Print info
echo "=== JOB INFO ========================================="
echo -ne "Date:\t\t\t ";        date
echo -e "RELION version:\t\t"   $(relion --version)
echo -e "Working directory:\t"  $SLURM_SUBMIT_DIR
echo -e "SLURM_JOBID:\t\t"      $SLURM_JOBID
echo -e "Job name:\t\t"         XXXnameXXX
echo "CUDA version:";           nvcc --version
echo -e "Run command:";
echo 'XXXcommandXXX'
echo -e "=== JOB INFO =========================================\n"

## Run command
mpirun --oversubscribe -n XXXmpinodesXXX --bind-to none XXXcommandXXX

## Remove empty scratch directory if it is still around
if [[ -d /scratch/relion/$SLURM_JOBID-$SLURM_JOB_NAME ]]; then
        rm -r /scratch/relion/$SLURM_JOBID-$SLURM_JOB_NAME
fi

