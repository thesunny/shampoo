module.exports =
  homeRegexp: /^\.\//
  jsExtensionRegexp: /\.js$/
  pathDelimiterRegexp: /\\/g
  prefix: (path) ->
    if path.match @homeRegexp
      path
    else
      "./#{path}"
  normalizeBuildExtension: (path) ->
    if path.match @jsExtensionRegexp
      path
    else
      "#{path}.js"
  normalizePathDelimiter: (path) ->
    path.replace(@pathDelimiterRegexp, '/')
  rootPath: (path) ->
    "./#{path}"
