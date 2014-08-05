fs = require 'fs'
{spawn} = require 'child_process'
{exec} = require 'child_process'
path = require 'path'
util = require 'util'

editorPath = atom.project.path
basePath = path.dirname editorPath
basePathArray = basePath.split('/');
basePath = basePathArray.pop();
projectFile = '';

getProject = (sln) ->
  if /.*\.sln$/g.test(sln)
    projectFile = path.resolve basePath, sln

goGetProject = (callback) ->
  fs.readdir basePath, (err, files) ->
    if err
      console.log(err)
    gotit = getProject sln for sln in files

    if projectFile.length > 1
      callback projectFile
    else
      callback false

# C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe
# C:\Windows\Microsoft.NET\Framework\v3.5\MSBuild.exe
# http://tortoisesvn.net/docs/nightly/TortoiseSVN_en/tsvn-cli-main.html


module.exports =
  activate: (state) ->
    atom.workspaceView.command "VSHooks:build", => @build()
    atom.workspaceView.command "VSHooks:run", => @run()
    atom.workspaceView.command "VSHooks:commit", => @commit()
    atom.workspaceView.command "VSHooks:update", => @update()

  build: ->
    goGetProject (projFile) ->
      console.log projFile
      if !projFile
        return alert 'Cannot Find .sln File in: ' + basePath

      runCmds = exec '"C:\\Windows\\Microsoft.NET\\Framework\\v3.5\\msbuild.exe " ' + projFile

      runCmds.stdout.on "data", (data) ->
        console.log "stdout: " + data

      runCmds.stderr.on "data", (data) ->
        console.log "stderr: " + data

      runCmds.on "close", (code) ->
        console.log "child process exited with code " + code

  run: ->
    goGetProject (projFile) ->
      console.log basePath
      console.log projFile
      if !projFile
        return alert 'Cannot Find .sln File in: ' + basePath

      runCmds = exec '"C:\\Program Files (x86)\\Microsoft Visual Studio 9.0\\Common7\\IDE\\devenv.exe" ' + projFile + ' /run'

      runCmds.stdout.on "data", (data) ->
        console.log "stdout: " + data

      runCmds.stderr.on "data", (data) ->
        console.log "stderr: " + data

      runCmds.on "close", (code) ->
        console.log "child process exited with code " + code

  commit: ->
    console.log basePath
    runCmds = exec 'TortoiseProc /command:commit /path:"' + basePath + '"'

    runCmds.stdout.on "data", (data) ->
      console.log "stdout: " + data

    runCmds.stderr.on "data", (data) ->
      console.log "stderr: " + data

    runCmds.on "close", (code) ->
      console.log "child process exited with code " + code

  update: ->
    console.log basePath
    runCmds = exec 'TortoiseProc /command:update /path:"' + basePath + '"'

    runCmds.stdout.on "data", (data) ->
      console.log "stdout: " + data

    runCmds.stderr.on "data", (data) ->
      console.log "stderr: " + data

    runCmds.on "close", (code) ->
      console.log "child process exited with code " + code
