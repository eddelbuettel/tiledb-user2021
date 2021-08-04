library(tiledb)
library(tibble)

# ensembl annotations array -----------------------------------------------

# 1D sparse array, indexed by ensembl gene ids (e.g., ENSG00000169098)
tdb_ensembl <- tiledb_array(
  "s3://tiledb-conferences/bioc-2021/ensembl-grch38-ens104",
  as.data.frame = TRUE
)

# retrieve annotations for a specific ID
tibble(
  tdb_ensembl["ENSG00000152822", ]
)

# Update query to filter for a specific annotation type
query_condition(tdb_ensembl) <- parse_query_condition(type == "transcript")
tibble(
  tdb_ensembl["ENSG00000152822",]
)

# Specify which attributes should be retrieved
attrs(tdb_ensembl) <- c("gene_name", "transcript_id", "chrom", "pos_start", "pos_end")
tibble(
  tdb_ensembl["ENSG00000152822",]
)


# gtex rnseq array --------------------------------------------------------

# open the array and retrieve expression values for an individual gene
tdb_gtex <- tiledb_array(
  "s3://tiledb-conferences/bioc-2021/gtex-rnaseq-gene-tpms",
  as.data.frame = TRUE
)

tibble(
  tdb_gtex["ENSG00000202059.1", ]
)

# retrieve IDs for a particular group of samples
tdb_samples <- tiledb_array(
  uri = "s3://tiledb-conferences/bioc-2021/gtex-analysis-sample-attributes",
  as.data.frame = TRUE,
  attrs = "SMTS",
  query_condition = parse_query_condition(SMTS == "Skin")
)

tbl_samples <- tibble(tdb_samples[])

# retrieve expression values for a specific subset of samples
gene_id <- "ENSG00000202059.1"
samples <- tbl_samples$sample

selected_ranges(tdb_gtex) <- list(
  gene_id = cbind(gene_id, gene_id),
  sample = cbind(samples, samples)
)

tibble(tdb_gtex[])


# ukbiobank gwas array ----------------------------------------------------

tdb_gwas <- tiledb_array(
  "s3://tiledb-conferences/useR-2021/gwas/ukbiobank-gwasdb",
  as.data.frame = TRUE,
  attrs = c("beta", "se", "pval")
)

# use [] indexing to query the first 2 dimensions
tibble(tdb_gwas["Water intake", "20"])

# use `selected_ranges` to query all 3-dimensions and select a specific range
selected_ranges(tdb_gwas) <- list(
  phenotype = cbind("Water intake", "Water intake"),
  chr = cbind("20", "20"),
  pos = cbind(5e6, 6e6)
)

tibble(tdb_gwas[])
