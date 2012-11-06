# events
Template.foods_index.events
  'click .edit': -> Meteor.Router.to("/foods/#{@._id}/edit")
  'click .delete': -> Foods.remove({_id: @._id})
  'click #new': -> Meteor.Router.to('/foods/new')
        
# lists
Template.foods_index.foods = -> Foods.find()

# formatters
Template.food.pgram = -> accounting.formatMoney(@.pgram)
Template.food.price = -> accounting.formatMoney(@.price)

Template.foods_new.rendered = ->    
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

  class Model
    constructor: ->   
      @name = ko.observable().extend({required: true, maxLength: 20})
      @pgram = ko.observable().extend({required: true, max: 1})
      @price = ko.observable().extend({required: true, max: 20})
      @errors = ko.validation.group(@)
    back: -> Meteor.Router.to('/foods')
    submit: =>
      if @.errors().length is 0
        Meteor.call 'foods_insert', ko.toJS(@), (err, data) ->
          Meteor.Router.to('/foods')
      else
        @.errors.showAllMessages()

  ko.applyBindings(new Model)

Template.foods_edit.rendered = -> 
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

  class Model   
    constructor: ->
      @name = ko.observable().extend({required: true, maxLength: 20})
      @pgram = ko.observable().extend({required: true, max: 1})
      @price = ko.observable().extend({required: true, max: 20})
      @food = ko.meteor.findOne(Foods, {_id: Session.get('id')})
      @populate = ko.computed =>
        data = ko.toJS(@food)
        if !data
          return false
        else
          @name(data.name)
          @pgram(data.pgram)
          @price(data.price)
          return true
      , this
      @errors = ko.validation.group(@)
    back: -> Meteor.Router.to('/foods')
    submit: =>
      if @.errors().length is 0
        Meteor.call 'foods_update', Session.get('id'), ko.toJS(@), (err, data) ->
          Meteor.Router.to('/foods')
      else
        @.errors.showAllMessages()

  ko.applyBindings(new Model)