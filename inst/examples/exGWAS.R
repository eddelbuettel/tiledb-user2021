library(tiledb.user2021)

library(tools)
library(tiledb)
library(tibble)
library(vroom)
library(ggplot2)

# variables ---------------------------------------------------------------
dir_data <- "gwas-tutorial/data"
array_uri <- "gwas-tutorial/ukbiobank-gwasdb"


# setup -------------------------------------------------------------------
dir.create(dir_data, showWarnings = FALSE, recursive = TRUE)

theme_set(
  theme_bw(8) +
    theme(
      plot.background = element_rect(fill = "transparent"),
      panel.background = element_rect(fill = "transparent"),
      strip.text = element_text(size = 5),
      strip.background = element_blank()
    )
)

# download gwas results files ---------------------------------------------
download_gwas_files(dir_data)

# create empty array ------------------------------------------------------

### specify the dimensions and domain ###

# GWAS trait dimension - each record represents a single GWAS
dim_pheno <- tiledb_dim(
  name = "phenotype",
  domain = NULL,
  tile = NULL,
  type = "ASCII"
)

# chromosome label dimension
dim_chr <- tiledb_dim(
    name = "chr",
    domain = NULL,
    tile = NULL,
    type = "ASCII"
  )

# chromosome position dimension
dim_pos <- tiledb_dim(
  name = "pos",
  domain = c(1L, 249250621L),
  tile = 1e4L,
  type = "UINT32"
)

# combine dimensions into a domain
gwas_dom <- tiledb_domain(dims = c(dim_pheno, dim_chr, dim_pos))

### specify the attributes ###
attr_filters <- tiledb_filter_list(tiledb_filter("ZSTD"))

gwas_attrs <- list(
  ref = tiledb_attr("ref", type = "CHAR", ncells = NA_integer_, filter_list = attr_filters),
  alt = tiledb_attr("alt", type = "CHAR", ncells = NA_integer_, filter_list = attr_filters),
  minor_AF = tiledb_attr("minor_AF", type = "FLOAT64", filter_list = attr_filters),
  pval =  tiledb_attr("pval", type = "FLOAT64", filter_list = attr_filters),
  tstat = tiledb_attr("tstat", type = "FLOAT64", filter_list = attr_filters),
  se  =  tiledb_attr("se", type = "FLOAT64", filter_list = attr_filters),
  beta =  tiledb_attr("beta", type = "FLOAT64", filter_list = attr_filters)
)

### build the schema ###
gwas_schema <- tiledb_array_schema(
  domain = gwas_dom,
  attrs = gwas_attrs,
  sparse = TRUE,
  allows_dups = TRUE
)

### create the array ###

# delete existing array
if (tiledb_vfs_is_dir(array_uri)) {
  tiledb_vfs_remove_dir(array_uri)
}

tiledb_array_create(
  uri = array_uri,
  schema = gwas_schema
)


# open the array ----------------------------------------------------------
gwasdb <- tiledb_array(
  array_uri,
  query_type = "WRITE",
  as.data.frame = TRUE
)


# ingest gwas result files ------------------------------------------------

# identify and name results files
gwas_files <- dir(dir_data, pattern = "csv.gz", full.names = TRUE)

names(gwas_files) <- basename(
  file_path_sans_ext(gwas_files, compression = TRUE)
)

# ingest each file into the array
for (i in seq_along(gwas_files)) {
  message(
    sprintf("\nReading results file: %s", gwas_files[i])
  )
  tbl_gwas <- vroom(gwas_files[i], col_types = cols(chr = col_character()))

  message(
    sprintf("Ingesting '%s' results into: %s", tbl_gwas$phenotype[1], array_uri)
  )
  gwasdb[] <- tbl_gwas
}

message("Done")


# query the array ---------------------------------------------------------

gwasdb <- tiledb_array(
  array_uri,
  is.sparse = TRUE,
  as.data.frame = TRUE,
  attrs = c("beta", "se", "tstat", "pval")
)

# use [] indexing to query by the first 2 dimensions
results <- tibble(gwasdb["Water intake", "20"])
x_lim <- range(results$pos)

# setup a ggplot to visualize results
manhattan_plot <- ggplot() +
  aes(pos, -log10(pval), color = phenotype) +
  geom_point(alpha = 0.5, shape = 16, size = 1, show.legend = FALSE) +
  scale_x_continuous(limits = x_lim)

manhattan_plot %+% results

# use `selected_ranges` to query all 3-dimensions and select a specific range
query_range <- list(
  phenotype = cbind("Water intake", "Water intake"),
  chr = cbind("20", "20"),
  pos = cbind(5e6, 6e6)
)

selected_ranges(gwasdb) <- query_range
results <- tibble(gwasdb[])

manhattan_plot %+% results

# query the same region across all phenotypes
query_range <- list(
  phenotype = NULL,
  chr = cbind("20", "20"),
  pos = cbind(5e6, 6e6)
)

selected_ranges(gwasdb) <- query_range
results <- tibble(gwasdb[])

manhattan_plot %+%
  results +
  facet_grid(phenotype ~ .) +
  scale_x_continuous()
