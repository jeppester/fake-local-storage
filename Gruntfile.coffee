module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        files:
          './dist/fake-local-storage.js': './src/fake-local-storage.coffee'

    connect:
      server:
        options:
          port: 8000
          base: './'

    watch:
      scripts:
        files: ['./src/fake-local-storage.coffee']
        tasks: ['coffee']
        options:
          reload: true

    open:
      development:
        path: 'http://localhost:8000/index.html'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-open'

  grunt.registerTask 'start', ['coffee', 'open', 'connect', 'watch']
