/*
 * grunt-browserifying
 * https://github.com/thesunny/grunt-browserifying
 *
 * Copyright (c) 2014 Sunny Hirai
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    jshint: {
      all: [
        'Gruntfile.js',
        'tasks/*.js',
        '<%= nodeunit.tests %>',
      ],
      options: {
        jshintrc: '.jshintrc',
      },
    },

    // Before generating any new files, remove any previously-created files.
    clean: {
      tests: ['tmp'],
    },

    // Configuration to be run (and then tested).
    browserifying: {
      test: {
        options: {
          map: {
            'aliasMap-1': './example/aliasMappings/aliasMap-1',
            'aliasMap-2': './example/aliasMappings/aliasMap-2',
            'shim-1': {
              path: './example/shims/shim-1',
              exports: '$'
            },
            'shim-2': {
              path: './example/shims/shim-2',
              exports: '$'
            }
          },
          brfs: true,
          watch: true
        },
        files: {
          './tmp/example.js': ['./example/example-1.coffee', './example/example-2.js']
        }
      },
      simple: {
        options: {
          watch: false
        },
        files: {
          './tmp/simple.js': ['./example/simple/alpha']
        }
      },
      glob: {
        options: {
          watch: false,
        },
        files: {
          './tmp/glob.js': ['./example/glob/**/*.coffee']
        }
      }
    },

    // Unit tests.
    nodeunit: {
      tests: ['test/*_test.js'],
    },

  });

  // Actually load this plugin's task(s).
  grunt.loadTasks('tasks');

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');

  // Whenever the "test" task is run, first clean the "tmp" dir, then run this
  // plugin's task(s), then test the result.
  grunt.registerTask('test', ['clean', 'browserifying:glob', 'nodeunit']); // 'browserifying:simple', 

  // By default, lint and run all tests.
  grunt.registerTask('default', ['jshint', 'test']);

};
