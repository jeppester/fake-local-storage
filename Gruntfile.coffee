module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    browserify:
      options:
        watch: true
        browserifyOptions:
          extensions: ['.coffee', '.jade']
          paths: ['./node_modules','./src']
      development:
        files: 'dist/file-local-storage.js': ['src/file-local-storage.coffee']

    connect:
      server:
        options:
          port: 8000
          base: './'
          keepalive: true

    open:
      development:
        path: 'http://localhost:8000/index.html'

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-open'

  grunt.registerTask 'start', ['browserify', 'open', 'connect']
