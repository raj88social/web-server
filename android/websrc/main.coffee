# Generated by CoffeeScript 1.3.3

#
#                 * if the user refreshed we want to show whatever page we were on before but
#                 * in the case of the conversation pages we are generating them dynamically
#                 * so we need to rebuild the page
#

#
#                 * ko.bindingHandlers.jqmPage = init: (element, valueAccessor) -> # if
#                 * element? and element.length > 0 console.log 'jqmPage init, element: ' +
#                 * element #ko.utils.unwrapObservable valueAccessor() #just to create a
#                 * dependency setTimeout (-> #To make sure the refresh fires after the DOM
#                 * is updated $(element).parent('div')[0].updateLayout() ), 0,
#                 *
#                 * update: (element, valueAccessor) -> # if element? and element.length > 0
#                 * console.log 'jqmPage, element: ' + element #ko.utils.unwrapObservable
#                 * valueAccessor() #just to create a dependency setTimeout (-> #To make sure
#                 * the refresh fires after the DOM is updated
#                 * $(element).parent('div')[0].updateLayout() ), 0
#
requirejs.config
  shim:
    "socket.io":
      exports: "io"

  paths:
    cordova: "../lib/cordova-2.0.0"
    jquery: "../lib/jquery-1.7.1"
    jqm: "../lib/jquery.mobile-1.1.1"
    "socket.io": "../lib/socket.io"
    knockout: "../lib/knockout-2.1.0.debug"

require ["jquery", "cordova"], ($, cordova) ->
  $(document).bind "deviceready", ->
    console.log "ready"
    require ["jqm"], ->
      $("body").css "visibility", "visible"

    $(document).bind "mobileinit", ->
      console.log "mobileinit"
      $.mobile.defaultPageTransition = "none"
      $.ajaxSetup
        contentType: "application/json; charset=utf-8"
        statusCode:
          401: ->
            $.mobile.changePage "#login"


    require ["knockout", "./chatcontroller", "./uicontroller", "./usercontroller", "./viewmodels/UserViewModel", "./viewmodels/FriendsViewModel", "./viewmodels/ListViewModel", "./viewmodels/NotificationsViewModel"], (ko, chatController, uiController) ->
      chatController.connect()
      redirectToConversation = undefined
      redirectToConversation = (event, locationHash) ->
        index = undefined
        index = locationHash.indexOf("#conversation")
        if index > -1
          event.preventDefault()
          console.log "redirectToConversation: " + locationHash
          uiController.recreateConversation locationHash

      ko.bindingHandlers.jqmRefreshList = update: (element, valueAccessor) ->
        console.log "jqmRefreshList, element css: " + $(element).attr("class")
        setTimeout (->
          $(element).trigger "create"
          $(element).listview()
          $(element).listview "refresh"
        ), 100

      $(document).one "pagebeforechange", (event, data) ->
        if typeof data.toPage is "string"
          console.log "pagebeforechange: " + data.toPage
          redirectToConversation event, data.toPage
        else
          console.log "pagebeforechange: " + data.toPage[0].id
          redirectToConversation event, location.hash  if location.hash.indexOf("#conversation_") > -1




