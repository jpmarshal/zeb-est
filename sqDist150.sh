#!/bin/bash
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=72:00:00
#SBATCH --job-name=step3_fitSqDist150.R
#SBATCH --output=/home-mscluster/jmarshal/output.txt
#SBATCH --workdir=/home-mscluster/jmarshal/

R CMD BATCH step3_fitSqDist150.R
