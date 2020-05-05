var resourcer_resource = function(type, name, params, credentials) {

  //
  // Resource factory functions to be reused
  //
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
};
