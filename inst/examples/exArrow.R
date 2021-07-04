
suppressMessages({
    library(tiledb)
    library(arrow)
})

val <- 1:3     # arbitrary, could be rnorm() too
typ <- int8()  # any Arrow type
vec <- Array$create(val, typ)           # Arrow vector

aa <- tiledb_arrow_array_ptr()
as <- tiledb_arrow_schema_ptr()
on.exit({
    tiledb_arrow_array_del(aa)
    tiledb_arrow_schema_del(as)
})
arrow:::ExportArray(vec, aa, as)  # export Arrow to TileDB

newvec <- arrow::Array$create(arrow:::ImportArray(aa, as))
stopifnot(all.equal(vec, newvec))
print(newvec)   # show round-turn
