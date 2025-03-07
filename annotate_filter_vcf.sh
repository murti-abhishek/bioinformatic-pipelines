#!/bin/bash

# Check for required arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input.vcf> <reference.gtf> <output_filtered.vcf>"
    exit 1
fi

# Input arguments
VCF_FILE=$1
GTF_FILE=$2
OUTPUT_VCF=$3

module load CBI
module load bcftools
module loac bedtools2

# Convert GTF to BED format (Extract gene names)
echo "Converting GTF to BED format..."
awk '$3 == "gene" {for(i=9; i<=NF; i++) if($i ~ /gene_name/) print $1 "\t" $4-1 "\t" $5 "\t" $(i+1)}' $GTF_FILE | sed 's/"//g; s/;//g' > genes.bed

# Annotate VCF using bcftools annotate
echo "Annotating VCF with gene names..."
bcftools annotate -a genes.bed -c CHROM,FROM,TO,INFO/GENE -h <(echo '##INFO=<ID=GENE,Number=1,Type=String,Description="Gene Name">') -o annotated.vcf $VCF_FILE

# Filter VCF to only keep SNPs that have gene annotations
echo "Filtering VCF to only keep SNPs in genes..."
bcftools view -i 'INFO/GENE!=""' annotated.vcf -o $OUTPUT_VCF

echo "Done! Filtered VCF saved as: $OUTPUT_VCF"
