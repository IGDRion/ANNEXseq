include { EXTRACT_TSS_REGIONS   } from '../../modules/local/extract_regions.nf'
include { EXTRACT_TSS_SEQUENCES } from '../../modules/local/extract_sequences.nf'
include { PREDICT               } from '../../modules/local/predict.nf'
include { FILTER                } from '../../modules/local/filter.nf'

workflow TFKMERS {
  take:
    novel_gtf
    ref_fa
    bambu_ndr
    tokenizer
    model
    counts_tx

  main:
    EXTRACT_TSS_REGIONS(
      novel_gtf
    )

    EXTRACT_TSS_SEQUENCES(
      EXTRACT_TSS_REGIONS.out.tss_regions,
      ref_fa
    )

    PREDICT(
      EXTRACT_TSS_SEQUENCES.out.tss_sequences,
      tokenizer,
      model
    )

    FILTER(
      novel_gtf,
      counts_tx,
      PREDICT.out,
      bambu_ndr
    )

  emit:
    gtf = FILTER.out.gtf
    ch_transcript_counts_full = FILTER.out.tr_count_full
    ch_transcript_counts_filter = FILTER.out.tr_count_filter
}
