# events
Template.foods_index.events
  'click .edit': -> Router.foods_edit_path(@)
  'click .delete': -> Foods.remove({_id: @._id})
  'click #new': -> Router.navigate('foods/new', {trigger: true})
        
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

  model =  
    name: ko.observable().extend({required: true, maxLength: 20})
    pgram: ko.observable().extend({required: true, max: 1})
    price: ko.observable().extend({required: true, max: 20})
    back: -> window.Back('foods')
    submit: ->
      if model.errors().length is 0
        Meteor.call 'foods_insert', ko.toJS(@), (err, data) ->
          Router.navigate('foods', {trigger: true})
      else
        model.errors.showAllMessages()

  model.errors = ko.validation.group(model)
  ko.applyBindings(model)

Template.foods_edit.rendered = -> 
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

  # populate the data into the form when rendered 
  # won't keep in sync - in order to allow non-interrupted typing
  Meteor.call 'food', Session.get('id'), (err, data) ->
    model =  
      name: ko.observable(data.name).extend({required: true, maxLength: 20})
      pgram: ko.observable(data.pgram).extend({required: true, max: 1})
      price: ko.observable(data.price).extend({required: true, max: 20})
      back: -> window.Back('foods')
      submit: ->
        if model.errors().length is 0
          console.log ko.toJS(@)
          Meteor.call 'foods_update', Session.get('id'), ko.toJS(@), (err, data) ->
            Router.navigate('foods', {trigger: true})
        else
          model.errors.showAllMessages()

    model.errors = ko.validation.group(model)
    ko.applyBindings(model)