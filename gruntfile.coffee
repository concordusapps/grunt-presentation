'use strict'

module.exports = (grunt) ->

  # Utilities
  # =========
  path = require 'path'

  # Options
  # =======

  # Port offset
  # -----------
  # Increment this for additional gruntfiles that you want
  # to run simultaneously.
  portOffset = 0

  # Host
  # ----
  # You could set this to your IP address to expose it over a local internet.
  hostname = 'localhost'

  # Configuration
  # =============
  grunt.initConfig

    # Clean
    # -----
    # Configure 'grunt-contrib-clean' to remove all built and temporary
    # files.
    clean:
      bower: [
        'temp/bower_components'
      ]

      all: [
        'build'
        'temp'
      ]

    # Symlink
    # -------
    # Ensure that the temporary directories can access the bower components.
    symlink:
      bower:
        src: 'bower_components'
        dest: 'temp/bower_components'

    # Copy
    # ----
    # Ensure files go where they need to. Used for static files.
    copy:
      static:
        files: [
          expand: true
          filter: 'isFile'
          cwd: 'src'
          dest: 'temp'
          src: [
            '**/*'
            '!**/*.ls'
            '!**/*.scss'
            '!**/*.haml'
          ]
        ]

    # Script
    # ------
    livescript:
      compile:
        files: [
          expand: true
          filter: 'isFile'
          cwd: 'src'
          dest: 'temp'
          src: '**/*.ls'
          ext: '.js'
        ]

        options:
          bare: true

    # Templates
    # ---------
    haml:
      compile:
        files: [
          expand: true
          filter: 'isFile'
          cwd: 'src'
          dest: 'temp'
          src: '**/*.haml'
          ext: '.html'
        ]

        options:
          target: 'html'
          language: 'coffee'
          uglify: true

    # Slides
    # ------
    markdown:
      render:
        files: [
          expand: true
          filter: 'isFile'
          cwd: 'src'
          dest: 'temp'
          src: '**/*.md'
          ext: '.html'
        ]

        options:
          template: 'src/slides/slide.jst'

    # Webserver
    # ---------
    connect:
      options:
        port: 5000 + portOffset
        hostname: hostname
        middleware: (connect, options) -> [
          require('connect-livereload')()
          connect.static options.base
        ]

      build:
        options:
          keepalive: true
          base: 'build'

      temp:
        options:
          base: 'temp'

    # Stylesheets
    # -----------
    sass:
      compile:
        dest: 'temp/styles/main.css'
        src: 'src/styles/main.scss'
        options:
          loadPath: path.join(path.resolve('.'), 'temp')

    # Watch
    # -----
    watch:
      bower:
        files: ['bower_components/**/*']
        tasks: ['symlink:bower']

      haml:
        files: ['src/**/*.haml']
        tasks: ['haml:compile']

      markdown:
        files: ['src/**/*.md']
        tasks: ['markdown:render']

      livescript:
        files: ['src/**/*.ls']
        tasks: ['livescript:compile']

      sass:
        files: ['src/**/*.scss']
        tasks: ['sass:compile']

      livereload:
        options: {livereload: true}
        files: ['temp/**/*']

  # Dependencies
  # ============
  # Loads all grunt tasks from the installed NPM modules.
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  # Tasks
  # =====

  # Default
  # -------
  # By default, the invocation 'grunt' should build and expose the
  # presentation at a default host/port.
  grunt.registerTask 'default', [
    'clean'
    'server'
  ]

  # Server
  # ------
  grunt.registerTask 'server', [
    'symlink:bower'
    'copy:static'
    'livescript:compile'
    'haml:compile'
    'sass:compile'
    'markdown:render'
    'connect:temp'
    'watch'
  ]

  # # Build
  # # -----
  # grunt.registerTask 'build', [
  #   'clean',
  #   'copy:static'
  #   'symlink:bower'
  #   'livescript:compile'
  #   'haml:compile'
  #   'sass:compile'
  #   'connect:temp'
  #   'requirejs:compile'
  #   'requirejs:css'
  #   'cssc:build'
  #   'hashres'
  #   'htmlmin'
  # ]
