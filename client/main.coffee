Members = new Meteor.Collection('members')

boards = ->
  Boards.find({owner:Meteor.userId()})

Template.main.helpers
  'boards' : boards
  'is_active' : ->
    "active" if Session.equals('board',@_id)
  'board' : ->
    Boards.findOne(Session.get('board')) if Session.get('board')

Template.main.events
  'click .create' : ->
    bootbox.prompt 'Name your board', (result) ->
      return unless result
      Meteor.call 'board.create', {name:result}
  'click .board' : ->
    Session.set('board',@_id)

Template.board.helpers
  'groups' : ->
    Groups.find({board:@_id})

Template.board.events
  'click .group' : ->
    Session.set('group',@_id)

Template.group.helpers
  'cards' : ->
    Cards.find({group:@_id},{sort:{order:1}})

Template.group.events
  'click .add' : ->
    bootbox.prompt 'title?', (result) =>
      Cards.insert({group:@_id,title:result}) if result

Template.card.events
  'click .delete' : ->
    bootbox.confirm 'are you sure?', (result) =>
      Cards.remove(@_id)
  'click .card' : ->
      Session.set('card',@_id) unless Session.get('dragging')

Template.card.rendered = ->
  $e = $(this.find('.card'))
  $e.data('id',@data._id)
  $e.draggable
    revert:true
    start:=>
      $e.addClass('dragging')
      Session.set('dragging',@data)
    stop:=>
      $e.removeClass('dragging')
      Session.set('dragging')


Template.group.rendered = ->
  $e = $(this.find('.group'))

  $e.droppable
    accept:'.card'
    activeClass:'drop-target'
    hoverClass:'to-drop'
    drop:(e,ui)=>
      Cards.update(ui.draggable.data('id'),{$set:{group:@data._id}})

Template.detailCard.helpers
  'show' : -> Session.get('card')
  'card' : -> Cards.findOne(Session.get('card'))

Template.detailCard.events
  'click .close, click .ok' : ->
    Session.set('card')

  'click .delete' : ->
    bootbox.confirm 'are you sure?', (result) =>
      Cards.remove(@_id)

  'click .edit' : ->
    bootbox.prompt @title, (result) =>
      Cards.update(@_id,{$set:{message:result}}) if result

Meteor.autosubscribe ->
  if Session.get('user')?._id != Meteor.user()?._id
    Session.set 'user', Meteor.user()
    if Meteor.user()
      Meteor.call 'welcome'
      Meteor.setTimeout (->
        Session.set('board',boards().fetch()[0]?._id)
      ), 100
    else
      Session.set('board')

  Meteor.subscribe 'members'
  Meteor.subscribe 'groups', Session.get('board') if Session.get('board')
  Meteor.subscribe 'cards'
  Meteor.subscribe 'boards'