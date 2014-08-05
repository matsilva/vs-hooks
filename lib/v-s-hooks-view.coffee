{View} = require 'atom'

module.exports =
class VSHooksView extends View
  @content: ->
    @div class: 'v-s-hooks overlay from-top', =>
      @div "The VSHooks package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "v-s-hooks:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "VSHooksView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
