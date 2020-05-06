var resourcer = {
  settings: {
    "title": "Base Resources",
    "description": "Provides some of the most common resources: file, mysql, mariadb, postgresql, mongodb, ssh, scp.",
    "web": "https://github.com/obiba/resourcer",
    "categories": [
      {
        "name": "data-file",
        "title": "Data file",
        "description": "Data are stored in a file that is to be downloaded from a remote location or accessed directly."
      },
      {
        "name": "commands",
        "title": "Commands",
        "description": "Analysis commands can be executed locally or on a remote server."
      },
      {
        "name": "database",
        "title": "Database",
        "description": "Data are stored in a database."
      },
      {
        "name": "analytics",
        "title": "Analytic system",
        "description": "Advanced analysis can be executed on a system."
      },
      {
        "name": "tidy-format",
        "title": "Tidy format",
        "description": "Data are structured in a tidy format having a reader in the [tidyverse](https://www.tidyverse.org) ecosystem."
      },
      {
        "name": "rdata-format",
        "title": "R data format",
        "description": "Data are stored in R data format."
      },
      {
        "name": "opal",
        "title": "Opal",
        "description": "The resource is in a Opal file store."
      },
      {
        "name": "gridfs",
        "title": "MongoDB GridFS",
        "description": "The resource is in a MongoDB's GridFS file store."
      },
      {
        "name": "http",
        "title": "HTTP",
        "description": "The resource is accessible using a HTTP connection."
      },
      {
        "name": "local",
        "title": "Local",
        "description": "The resource is in the R server's local file system."
      },
      {
        "name": "ssh",
        "title": "SSH",
        "description": "The resource is accessible using a SSH connection."
      },
      {
        "name": "others",
        "title": "Others",
        "description": "Other types of resources."
      }
    ],
    "types": [
      {
        "name": "default",
        "title": "Default",
        "description": "Default resource form.",
        "tags": ["others"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "URL to access the resource, required."
            },
            {
              "key": "format",
              "type": "string",
              "title": "Format",
              "description": "Data format, as it would be meaningful for a resource interpreter, optional."
            },
            {
              "key": "_package",
              "type": "string",
              "title": "R Package",
              "description": "R package name, to be loaded prior to the resource assignment, so that resource resolution process takes place."
            }
          ],
          "required": [
            "url"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are optional.",
          "items": [
            {
              "key": "identifier",
              "type": "string",
              "title": "Identifier",
              "description": "Identifier or user name."
            },
            {
              "key": "secret",
              "type": "string",
              "title": "Secret",
              "format": "password",
              "description": "Secret key or password."
            }
          ]
        }
      },
      {
        "name": "gridfs-rdata-file",
        "title": "R data file - MongoDB GridFS",
        "description": "File resource in R data format. The file will be downloaded from the GridFS file store of a MongoDB server.",
        "tags": ["gridfs", "data-file", "rdata-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address of the MongoDB server."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "default": 27017,
              "description": "MongoDB port number."
            },
            {
              "key": "db",
              "type": "string",
              "title": "Database",
              "description": "MongoDB database name."
            },
            {
              "key": "file",
              "type": "string",
              "title": "File",
              "description": "File name."
            },
            {
              "key": "format",
              "type": "string",
              "title": "R object class",
              "description": "The primary class of the R object that is being loaded from the R data file. When there are several objects of this class, the one with the symbol with same name as the resource is chosen, otherwise the first one is selected."
            }
          ],
          "required": [
            "host", "port", "db", "file", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are optional.",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid MongoDB user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ]
        }
      },
      {
        "name": "gridfs-tidy-file",
        "title": "Tidy data file - MongoDB GridFS",
        "description": "File resource in tidy format, having a reader in the [tidyverse](https://www.tidyverse.org) ecosystem. The file will be downloaded from the GridFS file store of a MongoDB server.",
        "tags": ["gridfs", "data-file", "tidy-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address of the MongoDB server."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "default": 27017,
              "description": "MongoDB port number."
            },
            {
              "key": "db",
              "type": "string",
              "title": "Database",
              "description": "MongoDB database name."
            },
            {
              "key": "file",
              "type": "string",
              "title": "File",
              "description": "File name."
            },
            {
              "key": "format",
              "type": "string",
              "title": "Format",
              "description": "Data format that can help when trying to coerce the file content to a data.frame.",
              "enum": [
                {
                  "key": "csv",
                  "title": "CSV (comma delimiter)"
                },
                {
                  "key": "csv2",
                  "title": "CSV2 (semicolon delimiter)"
                },
                {
                  "key": "ssv",
                  "title": "SSV (space delimiter)"
                },
                {
                  "key": "tsv",
                  "title": "TSV (tab delimiter)"
                },
                {
                  "key": "spss",
                  "title": "SPSS"
                },
                {
                  "key": "sav",
                  "title": "SAV"
                },
                {
                  "key": "por",
                  "title": "POR"
                },
                {
                  "key": "stata",
                  "title": "STATA"
                },
                {
                  "key": "dta",
                  "title": "DTA"
                },
                {
                  "key": "sas",
                  "title": "SAS"
                },
                {
                  "key": "xpt",
                  "title": "XPT"
                },
                {
                  "key": "excel",
                  "title": "EXCEL"
                },
                {
                  "key": "xls",
                  "title": "XLS"
                },
                {
                  "key": "xlsx",
                  "title": "XLSX"
                }
              ]
            }
          ],
          "required": [
            "host", "port", "db", "file", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are optional.",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid MongoDB user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ]
        }
      },
      {
        "name": "http-rdata-file",
        "title": "R data file - HTTP",
        "description": "File resource in R data format. The file will be downloaded from a HTTP server.",
        "tags": ["http", "data-file", "rdata-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "Address to download the file."
            },
            {
              "key": "format",
              "type": "string",
              "title": "R object class",
              "description": "The primary class of the R object that is being loaded from the R data file. When there are several objects of this class, the one with the symbol with same name as the resource is chosen, otherwise the first one is selected."
            }
          ],
          "required": [
            "url", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are optional. If provided, `Basic` authorization header is applied.",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ]
        }
      },
      {
        "name": "http-tidy-file",
        "title": "Tidy data file - HTTP",
        "description": "File resource in tidy format, having a reader in the [tidyverse](https://www.tidyverse.org) ecosystem. The file will be downloaded from a HTTP server.",
        "tags": ["http", "data-file", "tidy-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "Address to download the file."
            },
            {
              "key": "format",
              "type": "string",
              "title": "Format",
              "description": "Data format that can help when trying to coerce the file content to a data.frame.",
              "enum": [
                {
                  "key": "csv",
                  "title": "CSV (comma delimiter)"
                },
                {
                  "key": "csv2",
                  "title": "CSV2 (semicolon delimiter)"
                },
                {
                  "key": "ssv",
                  "title": "SSV (space delimiter)"
                },
                {
                  "key": "tsv",
                  "title": "TSV (tab delimiter)"
                },
                {
                  "key": "spss",
                  "title": "SPSS"
                },
                {
                  "key": "sav",
                  "title": "SAV"
                },
                {
                  "key": "por",
                  "title": "POR"
                },
                {
                  "key": "stata",
                  "title": "STATA"
                },
                {
                  "key": "dta",
                  "title": "DTA"
                },
                {
                  "key": "sas",
                  "title": "SAS"
                },
                {
                  "key": "xpt",
                  "title": "XPT"
                },
                {
                  "key": "excel",
                  "title": "EXCEL"
                },
                {
                  "key": "xls",
                  "title": "XLS"
                },
                {
                  "key": "xlsx",
                  "title": "XLSX"
                }
              ]
            }
          ],
          "required": [
            "url", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are optional. If provided, `Basic` authorization header is applied.",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ]
        }
      },
      {
        "name": "local-rdata-file",
        "title": "R data file - local",
        "description": "File resource in R data format. The file is located in the R server file system.",
        "tags": ["local", "data-file", "rdata-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "path",
              "type": "string",
              "title": "Path",
              "description": "Path to the file."
            },
            {
              "key": "format",
              "type": "string",
              "title": "R object class",
              "description": "The primary class of the R object that is being loaded from the R data file. When there are several objects of this class, the one with the symbol with same name as the resource is chosen, otherwise the first one is selected."
            }
          ],
          "required": [
            "path"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "description": "No credentials required: the file must be accessible from the R server."
        }
      },
      {
        "name": "local-tidy-file",
        "title": "Tidy data file - local",
        "description": "File resource in tidy format, having a reader in the [tidyverse](https://www.tidyverse.org) ecosystem. The file is located in the R server file system.",
        "tags": ["local", "data-file", "tidy-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "path",
              "type": "string",
              "title": "Path",
              "description": "Path to the file."
            },
            {
              "key": "format",
              "type": "string",
              "title": "Format",
              "description": "Data format that can help when trying to coerce the file content to a data.frame.",
              "enum": [
                {
                  "key": "csv",
                  "title": "CSV (comma delimiter)"
                },
                {
                  "key": "csv2",
                  "title": "CSV2 (semicolon delimiter)"
                },
                {
                  "key": "ssv",
                  "title": "SSV (space delimiter)"
                },
                {
                  "key": "tsv",
                  "title": "TSV (tab delimiter)"
                },
                {
                  "key": "spss",
                  "title": "SPSS"
                },
                {
                  "key": "sav",
                  "title": "SAV"
                },
                {
                  "key": "por",
                  "title": "POR"
                },
                {
                  "key": "stata",
                  "title": "STATA"
                },
                {
                  "key": "dta",
                  "title": "DTA"
                },
                {
                  "key": "sas",
                  "title": "SAS"
                },
                {
                  "key": "xpt",
                  "title": "XPT"
                },
                {
                  "key": "excel",
                  "title": "EXCEL"
                },
                {
                  "key": "xls",
                  "title": "XLS"
                },
                {
                  "key": "xlsx",
                  "title": "XLSX"
                }
              ]
            }
          ],
          "required": [
            "path", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "description": "No credentials required: the file must be accessible from the R server."
        }
      },
      {
        "name": "nosql",
        "title": "NoSQL collection",
        "description": "File resource is a collection in a NoSQL database accessible using [nodbi](https://docs.ropensci.org/nodbi/).",
        "tags": ["database"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "driver",
              "type": "string",
              "title": "Database engine",
              "description": "Database engine supported by [nodbi](https://docs.ropensci.org/nodbi/).",
              "enum": [
                {
                  "key": "mongodb",
                  "title":"MongoDB"
                },
                {
                  "key": "elasticsearch",
                  "title":"Elasticsearch"
                },
                {
                  "key": "redis",
                  "title":"Redis"
                },
                {
                  "key": "couchdb",
                  "title":"CouchDB"
                }
              ]
            },
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address of the database server."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "description": "Database port number."
            },
            {
              "key": "db",
              "type": "string",
              "title": "Database",
              "description": "The database name."
            },
            {
              "key": "collection",
              "type": "string",
              "title": "Collection",
              "description": "The collection name."
            }
          ],
          "required": [
            "driver", "host", "port", "db", "table"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are optional.",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid database user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ]
        }
      },
      {
        "name": "opal-rdata-file",
        "title": "R data file - Opal",
        "description": "File resource in R data format. The file will be downloaded from the file store of a Opal server.",
        "tags": ["opal", "data-file", "rdata-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "Opal server base URL."
            },
            {
              "key": "path",
              "type": "string",
              "title": "Path",
              "description": "Path to the file in the Opal server."
            },
            {
              "key": "format",
              "type": "string",
              "title": "R object class",
              "description": "The primary class of the R object that is being loaded from the R data file. When there are several objects of this class, the one with the symbol with same name as the resource is chosen, otherwise the first one is selected."
            }
          ],
          "required": [
            "url", "path", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are required and is a [personal API access token](http://opaldoc.obiba.org/en/latest/web-user-guide/my-profile.html#personal-access-tokens).",
          "items": [
            {
              "key": "token",
              "type": "string",
              "format": "password",
              "title": "Token",
              "description": "Personal access token, granting read access to the file."
            }
          ],
          "required": [
            "token"
          ]
        }
      },
      {
        "name": "opal-tidy-file",
        "title": "Tidy data file - Opal",
        "description": "File resource in tidy format, having a reader in the [tidyverse](https://www.tidyverse.org) ecosystem. The file will be downloaded from the file store of a Opal server.",
        "tags": ["opal", "data-file", "tidy-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "Opal server base URL."
            },
            {
              "key": "path",
              "type": "string",
              "title": "Path",
              "description": "Path to the file in the Opal server."
            },
            {
              "key": "format",
              "type": "string",
              "title": "Format",
              "description": "Data format that can help when trying to coerce the file content to a data.frame.",
              "enum": [
                {
                  "key": "csv",
                  "title": "CSV (comma delimiter)"
                },
                {
                  "key": "csv2",
                  "title": "CSV2 (semicolon delimiter)"
                },
                {
                  "key": "ssv",
                  "title": "SSV (space delimiter)"
                },
                {
                  "key": "tsv",
                  "title": "TSV (tab delimiter)"
                },
                {
                  "key": "spss",
                  "title": "SPSS"
                },
                {
                  "key": "sav",
                  "title": "SAV"
                },
                {
                  "key": "por",
                  "title": "POR"
                },
                {
                  "key": "stata",
                  "title": "STATA"
                },
                {
                  "key": "dta",
                  "title": "DTA"
                },
                {
                  "key": "sas",
                  "title": "SAS"
                },
                {
                  "key": "xpt",
                  "title": "XPT"
                },
                {
                  "key": "excel",
                  "title": "EXCEL"
                },
                {
                  "key": "xls",
                  "title": "XLS"
                },
                {
                  "key": "xlsx",
                  "title": "XLSX"
                }
              ]
            }
          ],
          "required": [
            "url", "path", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are required and is a [personal API access token](http://opaldoc.obiba.org/en/latest/web-user-guide/my-profile.html#personal-access-tokens).",
          "items": [
            {
              "key": "token",
              "type": "string",
              "format": "password",
              "title": "Token",
              "description": "Personal access token, granting read access to the file."
            }
          ],
          "required": [
            "token"
          ]
        }
      },
      {
        "name": "presto",
        "title": "Presto",
        "description": "Resource is a distributed SQL table accessible through [Presto](https://prestodb.io) using [DBI](https://www.r-dbi.org). The data can be read as a standard `data.frame` or as a [dbplyr](https://dbplyr.tidyverse.org/)'s `tbl`.",
        "tags": ["database"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "Presto server base URL."
            },
            {
              "key": "catalog",
              "type": "string",
              "title": "Catalog",
              "description": "Presto reference to a data source."
            },
            {
              "key": "schema",
              "type": "string",
              "title": "Schema",
              "description": "The set of tables, in the selected catalog."
            },
            {
              "key": "table",
              "type": "string",
              "title": "Table",
              "description": "The table name, in the selected catalog and schema."
            }
          ],
          "required": [
            "url", "catalog", "schema", "table"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are required.",
          "items": [
            {
              "key": "authType",
              "type": "string",
              "title": "Authentication type",
              "description": "The HTTP authentication type.",
              "enum": [
                "basic", "digest", "digest_ie", "gssnegotiate", "ntlm", "any"
              ]
            },
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid database user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ],
          "required": [
            "username", "password"
          ]
        }
      },
      {
        "name": "scp-rdata-file",
        "title": "R data file - SSH",
        "description": "File resource in R data format. The file will be downloaded from a server accessible through SSH.",
        "tags": ["ssh", "data-file", "rdata-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address that exposes SSH entry point."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "default": 22,
              "description": "SSH port number (default is 22)."
            },
            {
              "key": "path",
              "type": "string",
              "title": "Path",
              "description": "Path to the file in the remote server."
            },
            {
              "key": "format",
              "type": "string",
              "title": "R object class",
              "description": "The primary class of the R object that is being loaded from the R data file. When there are several objects of this class, the one with the symbol with same name as the resource is chosen, otherwise the first one is selected."
            }
          ],
          "required": [
            "host", "path", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid user name having SSH access."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ],
          "required": [
            "username", "password"
          ]
        }
      },
      {
        "name": "scp-tidy-file",
        "title": "Tidy data file - SSH",
        "description": "File resource in tidy format, having a reader in the [tidyverse](https://www.tidyverse.org) ecosystem. The file will be downloaded from a server accessible through SSH.",
        "tags": ["ssh", "data-file", "tidy-format"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address that exposes SSH entry point."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "default": 22,
              "description": "SSH port number (default is 22)."
            },
            {
              "key": "path",
              "type": "string",
              "title": "Path",
              "description": "Path to the file in the remote server."
            },
            {
              "key": "format",
              "type": "string",
              "title": "Format",
              "description": "Data format that can help when trying to coerce the file content to a data.frame.",
              "enum": [
                {
                  "key": "csv",
                  "title": "CSV (comma delimiter)"
                },
                {
                  "key": "csv2",
                  "title": "CSV2 (semicolon delimiter)"
                },
                {
                  "key": "ssv",
                  "title": "SSV (space delimiter)"
                },
                {
                  "key": "tsv",
                  "title": "TSV (tab delimiter)"
                },
                {
                  "key": "spss",
                  "title": "SPSS"
                },
                {
                  "key": "sav",
                  "title": "SAV"
                },
                {
                  "key": "por",
                  "title": "POR"
                },
                {
                  "key": "stata",
                  "title": "STATA"
                },
                {
                  "key": "dta",
                  "title": "DTA"
                },
                {
                  "key": "sas",
                  "title": "SAS"
                },
                {
                  "key": "xpt",
                  "title": "XPT"
                },
                {
                  "key": "excel",
                  "title": "EXCEL"
                },
                {
                  "key": "xls",
                  "title": "XLS"
                },
                {
                  "key": "xlsx",
                  "title": "XLSX"
                }
              ]
            }
          ],
          "required": [
            "host", "path", "format"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid user name having SSH access."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ],
          "required": [
            "username", "password"
          ]
        }
      },
      {
        "name": "sh",
        "title": "Shell",
        "description": "Access to a computation unit through system commands. Work directory and allowed shell commands can be specified.",
        "tags": ["commands"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "workDir",
              "type": "string",
              "title": "Work directory",
              "description": "Work directory where operations should apply (and possibly where data are stored)."
            },
            {
              "key": "exec",
              "type": "array",
              "title": "Shell commands",
              "description": "Shell commands that can be executed. If not specified, no restriction is applied.",
              "items": [
                {
                  "key": "name",
                  "type": "string",
                  "title": "Executable"
                }
              ]
            }
          ],
          "required": [
            "host"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "description": "No credentials required: the system commands and working directory must be accessible from the R server."
        }
      },
      {
        "name": "spark",
        "title": "Apache Spark",
        "description": "Resource is a distributed dataset accessible through [Spark](https://spark.apache.org/). Spark has a SQL interface using [DBI](https://www.r-dbi.org). The data can be read as a standard `data.frame` or as a [dbplyr](https://dbplyr.tidyverse.org/)'s `tbl`. Spark is also a unified analytics engine for large-scale data processing, including many [machine learning functions](https://spark.rstudio.com/mlib/).",
        "tags": ["database", "analytics"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "url",
              "type": "string",
              "title": "URL",
              "description": "Spark server base URL."
            },
            {
              "key": "rdd",
              "type": "string",
              "title": "Dataset",
              "description": "The distributed dataset (RDD) name."
            }
          ],
          "required": [
            "url", "catalog", "schema", "rdd"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are required and authentication method is expected to be based on [Livy](https://livy.incubator.apache.org/).",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ],
          "required": [
            "username", "password"
          ]
        }
      },
      {
        "name": "sql",
        "title": "SQL table",
        "description": "Resource is a SQL table in a database accessible using [DBI](https://www.r-dbi.org). The data can be read as a standard `data.frame` or as a [dbplyr](https://dbplyr.tidyverse.org/)'s `tbl`.",
        "tags": ["database"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "driver",
              "type": "string",
              "title": "Database engine",
              "description": "Database engine implementing the [DBI](https://www.r-dbi.org).",
              "enum": [
                {
                  "key": "mariadb",
                  "title":"MariaDB"
                },
                {
                  "key": "mysql",
                  "title":"MySQL"
                },
                {
                  "key": "postgresql",
                  "title":"PostgreSQL"
                }
              ]
            },
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address of the database server."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "description": "Database port number."
            },
            {
              "key": "db",
              "type": "string",
              "title": "Database",
              "description": "The database name."
            },
            {
              "key": "table",
              "type": "string",
              "title": "Table",
              "description": "The table name."
            }
          ],
          "required": [
            "driver", "host", "port", "db", "table"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "description": "Credentials are required.",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid database user name."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ],
          "required": [
            "username", "password"
          ]
        }
      },
      {
        "name": "ssh",
        "title": "SSH",
        "description": "Access to a computation unit through SSH. Credentials are required. Work directory and allowed shell commands can be specified.",
        "tags": ["ssh", "commands"],
        "parameters": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "host",
              "type": "string",
              "title": "Host",
              "description": "Remote host name or IP address that exposes SSH entry point."
            },
            {
              "key": "port",
              "type": "integer",
              "title": "Port",
              "default": 22,
              "description": "SSH port number (default is 22)."
            },
            {
              "key": "workDir",
              "type": "string",
              "title": "Work directory",
              "description": "Remote work directory where operations should apply (and possibly where data are stored)."
            },
            {
              "key": "exec",
              "type": "array",
              "title": "Shell commands",
              "description": "Shell commands that can be executed through SSH. If not specified, no restriction is applied.",
              "items": [
                {
                  "key": "name",
                  "type": "string",
                  "title": "Executable"
                }
              ]
            }
          ],
          "required": [
            "host"
          ]
        },
        "credentials": {
          "$schema": "http://json-schema.org/schema#",
          "type": "array",
          "items": [
            {
              "key": "username",
              "type": "string",
              "title": "User name",
              "description": "Valid user name having SSH access."
            },
            {
              "key": "password",
              "type": "string",
              "title": "Password",
              "format": "password",
              "description": "The user's password."
            }
          ],
          "required": [
            "username", "password"
          ]
        }
      }
    ]
  },
  asResource: function(type, name, params, credentials) {

    //
    // Resource factory functions to be reused
    //
    var toDefaultResource = function(name, params, credentials) {
        return {
            name: name,
            url: params.url,
            format: params.format,
            identity: credentials.identifier,
            secret: credentials.secret
        }
    };

    var toGridfsResource = function(name, params, credentials) {
        return {
            name: name,
            url: "gridfs://" + params.host + ":" + params.port + "/" + params.db + "/" + params.file,
            format: params.format,
            identity: credentials.username,
            secret: credentials.password
        };
    };

    var toHttpResource = function(name, params, credentials) {
        return {
            name: name,
            url: params.url,
            format: params.format,
            identity: credentials.username,
            secret: credentials.password
        };
    };

    var toLocalResource = function(name, params, credentials) {
      return {
        name: name,
        url: "file://" + params.path,
        format: params.format
      };
    };

    var toOpalResource = function(name, params, credentials) {
        return {
            name: name,
            url: "opal+" + params.url + "/ws/files" + params.path,
            format: params.format,
            identity: null,
            secret: credentials.token
        }
    };

    var toScpResource = function(name, params, credentials) {
        var port = params.port;
        if (!port || port<=0) {
            port = 22;
        }
        var path = params.path;
        if (!path.startsWith("/")) {
            path = "/" + path;
        }
        return {
            name: name,
            url: "scp://" + params.host + ":" + port + path,
            format: params.format,
            identity: credentials.username,
            secret: credentials.password
        }
    };

    var toRdataFormat = function(resource) {
      if (resource.format && !resource.url.toLowerCase().endsWith(".rda") && !resource.url.toLowerCase().endsWith(".rdata")) {
        resource.format = "R:" + resource.format;
      }
      return resource;
    }

    //
    // Resource factory functions by resource form type
    //
    var toResourceFactories = {
      "default": toDefaultResource,
      "gridfs-generic-file": toGridfsResource,
      "gridfs-rdata-file": function(name, params, credentials) {
          return toRdataFormat(toGridfsResource(name, params, credentials));
      },
      "gridfs-tidy-file": toGridfsResource,
      "http-generic-file": toHttpResource,
      "http-rdata-file": function(name, params, credentials) {
          return toRdataFormat(toHttpResource(name, params, credentials));
      },
      "http-tidy-file": toHttpResource,
      "local-generic-file": toLocalResource,
      "local-rdata-file": function(name, params, credentials) {
        return toRdataFormat(toLocalResource(name, params, credentials));
      },
      "local-tidy-file": toLocalResource,
      "nosql": function(name, params, credentials) {
          return {
              name: name,
              url: params.driver + "://" + params.host + ":" + params.port + "/" + params.db + "/" + params.collection,
              identity: credentials.username,
              secret: credentials.password
          }
      },
      "opal-generic-file": toOpalResource,
      "opal-rdata-file": function(name, params, credentials) {
          return toRdataFormat(toOpalResource(name, params, credentials));
      },
      "opal-tidy-file": toOpalResource,
      "presto": function(name, params, credentials) {
          var query = "";
          if (credentials.username) {
            query = "?auth_type=" + params.authType;
          }
          return {
              name: name,
              url: "presto+" + params.url + "/" + params.catalog + "." + params.schema + "/" + params.table + query,
              identity: credentials.username,
              secret: credentials.password
          }
      },
      "scp-generic-file": toScpResource,
      "scp-rdata-file": function(name, params, credentials) {
          return toRdataFormat(toScpResource(name, params, credentials));
      },
      "scp-tidy-file": toScpResource,
      "sh": function(name, params, credentials) {
          var workDir = params.workDir;
          if (workDir) {
              if (!workDir.startsWith("/")) {
                  workDir = "/" + workDir;
              }
          } else {
              workDir = ".";
          }
          var query = "";
          if (params.exec && params.exec.length>0) {
              query = "exec=";
              params.exec.forEach(function(p) {
                  if (query !== "exec=") {
                      query = query + ",";
                  }
                  query = query + p.name;
              });
          }
          if (query.length>0) {
              query = "?" + query;
          }
          return {
              name: name,
              url: "sh://" + workDir + query,
              identity: credentials.username,
              secret: credentials.password
          }
      },
      "spark": function(name, params, credentials) {
          return {
              name: name,
              url: "spark+" + params.url + "/" + params.rdd,
              identity: credentials.username,
              secret: credentials.password
          }
      },
      "sql": function(name, params, credentials) {
          return {
              name: name,
              url: params.driver + "://" + params.host + ":" + params.port + "/" + params.db + "/" + params.table,
              identity: credentials.username,
              secret: credentials.password
          }
      },
      "ssh": function(name, params, credentials) {
          var port = params.port;
          if (!port || port<=0) {
              port = 22;
          }
          var workDir = params.workDir;
          if (workDir) {
              if (!workDir.startsWith("/")) {
                  workDir = "/" + workDir;
              }
          } else {
              workDir = "";
          }
          var query = "";
          if (params.exec && params.exec.length>0) {
              query = "exec=";
              params.exec.forEach(function(p) {
                  if (query !== "exec=") {
                      query = query + ",";
                  }
                  query = query + p.name;
              });
          }
          if (query.length>0) {
              query = "?" + query;
          }
          return {
              name: name,
              url: "ssh://" + params.host + ":" + port + workDir + query,
              identity: credentials.username,
              secret: credentials.password
          }
      }
    };

    // Check if there is a resource factory function for the requested resource form type
    if (toResourceFactories[type]) {
        return toResourceFactories[type](name, params, credentials);
    }
    return undefined;
  }
}
