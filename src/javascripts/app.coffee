root = exports ? this

# application controller - co-ordinates the marshalling of user input and rendering of the web page view
class root.AppController

  @activate: ->
    try
      $('[data-toggle="tooltip"]').tooltip(container: 'body')

jQuery ->
  new root.AppController.activate()