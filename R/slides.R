##' Display the included pdf slides
##'
##' The function relies on the internal function \code{pdf_viewer}
##' which we are borrowing with grateful acknowledgement from R Core
##' and the \code{RShowDoc} function.
##' @title Display the tutorial slides
##' @return The return code from calling the viewer function
##' @author Dirk Eddelbuettel
slides <- function() {
    pdf_viewer <- function(path) {      # borrowed with thanks from RShowDoc() in base R
        pdfviewer <- getOption("pdfviewer")
        if (identical(pdfviewer, "false")) {
        } else if (.Platform$OS.type == "windows" &&
                   identical(pdfviewer, file.path(R.home("bin"), "open.exe")))
            shell.exec(path)
        else
            system2(pdfviewer, shQuote(path), wait = FALSE)
    }
    pdf_file <- system.file("pdf", "slides.pdf", package="tiledb.user2021")
    stopifnot(`slides.pdf not found`=file.exists(pdf_file))
    pdf_viewer(pdf_file)
}
