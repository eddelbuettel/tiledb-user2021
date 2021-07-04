
dom <- tiledb_domain(dims = tiledb_dim("rows", c(1L, 4L), 4L, "INT32"))
schema <- tiledb_array_schema(dom, attrs=tiledb_attr("a", type = "INT32"), sparse = TRUE)
uri <- tempfile()
enckey <- "0123456789abcdef0123456789ABCDEF"
invisible( tiledb_array_create(uri, schema, enckey) )

arr <- tiledb_array(uri, encryption_key = enckey)
arr[] <- data.frame(rows=1:4, a=101:104)

chk <- tiledb_array(uri, encryption_key = enckey, as.data.frame=TRUE)
chk[]
