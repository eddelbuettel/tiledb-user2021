.onAttach <- function(libname, pkgName) {
    if (interactive()) {
        exdir <- system.file("examples", package="tiledb.user2021")
        packageStartupMessage("TileDB at useR! 2021 helper package. Use slides() to see the slides. Examples are in directory '", exdir, "'.")
    }
}
