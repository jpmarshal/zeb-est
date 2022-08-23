#!/bin/bash
#SBATCH --partition=stampede
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=72:00:00
#SBATCH --job-name=TestParallel.R
#SBATCH --output=/home-mscluster/jmarshal/output.txt
#SBATCH --workdir=/home-mscluster/jmarshal/

R CMD BATCH TestParallel.R
