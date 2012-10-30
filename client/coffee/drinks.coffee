# events
Template.drinks_index.events
  'click .edit': -> Router.drinks_edit_path(@)
  'click .delete': -> Drinks.remove({_id: @._id})
  'click #new': -> Router.navigate('drinks/new', {trigger: true})

# lists
Template.drinks_index.drinks = -> Drinks.find()

# formatters
Template.drink.price = -> accounting.formatMoney(@.price)

Template.drinks_new.rendered = ->    
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

  Meteor.call 'sizes', (err, data) ->
    model =  
      name: ko.observable().extend({required: true, maxLength: 20})
      size: ko.observable().extend({required: true})
      price: ko.observable().extend({required: true, max: 20})
      sizes: ko.observableArray(data.data)
      back: -> window.Back('drinks')
      submit: ->
        if model.errors().length is 0
          Meteor.call 'drinks_insert', ko.toJS(@), (err, data) ->
            Router.navigate('drinks', {trigger: true})
        else
          model.errors.showAllMessages()

    model.errors = ko.validation.group(model)
    ko.applyBindings(model)

Template.drinks_edit.rendered = -> 
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

  # populate the data into the form when rendered 
  # won't keep in sync - in order to allow non-interrupted typing
  Meteor.call 'drink', Session.get('id'), (err, data) ->
    model =  
      name: ko.observable(data.drink.name).extend({required: true, maxLength: 20})
      size: ko.observable(data.drink.size).extend({required: true})
      price: ko.observable(data.drink.price).extend({required: true, max: 20})
      sizes: ko.observableArray(data.sizes.data)
      back: -> window.Back('drinks')
      submit: ->
        if model.errors().length is 0
          Meteor.call 'drinks_update', Session.get('id'), ko.toJS(@), (err, data) ->
            Router.navigate('drinks', {trigger: true})
        else
          model.errors.showAllMessages()

    model.errors = ko.validation.group(model)
    ko.applyBindings(model)