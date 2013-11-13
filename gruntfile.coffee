'use strict'

module.exports = (grunt) ->

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
      all: [
        'build'
        'temp'
      ]

    # Script
    # ------
    coffee:
      compile:
        files: [
          expand: true
          filter: 'isFile'
          cwd: "src/scripts"
          dest: "temp/scripts"
          src: '**/*.coffee'
          ext: '.js'
        ]

        options:
          bare: true

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
    # 'livereload-start'
    # 'copy:static'
    'coffee'
    # 'haml'
    # 'sass'
    # 'connect:temp'
    # 'proxy',
    # 'compliment',
    # 'regarde'
  ]

  # # Build
  # # -----
  # grunt.registerTask 'build', [
  #   'prepare',
  #   'copy:static'
  #   'script'
  #   'haml'
  #   'sass'
  #   'requirejs:compile'
  #   'copy:build'
  #   'requirejs:css'
  #   'cssc:build'
  #   'hashres'
  #   'htmlmin'
  #   'bytesize'
  # ]
