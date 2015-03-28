gulp = require 'gulp'
plumber = require 'gulp-plumber'
jade = require 'gulp-jade'
browserify = require 'browserify'
concat = require 'gulp-concat'
source = require 'vinyl-source-stream'
compass = require 'gulp-compass'
rimraf = require 'rimraf'
livereload = require 'gulp-livereload'
coffeeify = require 'coffeeify'
envify = require 'envify/custom'
require('dotenv').config(path: ".env.#{process.env.NODE_ENV || 'development'}")

WEB_PATH = './web'
EXTENSION_PATH = './chrome_extension'

gulp.task 'clean', (cb)->
  rimraf "#{WEB_PATH}/build", cb
  rimraf "#{EXTENSION_PATH}/build", cb

gulp.task 'html', ->
  gulp.src "#{WEB_PATH}/source/[^_]*.jade"
    .pipe plumber()
    .pipe jade()
    .pipe gulp.dest "#{WEB_PATH}/build/"
    .pipe livereload()

gulp.task 'image', ->
  gulp.src "#{WEB_PATH}/source/image/*"
    .pipe gulp.dest "#{WEB_PATH}/build/image/"
    .pipe livereload()

gulp.task 'font', ->
  gulp.src "#{WEB_PATH}/source/font/*"
    .pipe gulp.dest "#{WEB_PATH}/build/font/"
    .pipe livereload()

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
  .pipe source 'main.js'
  .pipe gulp.dest "#{WEB_PATH}/build/js/"
  .pipe livereload()

gulp.task 'css', ->
  gulp
    .src "#{WEB_PATH}/source/css/main.{s,}css"
    .pipe plumber(errorHandler: (error)->
      console.log error.message
      @emit 'end'
    )
    .pipe compass(css: "#{WEB_PATH}/build/css", sass: "#{WEB_PATH}/source/css", require: ['susy'])
    .pipe gulp.dest "#{WEB_PATH}/build/css/"
    .pipe livereload()

gulp.task 'extension', ->
  gulp
    .src "#{EXTENSION_PATH}/source/*.json"
    .pipe gulp.dest "#{EXTENSION_PATH}/build/"

  gulp
    .src "#{EXTENSION_PATH}/source/image/*"
    .pipe gulp.dest "#{EXTENSION_PATH}/build/image/"

  browserify
    entries: [ "#{EXTENSION_PATH}/source/background.coffee"]
  .transform coffeeify
  .transform envify()
  .bundle()
  .pipe plumber()
  .pipe source 'background.js'
  .pipe gulp.dest "#{EXTENSION_PATH}/build/"

gulp.task 'watch', ['build'], ->
  livereload.listen()
  gulp.watch "#{WEB_PATH}/source/**/*.{js,coffee}", ['js']
  gulp.watch "#{WEB_PATH}/source/components/**/*.vue", ['js']
  gulp.watch "#{WEB_PATH}/source/**/*.jade", ['html', 'js']
  gulp.watch "#{WEB_PATH}/source/css/**/*.{s,}css", ['css']
  gulp.watch "#{WEB_PATH}/source/image/**/*.{png,jpeg,gif}", ['image']
  gulp.watch "#{WEB_PATH}/source/font/**/*.{eot,woff,ttf,svg}", ['font']
  gulp.watch 'bower_components/**/*.js', ['js']
  gulp.watch "#{EXTENSION_PATH}/**/*.{coffee,json,png,jpeg,gif}", ['extension']

gulp.task 'build', ['html', 'js', 'css', 'image', 'font', 'extension']
gulp.task 'default', ['clean', 'build']
