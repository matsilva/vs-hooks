{WorkspaceView} = require 'atom'
VSHooks = require '../lib/v-s-hooks'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "VSHooks", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('v-s-hooks')

  describe "when the v-s-hooks:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.v-s-hooks')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'v-s-hooks:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.v-s-hooks')).toExist()
        atom.workspaceView.trigger 'v-s-hooks:toggle'
        expect(atom.workspaceView.find('.v-s-hooks')).not.toExist()
