include { PREPARE_RSEQC     } from '../../modules/local/prepare.nf'
include { GTF_TO_GENEPRED   } from '../../modules/local/gtftogenepred.nf'
include { GENEPRED_TO_BED   } from '../../modules/local/genepredtobed.nf'
include { GENEBODY_COVERAGE } from '../../modules/local/gene_body_coverage.nf'

workflow RSEQC {
  take:
    bam
    bai
    novel_gtf
    known_gtf
    prefix

  main:
    PREPARE_RSEQC(novel_gtf, known_gtf)

    GTF_TO_GENEPRED(PREPARE_RSEQC.out.flatten())
    GENEPRED_TO_BED(GTF_TO_GENEPRED.out)

    GENEBODY_COVERAGE(
      GENEPRED_TO_BED.out, 
      bai.collect(),
      bam.collect(),
      prefix
    )
}
