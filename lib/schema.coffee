this.Boards = new Meteor.Collection('boards')
this.Cards = new Meteor.Collection('cards')
this.Groups = new Meteor.Collection('groups')

Meteor.methods
  'welcome' : ->
    unless Boards.findOne {owner:@userId}
      Meteor.call 'board.create', name:'Welcome board'

  'board.create' : (options) ->
    options ?= {}
    board = Boards.insert {owner:@userId,name:options.name}
    Groups.insert {board:board, title:g} for g in 'to-do doing done'.split(' ')
    board