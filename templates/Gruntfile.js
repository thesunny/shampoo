'use strict';

module.exports = function(grunt) {

  grunt.initConfig({
    shampoo: {
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
