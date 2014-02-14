module.exports =
  homeRegexp: /^\.\//
  jsExtensionRegexp: /\.js$/
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