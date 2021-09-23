# Resource R

[![Build Status](https://www.travis-ci.com/obiba/resourcer.svg?branch=master)](https://app.travis-ci.com/github/obiba/resourcer)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/resourcer)](https://cran.r-project.org/package=resourcer)

The `resourcer` package is meant to access resources identified by a URL in a uniform way whether it references a dataset (stored in a file, a SQL table, a MongoDB collection etc.) or a computation unit (system commands, web services etc.). Usually some credentials will be defined, and an additional data format information can be provided to help dataset coercing to a data.frame object.

The main concepts are:

* _Resource_, access to a resource (dataset or computation unit) is described by an object with URL, optional credentials and optional data format properties,
* _ResourceResolver_, a _ResourceClient_ factory based on the URL scheme and available in a resolvers registry,
* _ResourceClient_, realizes the connection with the dataset or the computation unit described by a _Resource_,
* _FileResourceGetter_, connect to a file described by a resource,
* _DBIResourceConnector_, establish a [DBI](https://www.r-dbi.org/) connection.

## Install

Install from CRAN:

```
install.packages("resourcer")
```

The resourcer has quite some suggested dependencies. These are only suggestions, meaning that it will depend on
the kind of resource that will be accessed at runtime.

### Tidy files

* [haven](https://cran.r-project.org/package=haven): Import and Export 'SPSS', 'Stata' and 'SAS' Files
* [readr](https://cran.r-project.org/package=readr): Read Rectangular Text Data
* [readxl](https://cran.r-project.org/package=readxl): Read Excel Files
* [dplyr](https://cran.r-project.org/package=dplyr): A Grammar of Data Manipulation

### Databases

* [dbplyr](https://cran.r-project.org/package=dbplyr): A 'dplyr' Back End for Databases
* [DBI](https://cran.r-project.org/package=DBI): R Database Interface
* [RMariaDB](https://cran.r-project.org/package=RMariaDB): Database Interface and 'MariaDB' Driver
* [RPostgres](https://cran.r-project.org/package=RPostgres): 'Rcpp' Interface to 'PostgreSQL'
* [sparklyr](https://cran.r-project.org/package=sparklyr): R Interface to Apache Spark
* [RPresto](https://cran.r-project.org/package=RPresto): DBI Connector to Presto
* [nodbi](https://cran.r-project.org/package=nodbi): 'NoSQL' Database Connector
* [mongolite](https://cran.r-project.org/package=mongolite): Fast and Simple 'MongoDB' Client for R

### Remote computation server

* [ssh](https://cran.r-project.org/package=ssh): Secure Shell (SSH) Client for R

### System dependencies

R packages often depend on system libraries or other software external to R. These dependencies are not automatically installed.

See the provided example script for installing the system requirements, per R package, for a Ubuntu 18.04 system: [install-system-requirements-ubuntu18.sh](https://github.com/obiba/resourcer/blob/master/inst/system/install-system-requirements-ubuntu18.sh)

## File Resources

These are resources describing a file. If the file is in a remote location, it must be downloaded before being read. The data format specification of the resource helps to find the appropriate file reader.

### File Getter

The file locations supported by default are: 

* `file`, local file system, 
* `http`(s), web address, basic authentication, 
* `gridfs`, MongoDB file store,
* `scp`, file copy through SSH,
* `opal`, [Opal](https://www.obiba.org/pages/products/opal/) file store. 

This can be easily applied to other file locations by extending the _FileResourceGetter_ class. An instance of the new file resource getter is to be registered so that the _FileResourceResolver_ can operate as expected.

```
registerFileResourceGetter(MyFileLocationResourceGetter$new())
```

### File Data Format

The data format specified within the _Resource_ object, helps at finding the appropriate file reader. Currently supported data formats are:

* the data formats that have a reader in [tidyverse](https://www.tidyverse.org/): [readr](https://readr.tidyverse.org/) (`csv`, `csv2`, `tsv`, `ssv`, `delim`), [haven](https://haven.tidyverse.org/) (`spss`, `sav`, `por`, `dta`, `stata`, `sas`, `xpt`), [readxl](https://readxl.tidyverse.org/) (`excel`, `xls`, `xlsx`). This can be easily applied to other data file formats by extending the _FileResourceClient_ class.
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

To support other file data format, extend the _FileResourceClient_ class with the new data format reader implementation. Associate factory class, an extension of the _ResourceResolver_ class is also to be implemented and registered.

```
registerResourceResolver(MyFileFormatResourceResolver$new())
```

## Database Resources

### DBI Connectors

[DBI](https://www.r-dbi.org/) is a set of virtual classes that are are used to abstract the SQL database connections and operations within R. Then any DBI implementation can be used to access to a SQL table. Which DBI connector to be used is an information that can be extracted from the scheme part of the resource's URL. For instance a resource URL starting with `postgres://` will require the [RPostgres](https://rpostgres.r-dbi.org/) driver. To separate the DBI connector instanciation from the DBI interface interactions in the _SQLResourceClient_, a _DBIResourceConnector_ registry is to be populated. The currently supported SQL database connectors are:

* `mariadb` MariaDB connector,
* `mysql` MySQL connector,
* `postgres` or `postgresql` Postgres connector,
* `presto`, `presto+http` or `presto+https` [Presto](https://prestodb.io/) connector,
* `spark`, `spark+http` or `spark+https` [Spark](https://spark.apache.org/) connector.

To support another SQL database having a DBI driver, extend the _DBIResourceConnector_ class and register it:

```
registerDBIResourceConnector(MyDBResourceConnector$new())
```

### Use dplyr

Having the data stored in the database allows to handle large (common SQL databases) to big (PrestoDB, Spark) datasets using [dplyr](https://dplyr.tidyverse.org/) which will delegate as much as possible operations to the database.

### Document Databases

NoSQL databases can be described by a resource. The [nodbi](https://docs.ropensci.org/nodbi/) can be used here. Currently only connection to MongoDB database is supported using URL scheme `mongodb` or `mongodb+srv`.

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

## Resource Forms

As it can be error prone to define a new resource, when a URL is complex, or when there is a limited choice of formats or when credentials can be on different types, it is recommended to declare the resources forms and factory functions within the R package. This resource declaration is to be done in javascript, as this is a very commonly used language for building graphical user interfaces.

These files are expected to be installed at the root of the package folder (then in the source code of the R package, they will be declared in the `inst/resources` folder), so that an external application can lookup statically the packages having declared some resources.

The configuration file `inst/resources/resource.js` is a javascript file which contains an object with the properties:

* `settings`, a JSON object that contains the description and the documentation of the web forms (based on the [json-schema](http://json-schema.org) specification).
* `asResource`, a javascript function that will convert the data captured from one of the declared web forms into a data structure representing the `resource` object.

As an example (see also [resourcer's resource.js](https://github.com/obiba/resourcer/blob/master/inst/resources/resource.js)):

```javascript
var myPackage = {
  settings: {
    "title": "MyPackage resources",
    "description": "MyPackage resources are for etc.",
    "web": "https://github.com/org/myPackage",
    "categories": [
      {
        "name": "my-format",
        "title": "My data format",
        "description": "Data are files in my format, that will be read by myPackage etc."
      }
    ],
    "types": [
      {
        "name": "my-format-http",
        "title": "My data format - HTTP",
        "description": "Data are files in my format, that will be downloaded from a HTTP server etc.",
        "tags": ["my-format", "http"],
        "parameters": {},
        "credentials": {}
      }
    ]
  },
  asResource: function(type, name, params, credentials) {
    // make a resource object from arguments, using type to drive 
    // what params/credentials properties are to be used
    // a basic example of resource object:
    return {
      "name": name,
      "url": params.url,
      "format": params.format,
      "identity": credentials.username,
      "secret": credentials.password
    };
  }
}
```

The specifications for the `resource.js` file are the following:

* `settings` object:

Property | Type | Description
--- | --- | ---
**title** | `string` | The title of the set of resources.
**description** | `string` | The description of the set of resources.
**web** | `string` | A web link that describes the resources.
**categories** | `array` of `object` | A list of `category` objects which are used to categorize the declared resources in terms of resource location, format, usage etc.
**types** | `array` of `object` | A list of `type` objects which contains a description of the parameters and credentials forms for each type of resource.

* `category` object:

Property | Type | Description
--- | --- | ---
**name** | `string` | The name of the category that will be applied to each resource `type`, must be unique.
**title** | `string` | The title of the category.
**description** | `string` | The description of the category.

* `type` object:

Property | Type | Description
--- | --- | ---
**name** | `string` | The identifying name of the resource, must be unique.
**title** | `string` | The title of the resource.
**description** | `string` | The description of the resource form.
**tags** | `array` of `string` | The `tag` names that are applied to the resource form.
**parameters** | `object` | The form that will be used to capture the parameters to build the *url* and the *format* properties of the resource (based on the [json-schema](http://json-schema.org) specification). Some specific fields can be used: `_package` to capture the R package name or `_packages` to capture an array of R package names to be loaded prior to the resource assignment. 
**credentials** | `object` | The form that will be used to capture the access credentials to build the *identity* and the *secret* properties of the resource (based on the [json-schema](http://json-schema.org) specification).

* `asResource` function: a javascript function which signature is `function(type, name, params, credentials)` where:
  * `type`, the form name used to capture the resource parameters and credentials,
  * `name`, the name to apply to the resource,
  * `params`, the captured parameters,
  * `credentials`, the captured credentials.
  
The name of the root object must follow the pattern: `<R package>` (note that any dots (`.`) in the R package name are to be replaced by underscores (`_`)).
