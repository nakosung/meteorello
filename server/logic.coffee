Meteor.publish 'boards', ->
  Boards.find({owner:@userId})

Meteor.publish 'groups', (board) ->
  Groups.find({board:board})

Meteor.publish 'cards', ->
  Cards.find()

Meteor.publish 'members', ->
  Meteor.users.find()