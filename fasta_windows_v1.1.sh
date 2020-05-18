#!/bin/bash

###########################################################################
# Create sliding window sequences from fasta file
# Kim Dill-McFarland, UW 2020
#
# Assumptions:
# - Input file is in fasta format with 1 line for each name and
#   1 line for each sequence
#
# Usage:
# bash fasta_windows.sh <fasta> <window size> <slide size>
#
# fasta = fasta formatted sequences with 1 line for each name and
#         1 line for each sequence
# window size = length of desired window sequences in bp
# slide size = length to slide each window over in bp
#
###########################################################################

usage="Usage: $0 <fasta> <window size> <slide size>"

if [ -z "$3" ]
then
  echo $usage
  exit
fi

inFasta=$1
inW=$2
inS=$3

## Remove result file if already exists
final_name=$(paste -d '_' \
              <(echo 'windows') \
              <(basename $inFasta))
rm -f $final_name

## Separate sequences in fasta file
echo "> Splitting fasta sequences"
mkdir -p ./fasta_indiv

### Remove alignment formating within sequences
awk '!(NR%2) {gsub("-","")}{print}' $inFasta > ./fasta_indiv/inFasta_format.fasta

### Separate
awk '/^>/{close(s); s="fasta_indiv/"++d".fa"} {print > s}' < ./fasta_indiv/inFasta_format.fasta

## Make sliding windows
mkdir -p window_results

for indiv_f in fasta_indiv/*.fa ;
do
  # Get sequence name
  seqName=$(awk 'NR==1; ORS=""; OFS=""' $indiv_f | sed 'y/>/ /')
  echo ">" $seqName
  
  # Create result file name
  filename=$(paste -d '_' \
              <(echo 'window_results/windows') \
              <(basename $indiv_f))
              
  # Calculate number of windows
  ## Total characters in sequence
  length=$(awk 'FNR == 2' $indiv_f | wc -m)
  ## Calcuate total complete windows
  total=$((($length-$inW)/$inS))

  ## Exit with error if sequence does not create at least 2 windows
  if (( $total < 2 ));
  then
      echo ">>> Sequence is too short to create windows of desired size and slide. Sequence will be skipped."
      continue
  else
      echo ">>> Creating" $total "windows"
  fi
  
  # Create windows
  for i in `seq 1 $total`;
  do
    # Define start and end of window
    start=$((1 + ($i-1)*$inS))
    end=$(($start + $inW -1))

    # Create window name
    nameW=$(paste -d '_' \
              <(echo '>window') \
              <(echo $start) \
              <(echo $end) \
              <(echo $seqName))
              
    echo $nameW >> $filename
    
    # Get window sequence
    awk 'FNR == 2' $indiv_f | \
      awk -v start="$start" -v w="$inW" '{ print substr($1, start, w) }' \
      >> $filename
    
  done
         
done

## Combine results
echo "> Combining window results"
cat window_results/*.fa >> $final_name

## Remove intermediate files
rm -R fasta_indiv
rm -R window_results

echo "> FIN"