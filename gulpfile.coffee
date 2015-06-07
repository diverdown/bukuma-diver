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
rev        = require 'gulp-rev'
revReplace = require 'gulp-rev-replace'
runSequence= require 'run-sequence'
{merge}    = require 'event-stream'
fs         = require 'fs'

env = process.env.NODE_ENV || (process.env.NODE_ENV = 'development')
require('dotenv').config(path: ".env.#{env}")

WEB_PATH = 'web'
WEB_BUILD_PATH  = "#{WEB_PATH}/build/#{env}"
WEB_SOURCE_PATH = "#{WEB_PATH}/source"
EXTENSION_PATH = './chrome_extension'
EXTENSION_BUILD_PATH = "#{EXTENSION_PATH}/build/#{env}"
EXTENSION_SOURCE_PATH = "#{EXTENSION_PATH}/source"

gulp.task 'clean', (callback)->
  del [WEB_BUILD_PATH, EXTENSION_BUILD_PATH], callback
  null

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
  merge(
    gulp.src "#{WEB_SOURCE_PATH}/analytics.js"
      .pipe gulp.dest "#{WEB_BUILD_PATH}/js/"

    browserify(
      entries: [ "./#{WEB_SOURCE_PATH}/main.coffee"]
      extensions: ['.coffee', '.js', '.jade']
      degug: true
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
      .pipe sourcemaps.init(loadMaps: true)
      .pipe uglify(preserveComments: 'some')
      .pipe sourcemaps.write('./')
      .pipe gulp.dest "#{WEB_BUILD_PATH}/js/"
      .pipe livereload()
  )
gulp.task 'css', ->
  gulp
    .src "#{WEB_SOURCE_PATH}/css/main.{s,}css"
    .pipe plumber(errorHandler: (error)->
      console.log error.message
      @emit 'end'
    )
    .pipe compass(css: "#{WEB_BUILD_PATH}/css", sass: "#{WEB_SOURCE_PATH}/css")
    .pipe minifyCSS(aggressiveMerging: false, restructuring: false)
    .pipe gulp.dest "#{WEB_BUILD_PATH}/css/"
    .pipe livereload()

gulp.task 'extension', ->
  merge(
    gulp
      .src "#{EXTENSION_SOURCE_PATH}/*.json"
      .pipe gulp.dest EXTENSION_BUILD_PATH

    gulp
      .src "#{EXTENSION_SOURCE_PATH}/image/*"
      .pipe gulp.dest "#{EXTENSION_BUILD_PATH}/image/"
    browserify(entries: [ "#{EXTENSION_SOURCE_PATH}/background.coffee"])
      .transform coffeeify
      .transform envify()
      .bundle()
      .pipe plumber()
      .pipe source 'background.js'
      .pipe gulp.dest "#{EXTENSION_BUILD_PATH}/"
  )

MANIFEST_PATH = "./rev-manifest.json"
addRevision = (globs)->
  gulp.src globs
    .pipe rev()
    .pipe gulp.dest(WEB_BUILD_PATH)
    .pipe rev.manifest(merge: true)
    .pipe gulp.dest('.')

replaceRevision = (globs)->
  gulp.src globs
    .pipe revReplace(manifest: gulp.src(MANIFEST_PATH))
    .pipe gulp.dest WEB_BUILD_PATH

gulp.task 'revision:font,image', ->
  addRevision(["#{WEB_BUILD_PATH}/{image,font}/*"])

gulp.task 'revision:css,js', (callback)->
  replaceRevision("#{WEB_BUILD_PATH}/{css,js}/*")
    .on 'end', ->
      addRevision(["#{WEB_BUILD_PATH}/{css,js}/**/*.{css,js}"]) # without .map
        .on 'end', callback
  null

gulp.task 'revision:replace', ->
  replaceRevision("#{WEB_BUILD_PATH}/index.html")

gulp.task 'revision:clean', (callback)->
  manifest = JSON.parse(fs.readFileSync(MANIFEST_PATH))
  seeds = Object.keys(manifest).map (path)-> "#{WEB_BUILD_PATH}/#{path}"
  seeds.push(MANIFEST_PATH)
  del seeds, callback

gulp.task 'revision', (callback)->
  runSequence 'revision:font,image', 'revision:css,js', 'revision:replace', 'revision:clean', callback

gulp.task 'watch', ['build'], ->
  livereload.listen()
  gulp.watch "#{WEB_SOURCE_PATH}/**/*.{js,coffee}", ['js']
  gulp.watch "#{WEB_SOURCE_PATH}/components/**/*.vue", ['js']
  gulp.watch "#{WEB_SOURCE_PATH}/**/*.jade", ['html', 'js']
  gulp.watch "#{WEB_SOURCE_PATH}/css/**/*.{s,}css", ['css']
  gulp.watch "#{WEB_SOURCE_PATH}/image/**/*.{png,jpeg,gif}", ['image']
  gulp.watch "#{WEB_SOURCE_PATH}/font/**/*.{eot,woff,ttf,svg}", ['font']
  gulp.watch 'bower_components/**/*.js', ['js']
  gulp.watch "#{EXTENSION_SOURCE_PATH}/**/*.{coffee,json,png,jpeg,gif}", ['extension']

gulp.task 'build', ['html', 'js', 'css', 'image', 'font', 'extension']
gulp.task 'default', -> runSequence 'clean', 'build', 'revision'
