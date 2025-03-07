#!/bin/bash

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input.vcf> <pca_output_prefix>"
    exit 1
fi

# Input arguments
VCF_FILE=$1
PCA_OUTPUT_PREFIX=$2

module load CBI
module load plink

echo "Running PCA on SNPs..."

plink --vcf $VCF_FILE --allow-extra-chr --make-bed --out temp
plink --bfile temp --allow-extra-chr --pca 10 --out $PCA_OUTPUT_PREFIX

echo "Done! PCA results stored with $PCA_OUTPUT_PREFIX prefix"
echo "Use $PCA_OUTPUT_PREFIX.eigenvec for downstream PCA analysis"