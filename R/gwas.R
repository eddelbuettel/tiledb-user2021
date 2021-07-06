#' Download GWAS UK Biobank GWAS Results
#'
#' @param dest Local directory where the files will be downloaded to.
#' @param ... Additional arguments passed to `base::download.file()`.
#' @export

download_gwas_files <- function(dest = getwd(), ...) {
  stopifnot(dir.exists(dest))
  base_url <- "https://d2bhdmg3cnqh5a.cloudfront.net/useR-2021/gwas/ukbiobank-gwas-results"

  filenames <- c(
    "102280.gwas.imputed_v3.both_sexes.tsv.csv.gz",
    "12336_irnt.gwas.imputed_v3.both_sexes.tsv.csv.gz",
    "1528.gwas.imputed_v3.both_sexes.tsv.csv.gz",
    "1940.gwas.imputed_v3.both_sexes.tsv.csv.gz",
    "20458.gwas.imputed_v3.both_sexes.tsv.csv.gz",
    "6039.gwas.imputed_v3.both_sexes.tsv.csv.gz"
  )

  for (file in filenames) {
    download.file(
      url = paste0(c(base_url, file), collapse = "/"),
      destfile = file.path(dest, file),
      ...
    )
  }
}
