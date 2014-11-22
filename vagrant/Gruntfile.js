'use strict';

module.exports = function(grunt) {

  grunt.initConfig({
    less: {
      development: {
        options: {
          paths: ["css"]
        },
        files: {
          "css/main.css": "less/main.less"
        }
      },
      production: {
        options: {
          paths: ["css"],
          cleancss: true,
        },
        files: {
          "css/main.css": "less/main.less"
        }
      }
    },
    watch: {
      less: {
        // We watch and compile less files as normal but don't live reload here
        files: ['less/*.less'],
        tasks: ['less:development'],
      },
      livereload: {
        // Here we watch the files the less task will compile to
        // These files are sent to the live reload server after less compiles to them
        options: { livereload: true },
        files: ['css/*.css', 'index.html'],
      },
    },
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-less');

  // Default task.
  grunt.registerTask('default', ['watch']);

};
