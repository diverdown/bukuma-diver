gulp = require 'gulp'
plumber = require 'gulp-plumber'
jade = require 'gulp-jade'
browserify = require 'browserify'
concat = require 'gulp-concat'
mainBowerFiles = require 'main-bower-files'
source = require 'vinyl-source-stream'
compass = require 'gulp-compass'
rimraf = require 'rimraf'
connect = require 'gulp-connect'

gulp.task 'connect', ->
  connect.server
    root: 'build'
    livereload: true

gulp.task 'clean', (cb)->
  rimraf './build', cb

gulp.task 'html', ->
  gulp
    .src './source/[^_]*.jade'
    .pipe plumber()
    .pipe jade()
    .pipe connect.reload()
    .pipe gulp.dest './build/'

gulp.task 'image', ->
  gulp.src './source/image/*'
  .pipe gulp.dest './build/image/'

gulp.task 'js', ->
  gulp.src(mainBowerFiles(filter: /\.js$/))
    .pipe plumber()
    .pipe connect.reload()
    .pipe concat 'vendor.js'
    .pipe gulp.dest './build/js/'

  browserify
    entries: [ './source/js/main.coffee']
    extensions: ['.coffee', '.js', '.jade']
  .transform 'coffeeify'
  .transform 'jadeify'
  .bundle()
  .pipe plumber()
  .pipe connect.reload()
  .pipe source 'main.js'
  .pipe gulp.dest './build/js/'

gulp.task 'css', ->
  gulp
    .src './source/css/**/*.{s,}css'
    .pipe plumber(errorHandler: (error)->
      console.log error.message
      @emit 'end'
    )
    .pipe connect.reload()
    .pipe compass(css: 'build/css', sass: 'source/css', require: ['susy'])
    .pipe gulp.dest './build/css/'

gulp.task 'watch', ['connect', 'build'], ->
  gulp.watch 'source/js/**/*.{js,coffee}', ['js']
  gulp.watch 'source/**/*.jade', ['html', 'js']
  gulp.watch 'source/css/**/*.{s,}css', ['css']
  gulp.watch 'source/image/**/*.{png,jpeg,gif}', ['image']
  gulp.watch 'bower_components/**/*.js', ['js']

gulp.task 'build', ['html', 'js', 'css', 'image']
gulp.task 'default', ['clean', 'build']
