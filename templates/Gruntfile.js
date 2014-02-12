'use strict';

module.exports = function(grunt) {

  grunt.initConfig({
    browserifying: {
      default: {
        options: {
          // map: {},
          // watch: true
        },
        files: {
          './dest.js': './source.js'
        }
      }
    }
  });

};
