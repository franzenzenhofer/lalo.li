fs     = require 'fs'
{exec} = require 'child_process'

task 'minjs', 'Minify Js', ->
  exec 'java -jar "/Users/franzseo/bin/compiler.jar" --compilation
_level SIMPLE_OPTIMIZATIONS --js lib/knob/jquery.knob.js lib/speak/speakClient.js lib/vendor/json2.js lib/vendor/base64.js lib/vendor/rawinflate.js lib/vendor/rawdeflate.js lib/main.js --js_output_file lib/min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

#java -jar /Users/franzseo/bin/htmlcompressor.jar -o index.html index-source.html
task 'minhtml', 'Minify HTML', ->
  exec 'java -jar /Users/franzseo/bin/htmlcompressor.jar -o index.html index.src.html', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

#java -jar /Users/franzseo/bin/yui.jar -o min.css style.css
task 'mincss', 'Minify CSS', ->
  exec 'java -jar /Users/franzseo/bin/yui.jar -o css/min.css css/style.css', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'copy', 'copy to franzenzenhofer.github.com/', ->
  exec 'cp -f /Users/franzseo/dev/laloli/index.html /Users/franzseo/dev/franzenzenhofer.github.com/index.html', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -f /Users/franzseo/dev/laloli/favicon.ico /Users/franzseo/dev/franzenzenhofer.github.com/favicon.ico', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -f /Users/franzseo/dev/laloli/lib/min.js /Users/franzseo/dev/franzenzenhofer.github.com/lib/min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -f /Users/franzseo/dev/laloli/lib/speak/speakGenerator.js /Users/franzseo/dev/franzenzenhofer.github.com/lib/speak/speakGenerator.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -R -f /Users/franzseo/dev/laloli/lib/speak  /Users/franzseo/dev/franzenzenhofer.github.com/lib/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -R -f /Users/franzseo/dev/laloli/img /Users/franzseo/dev/franzenzenhofer.github.com/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -R -f /Users/franzseo/dev/laloli/css /Users/franzseo/dev/franzenzenhofer.github.com/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr