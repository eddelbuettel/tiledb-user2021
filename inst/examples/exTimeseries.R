
library(tiledb)
library(data.table)

uri <- "dboerse"

setwd("~/git/tiledb-demo-dboerse/")   # local repo for me
files <- list.files(pattern="2020-.*\\.csv") # files retrieved Fall of 2020

readAndAddDatetime <- function(file) {  # simple helper
    D <- fread(file)
    setDT(D)
    D[, Datetime := as.POSIXct(paste(Date, Time))]
    D[, `:=`(Date = NULL, Time = NULL)]
    invisible(D)
}

n <- length(files)
for (i in seq_len(n)) {
    D <- readAndAddDatetime(files[i])
    if (i == 1) {
        fromDataFrame(D, uri, sparse = TRUE,
                      col_index=c("Mnemonic","Datetime"),
                      tile_domain=list(Datetime=c(as.POSIXct("1970-01-01 00:00:00"), Sys.time())))
    } else {
        arr <- tiledb_array(uri, as.data.frame = TRUE)
        arr[] <- D
        tiledb_array_close(arr)
    }
}

## one example
arr <- tiledb_array(uri, as.data.frame = TRUE)
selected_ranges(arr) <- list(Mnemonic=cbind("BMW", "BMW"),
                             Datetime=cbind(as.POSIXct("2020-11-04 09:00"),
                                            as.POSIXct("2020-11-04 10:00")))
BMW <- arr[]

suppressMessages({
    library(rtsplot)                        # for nicer financial plot
    library(xts)                            # used by rtsplot
})
setDT(BMW)
symbol <- "BMW"
rt <- as.xts(BMW[Mnemonic==symbol,
                 .(Datetime, Open=StartPrice, High=MaxPrice,
                   Low=MinPrice, Close=EndPrice, Volume=TradedVolume)])

cols <- rtsplot.colors(2)
layout(c(1,1,1,1,2))
rtsplot(rt, type="n")
rtsplot.ohlc(rt, col=rtsplot.candle.col(rt))
rtsplot.legend(symbol, cols[1], list(rt))
rt <- rtsplot.scale.volume(rt)
rtsplot(rt, type = 'volume', plotX = FALSE, col = 'darkgray')
rtsplot.legend('Volume', 'darkgray', quantmod::Vo(rt))
invisible()
