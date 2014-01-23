# events
Template.drinks_index.events
  'click .edit': -> Router.go("drinks_edit", {id: @._id})
  'click .delete': -> Drinks.remove({_id: @._id})
  'click #new': -> Router.go('drinks_new')

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

  class Model   
    constructor: -> 
      @name = ko.observable().extend({required: true, maxLength: 20})
      @size = ko.observable().extend({required: true})
      @price = ko.observable().extend({required: true, max: 20})
      @sizer = ko.meteor.find(Sizes, {})
      # build dynamic dropdown list
      @sizes = ko.computed =>
        data = ko.toJS(@sizer)
        if !data
          return false
        else
          p = []
          for size in data
            p.push(size.name)
          return p
      , this
      @errors = ko.validation.group(@)
    back: -> Router.go('drinks')
    submit: =>
      if @.errors().length is 0
        Meteor.call 'drinks_insert', ko.toJS(@), (err, data) ->
          Router.go('drinks')
      else
        @.errors.showAllMessages()

  ko.applyBindings(new Model)

Template.drinks_edit.rendered = -> 
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

    class Model  
      constructor: ->
        @drink = ko.meteor.findOne(Drinks, {_id: Session.get('id')})
        @name = ko.observable().extend({required: true, maxLength: 20})
        @size = ko.observable().extend({required: true})
        @price = ko.observable().extend({required: true, max: 20})
        @sizer = ko.meteor.find(Sizes, {})
        # populate the existing values into the form
        @populate = ko.computed =>
          data = ko.toJS(@drink)
          if !data
            return false
          else
            @name(data.name)
            @size(data.size)
            @price(data.price)
            return true
        , this
        # build dynamic dropdown list
        @sizes = ko.computed =>
          data = ko.toJS(@sizer)
          if !data
            return false
          else
            p = []
            for size in data
              p.push(size.name)
            return p
        , this
        @errors = ko.validation.group(@)
      back: -> Router.go('drinks')
      submit: =>
        if @.errors().length is 0
          Meteor.call 'drinks_update', Session.get('id'), ko.toJS(@), (err, data) ->
            Router.go('drinks')
        else
          @.errors.showAllMessages()

    ko.applyBindings(new Model)