Template.board.helpers
  'groups' : ->
    Groups.find({owner:Meteor.userId()})

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
      Session.set('card',@_id)

Template.card.rendered = ->
  $e = $(this.find('.card'))
  $e.data('id',@data._id)
  $e.draggable revert:true

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

lastUser = null
Meteor.autosubscribe ->
  if lastUser != Meteor.user()
    lastUser = Meteor.user()
    Meteor.call 'welcome' if lastUser