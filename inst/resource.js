const resourcer_resource = function(type, name, params, credentials) {

  //
  // Resource factory functions to be reused
  //
  const toGridfsResource = function(name, params, credentials) {
      return {
          name: name,
          url: "gridfs://" + params.host + ":" + params.port + "/" + params.db + "/" + params.file,
          format: params.format,
          identity: credentials.username,
          secret: credentials.password
      };
  };

  const toHttpResource = function(name, params, credentials) {
      return {
          name: name,
          url: params.url,
          format: params.format,
          identity: credentials.username,
          secret: credentials.password
      };
  };

  const toLocalResource = function(name, params, credentials) {
    return {
      name: name,
      url: "file://" + params.path,
      format: params.format
    };
  };

  const toOpalResource = function(name, params, credentials) {
      return {
          name: name,
          url: "opal+" + params.url + "/ws/files" + params.path,
          format: params.format,
          identity: null,
          secret: credentials.token
      }
  };

  const toScpResource = function(name, params, credentials) {
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

  const toRdataFormat = function(params) {
    var rparams = {
      url: params.url,
      format: "r:" + params.format
    };
    return rparams;
  }

  //
  // Resource factory functions by resource form type
  //
  const toResourceFactories = {
    "gridfs-generic-file": toGridfsResource,
    "gridfs-rdata-file": function(name, params, credentials) {
        return toGridfsResource(name, toRdataFormat(params), credentials);
    },
    "gridfs-tidy-file": toGridfsResource,
    "http-generic-file": toHttpResource,
    "http-rdata-file": function(name, params, credentials) {
        return toHttpResource(name, toRdataFormat(params), credentials);
    },
    "http-tidy-file": toHttpResource,
    "local-generic-file": toLocalResource,
    "local-rdata-file": function(name, params, credentials) {
      return toLocalResource(name, toRdataFormat(params), credentials);
    },
    "local-tidy-file": toLocalResource,
    "nosql-database": function(name, params, credentials) {
        return {
            name: name,
            url: params.driver + "://" + params.host + ":" + params.port + "/" + params.db + "/" + params.collection,
            identity: credentials.username,
            secret: credentials.password
        }
    },
    "opal-generic-file": toOpalResource,
    "opal-rdata-file": function(name, params, credentials) {
        return toOpalResource(name, toRdataFormat(params), credentials);
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
        return toScpResource(name, toRdataFormat(params), credentials);
    },
    "scp-tidy-file": toScpResource,
    "shell": function(name, params, credentials) {
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
    "sql-database": function(name, params, credentials) {
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
};
