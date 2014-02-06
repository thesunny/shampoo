# grunt-browserify-plus

The ultimate Grunt Browserify task.

  * Watches files for changes.
  * Uses a cache for super speed (instant builds)
  * CoffeeScript support out of box
  * Alias mappings
  * Shimming
  * All this and more (see options) in one easy to use package.



## Getting Started
This plugin requires Grunt `~0.4.2`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-browserify-plus --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-browserify-plus');
```


## The "browserify_plus" Grunt Plugin

### Overview
In your project's Gruntfile, add a section named `browserify_plus` to the data object passed into `grunt.initConfig()`.

Include a `files` Object where:

  * The keys are the destination file for the Browserify build (remember to include the ".js")
  * The value is either a `String` or `Array` of `String` that represents the source files. The source files may be either `.js` or `.coffee` files. Remember to:
    1. Include the extension (.js or .coffee).
    1. Include the "./" part of the path

The source files are relative to the directory from where `grunt` is being run.

Optionally include an `options` Object. See the Options section for more info.

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      // Options go here. See below for options.
    },
    files: {
      'build/path/example.js': './source/path.js'
    },
  },
});
```

Run the grunt task from the command line using:

```
grunt browserify_plus
```


#### CoffeeScript

As mentioned, it works with CoffeeScript files (no configuration required):

```js
grunt.initConfig({
  browserify_plus: {
    options: {},
    files: {
      'build/path/example.js': './source/path.coffee'
                                // .coffee files work
    },
  },
});
```


#### Multiple Source Files

For multiple files, pass in an array (feel free to mix js and coffee files):

```js
grunt.initConfig({
  browserify_plus: {
    options: {},
    files: {
      'build/path/example.js': ['./source/path.coffee', './source/path_2.js']
                               // Array of String for sources works
    },
  },
});
```


#### Multiple Browserify Bundles

You can have multiple builds going on simultaneously as well:

```js
grunt.initConfig({
  browserify_plus: {
    options: {
    },
    files: {
      'build/path/example.js': ['./source/path.coffee', './source/path_2.js']
      'build/path/example-2.js': './source/example-2.js'
      // Multiple key/value pairs works to create multiple Browserify bundles
    },
  },
});
```




### Options

#### options.aliasMappings
Type: `Object`
Default value: `null`

An Object that maps require names to file locations.

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      aliasMappings: {
        'underscore': './lib/underscore.js'
      }
    },
    files: {
      ...
    },
  },
});
```

The root directory for the destination (e.g. './lib/underscore.js' is the directory where grunt is being run from.)


#### options.shim
Type: `Object`
Default value: `null`

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      aliasMappings: {
        'underscore': './lib/underscore.js'
      }
    },
    files: {
      ...
    },
  },
});
```



### Usage Examples

#### Default Options
In this example, the default options are used to do something with whatever. So if the `testing` file has the content `Testing` and the `123` file had the content `1 2 3`, the generated result would be `Testing, 1 2 3.`

```js
grunt.initConfig({
  browserify_plus: {
    options: {},
    files: {
      'dest/default_options': ['src/testing', 'src/123'],
    },
  },
});
```

#### Custom Options
In this example, custom options are used to do something else with whatever else. So if the `testing` file has the content `Testing` and the `123` file had the content `1 2 3`, the generated result in this case would be `Testing: 1 2 3 !!!`

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      separator: ': ',
      punctuation: ' !!!',
    },
    files: {
      'dest/default_options': ['src/testing', 'src/123'],
    },
  },
});
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
