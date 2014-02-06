# grunt-browserify-plus

> Continuously Browserify JavaScript and CoffeeScript files fast (it caches) and everything you need built in.

Grunt Browserify Plus was created to be the ultimate grunt task for running browserify. Quit spending time trying to configure browserify. Just get running with features and speed.

  * Automatic Rebuilds. It builds every time a require'd file changes. No special setup required to do this (with watchify)
  * Fast! It caches so builds happen instantly. Usually unperceptible milliseconds (with watchify)
  * CoffeeScript support built in all the way through. No finicky setup to get Browserify modules working with CoffeeScript (with  coffeeify)
  * Alias Mappings built in (with aliasify).
  * Shim support built in. Easily include or reference any library, even if it isn't properly set up to use CommonJS (with browserify-shim)
  * Inline external files into your JavaScript (with brfs)


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


## The "browserify_plus" task

### Overview
In your project's Gruntfile, add a section named `browserify_plus` to the data object passed into `grunt.initConfig()`.

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
Works with CoffeeScript files:

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      // Options go here. See below for options.
    },
    files: {
      'build/path/example.js': './source/path.coffee'
    },
  },
});
```

For multiple files, pass in an array (feel free to mix js and coffee files):

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      // Options go here. See below for options.
    },
    files: {
      'build/path/example.js': ['./source/path.coffee', './source/path_2.js']
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
