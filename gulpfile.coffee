gulp = require 'gulp'
plumber = require 'gulp-plumber'
jade = require 'gulp-jade'
browserify = require 'browserify'
concat = require 'gulp-concat'
source = require 'vinyl-source-stream'
compass = require 'gulp-compass'
rimraf = require 'rimraf'
connect = require 'gulp-connect'
coffeeify = require 'coffeeify'
envify = require 'envify/custom'
require('dotenv').config(path: ".env.#{process.env.NODE_ENV || 'development'}")

WEB_PATH = './web'
EXTENSION_PATH = './chrome_extension'

gulp.task 'connect', ->
  connect.server
    root: "#{WEB_PATH}/build"
    livereload: true
    middleware: (connect, opt)->
      [
        (req, res, next)->
          req.url = '/' unless req.url.match(/^\/(?:css|js|image|stub)\//)
          next()
      ]
gulp.task 'clean', (cb)->
  rimraf "#{WEB_PATH}/build", cb
  rimraf "#{EXTENSION_PATH}/build", cb

gulp.task 'html', ->
  gulp
    .src "#{WEB_PATH}/source/[^_]*.jade"
    .pipe plumber()
    .pipe jade()
    .pipe connect.reload()
    .pipe gulp.dest "#{WEB_PATH}/build/"

gulp.task 'image', ->
  gulp.src "#{WEB_PATH}/source/image/*"
  .pipe gulp.dest "#{WEB_PATH}/build/image/"

gulp.task 'js', ->
  browserify
    entries: [ "#{WEB_PATH}/source/main.coffee"]
    extensions: ['.coffee', '.js', '.jade']
  .transform coffeeify
  .transform 'jadeify'
  .transform 'debowerify'
  .transform 'vueify'
  .transform envify()
  .bundle()
  .pipe plumber()
  .pipe connect.reload()
  .pipe source 'main.js'
  .pipe gulp.dest "#{WEB_PATH}/build/js/"

gulp.task 'css', ->
  gulp
    .src "#{WEB_PATH}/source/css/main.{s,}css"
    .pipe plumber(errorHandler: (error)->
      console.log error.message
      @emit 'end'
    )
    .pipe connect.reload()
    .pipe compass(css: "#{WEB_PATH}/build/css", sass: "#{WEB_PATH}/source/css", require: ['susy'])
    .pipe gulp.dest "#{WEB_PATH}/build/css/"

gulp.task 'extension', ->
  gulp
    .src "#{EXTENSION_PATH}/source/*.json"
    .pipe gulp.dest "#{EXTENSION_PATH}/build/"

  browserify
    entries: [ "#{EXTENSION_PATH}/source/background.coffee"]
  .transform coffeeify
  .transform envify()
  .bundle()
  .pipe plumber()
  .pipe source 'background.js'
  .pipe gulp.dest "#{EXTENSION_PATH}/build/"

gulp.task 'watch', ['connect', 'build'], ->
  gulp.watch "#{WEB_PATH}/source/**/*.{js,coffee}", ['js']
  gulp.watch "#{WEB_PATH}/source/components/**/*.vue", ['js']
  gulp.watch "#{WEB_PATH}/source/**/*.jade", ['html', 'js']
  gulp.watch "#{WEB_PATH}/source/css/**/*.{s,}css", ['css']
  gulp.watch "#{WEB_PATH}/source/image/**/*.{png,jpeg,gif}", ['image']
  gulp.watch 'bower_components/**/*.js', ['js']
  gulp.watch "#{EXTENSION_PATH}/**/*.{coffee,json}", ['extension']

gulp.task 'build', ['html', 'js', 'css', 'image', 'extension']
gulp.task 'default', ['clean', 'build']
