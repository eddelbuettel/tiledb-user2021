# if needed: install.packages("tiledb")    	# installation from CRAN
library(tiledb)               		        # load the package
library(palmerpenguins)             		# example data
setwd("/tmp")                                   # or other scratch space

# create array from data frame with default settings
fromDataFrame(penguins, "penguins")

# read array as data.frame and without (default, added) row index
arr <- tiledb_array("penguins", as.data.frame=TRUE, extended=FALSE)
show(arr)                           		# some array information


df <- arr[]
str(df)
