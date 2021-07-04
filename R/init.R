.onAttach <- function(libname, pkgName) {
    if (interactive()) {
        packageStartupMessage("TileDB at useR! 2021 helper package.")
    }
}
