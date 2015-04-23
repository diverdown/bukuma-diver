gulp       = require 'gulp'
plumber    = require 'gulp-plumber'
jade       = require 'gulp-jade'
browserify = require 'browserify'
concat     = require 'gulp-concat'
source     = require 'vinyl-source-stream'
compass    = require 'gulp-compass'
del        = require 'del'
livereload = require 'gulp-livereload'
coffeeify  = require 'coffeeify'
envify     = require 'envify/custom'
minifyCSS  = require 'gulp-minify-css'
uglify     = require 'gulp-uglify'
buffer     = require 'vinyl-buffer'
sourcemaps = require 'gulp-sourcemaps'
gulpif     = require 'gulp-if'

env = process.env.NODE_ENV || 'development'
isDevelopment = env == 'development'
require('dotenv').config(path: ".env.#{env}")

WEB_PATH = 'web'
WEB_BUILD_PATH  = "#{WEB_PATH}/build"
WEB_SOURCE_PATH = "#{WEB_PATH}/source"
EXTENSION_PATH = './chrome_extension'

gulp.task 'clean', (cb)->
  del [WEB_BUILD_PATH, "#{EXTENSION_PATH}/build"], cb

gulp.task 'html', ->
  gulp.src "#{WEB_SOURCE_PATH}/[^_]*.jade"
    .pipe plumber()
    .pipe jade()
    .pipe gulp.dest "#{WEB_BUILD_PATH}/"
    .pipe livereload()

gulp.task 'image', ->
  gulp.src "#{WEB_SOURCE_PATH}/image/*"
    .pipe gulp.dest "#{WEB_BUILD_PATH}/image/"
    .pipe livereload()

gulp.task 'font', ->
  gulp.src "#{WEB_SOURCE_PATH}/font/*"
    .pipe gulp.dest "#{WEB_BUILD_PATH}/font/"
    .pipe livereload()

gulp.task 'js', ->
  browserify(
    entries: [ "./#{WEB_SOURCE_PATH}/main.coffee"]
    extensions: ['.coffee', '.js', '.jade']
  )
    .transform coffeeify
    .transform 'jadeify'
    .transform 'debowerify'
    .transform 'vueify'
    .transform envify()
    .bundle()
    .pipe plumber()
    .pipe source 'main.js'
    .pipe buffer()
    .pipe gulpif(isDevelopment, sourcemaps.init(loadMaps: true))
    .pipe uglify(preserveComments: 'some')
    .pipe gulpif(isDevelopment, sourcemaps.write())
    .pipe gulp.dest "#{WEB_BUILD_PATH}/js/"
    .pipe livereload()

gulp.task 'css', ->
  gulp
    .src "#{WEB_SOURCE_PATH}/css/main.{s,}css"
    .pipe plumber(errorHandler: (error)->
      console.log error.message
      @emit 'end'
    )
    .pipe compass(css: "#{WEB_BUILD_PATH}/css", sass: "#{WEB_SOURCE_PATH}/css", require: ['susy'])
    .pipe minifyCSS()
    .pipe gulp.dest "#{WEB_BUILD_PATH}/css/"
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
  gulp.watch "#{WEB_SOURCE_PATH}/**/*.{js,coffee}", ['js']
  gulp.watch "#{WEB_SOURCE_PATH}/components/**/*.vue", ['js']
  gulp.watch "#{WEB_SOURCE_PATH}/**/*.jade", ['html', 'js']
  gulp.watch "#{WEB_SOURCE_PATH}/css/**/*.{s,}css", ['css']
  gulp.watch "#{WEB_SOURCE_PATH}/image/**/*.{png,jpeg,gif}", ['image']
  gulp.watch "#{WEB_SOURCE_PATH}/font/**/*.{eot,woff,ttf,svg}", ['font']
  gulp.watch 'bower_components/**/*.js', ['js']
  gulp.watch "#{EXTENSION_PATH}/**/*.{coffee,json,png,jpeg,gif}", ['extension']

gulp.task 'build', ['html', 'js', 'css', 'image', 'font', 'extension']
gulp.task 'default', ['clean', 'build']
