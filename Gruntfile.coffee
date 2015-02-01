module.exports = (grunt)->

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      coffee: {
        files: ['src/javascripts/**/*.coffee'],
        tasks: ['coffee']
      }
    },
    coffee: {
      compile: {
        files: {
          'app/javascripts/app.js': ['src/javascripts/*.coffee']
        }
      }
    }
  })

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', ['watch'])

