exec = require("child_process").exec
path = require('path')
fs = require('fs')

module.exports =

  config:
    app:
      type: 'string'
      default: '/Applications/iTerm.app'
      title: 'Application Path'
      description: 'Path to the iTerm (or other terminal) application.'
    args:
      type: 'string'
      default: ''
      title: 'Arguments (optional)'
      description: 'Additional arguments to pass to the terminal applciation'

  activate: ->
    atom.commands.add '.tree-view .selected',
      'open-iterm-here:open': (event) => @open(event.currentTarget)

  open: (target) ->
    isDarwin = document.body.classList.contains("platform-darwin")

    filepath = target.getPath?() ? target.item?.getPath()

    dirpath = filepath

    if fs.lstatSync(filepath).isFile()
      dirpath = path.dirname(filepath)

    return if not dirpath

    if isDarwin
      @openDarwin dirpath

  openDarwin: (dirpath) ->
    app = atom.config.get('open-iterm-here.app')
    args = atom.config.get('open-iterm-here.args')
    exec "open -a #{app} #{args} #{dirpath}"
