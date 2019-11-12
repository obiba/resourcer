# Resource R

[![Build Status](https://travis-ci.com/obiba/resourcer.svg?branch=master)](https://travis-ci.com/obiba/resourcer)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/resourcer)](https://cran.r-project.org/package=resourcer)

The `resourcer` package is meant for accessing resources identified by a URL in a uniform way whether it references a dataset (stored in a file, a SQL table, a MongoDB collection etc.) or a computation unit (system commands, web services etc.). Usually some credentials will be defined, and an additional data format information can be provided to help dataset coercing to a data.frame object.

The main concepts are:

* _Resource_, access to a resource (dataset or computation unit) is described by an object with URL and credentials properties,
* _ResourceResolver_, a _ResourceClient_ factory based on the URL scheme and available in a resolvers registry,
* _ResourceClient_, realizes the connection with the dataset or the computation unit described by a _Resource_,
* _FileResourceGetter_, connect to a file described by a resource,
* _DBIResourceConnector_, establish a [DBI](https://www.r-dbi.org/) connection.

## File Resources

These are resources describing a file. If the file is in a remote location, it must be downloaded before being read. The data format specification of the resource helps to find the appropriate file reader.

The supported file locations are: `file` (local file system), `http`(s) (web address, basic authentication), `gridfs` (MongoDB file store), `s3` (Amazon Web Services S3 file store), `scp` (file copy through SSH) and `opal` (Opal file store). This can be easily applied to other file locations by extending the _FileResourceGetter_ class.

Currently supported data formats are:

* the data formats that have a reader in [tidyverse](https://www.tidyverse.org/): [readr](https://readr.tidyverse.org/) (`csv`, `csv2`, `tsv`), [haven](https://haven.tidyverse.org/) (`spss`, `sav`, `por`, `dta`, `stata`, `sas`, `xpt`), [readxl](https://readxl.tidyverse.org/) (`excel`, `xls`, `xlsx`). This can be easily applied to other data file formats by extending the _FileResourceClient_ class.
* the R data format that can be loaded in a child R environment from which object of interest will be retrieved.

Usage example that reads a local SPSS file:

```r
# make a SPSS file resource
res <- resourcer::newResource(
  name = "CNSIM1",
  url = "file:///data/CNSIM1.sav",
  format = "spss"
)

# coerce the csv file in the opal server to a data.frame
df <- as.data.frame(res)
```

## Computation Resources

Computation resources are resources on which tasks/commands can be triggerred and from which resulting data can be retrieved.

Example of computation resource that connects to a server through SSH:

```r
# make an application resource on a ssh server
res <- resourcer::newResource(
  name = "supercomp1",
  url = "ssh://server1.example.org/work/dir?exec=plink,ls",
  identity = "sshaccountid",
  secret = "sshaccountpwd"
)

# get ssh client from resource object
client <- resourcer::newResourceClient(res) # does a ssh::ssh_connect()

# execute commands
files <- client$exec("ls") # exec 'cd /work/dir && ls'

# release connection
client$close() # does ssh::ssh_disconnect(session)
```

## Extending Resources

There are several ways to extend the Resources handling. These are based on different R6 classes having a `isFor(resource)` function:

* If the resource is a file located at a place not already handled, write a new _FileResourceGetter_ subclass and register an instance of it with the function `registerFileResourceGetter()`.
* If the resource is a SQL engine having a DBI connector defined, write a new _DBIResourceConnector_ subclass and register an instance of it with the function `registerDBIResourceConnector()`.
* If the resource is in a domain specific web application or database, write a new _ResourceResolver_ subclass and register an instance of it with the function `registerResourceResolver()`. This _ResourceResolver_ object will create the appropriate _ResourceClient_ object that matches your needs.

The design of the URL that will describe your new resource should not overlap an existing one, otherwise the different registries will return the first instance for which the `isFor(resource)` is `TRUE`. In order to distinguish resource locations, the URL's scheme can be extended, for instance the scheme for accessing a file in a Opal server is `opal+https` so that the credentials be applied as needed by Opal.

