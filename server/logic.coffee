createIfNotExists = (name) ->
  doc = {owner:Meteor.userId(),title:name}
  Groups.insert doc unless Groups.findOne doc

Meteor.methods
  'welcome' : ->
    _.each 'to-do doing done'.split(' '), createIfNotExists

