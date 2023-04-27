process FILTER {
  conda (params.enable_conda ? "conda-forge::python=3.10.4" : null)
  container "${ workflow.containerEngine == 'singularity' ? 
                'https://depot.galaxyproject.org/singularity/python:3.10.4' : 
                'quay.io/biocontainers/python:3.10.4' }"
  publishDir "$params.outdir/final", mode: 'copy'
  memory '80 GB'

  input:
  file novel
  file counts_tx
  file tfkmers
  file bambu_ndr

  output:
  path "novel.filter.gtf", emit: gtf
  path "counts_transcript.filter.txt", emit: tr_count_filter
  path "counts_transcript.full.txt", emit: tr_count_full

  """
  cp ${counts_tx} counts_transcript.full.txt

  filter_gtf_ndr.py \
    --gtf ${novel} \
    --counts_tx ${counts_tx} \
    --tfkmers ${tfkmers} \
    --bambu ${bambu_ndr} \
    --tfkmers-threshold ${params.tfkmers_threshold} \
    --bambu-threshold ${params.bambu_threshold} \
    --operation ${params.operation}

  GTF.py format -i unformat.novel.filter.gtf > novel.filter.gtf
  """
}
