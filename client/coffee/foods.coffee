# events
# note: e is event and t is template
# find is Template find
Template.foods_index.events
  'click .edit': -> Router.foods_edit_path(@)
  'click .delete': -> Foods.remove({_id: @._id})
  'click #new': -> Router.navigate('foods/new', {trigger: true})
        
Template.foods_new.events
  'click #create': (e, t) -> 
    # use sugarjs to capitalize 
    name = t.find('#price').value.capitalize()
    # save as a number - otherwise it will default to string 
    gram = parseFloat(t.find('#pgram').value)
    price = parseFloat(t.find('#price').value)
    Meteor.call 'foods_insert', name, gram, price, (err, data) ->
      Router.navigate('foods', {trigger: true})
  'click #back': -> window.Back('foods')
  'keyup #price': (e, t) ->
    # submit on enter key
    if e.keyCode is 13
      # use sugarjs to capitalize 
      name = t.find('#name').value.capitalize()
      # save as a number - otherwise it will default to string 
      gram = parseFloat(t.find('#pgram').value)
      price = parseFloat(t.find('#price').value)
      Meteor.call 'foods_insert', name, gram, price, (err, data) ->
        Router.navigate('foods', {trigger: true})

Template.foods_edit.events
  'click #update': (e, t) -> 
    console.log window.model.isValid()
    # use sugarjs to capitalize 
    name = t.find('#name').value.capitalize()
    # save as a number - otherwise it will default to string 
    gram = parseFloat(t.find('#pgram').value)
    price = parseFloat(t.find('#price').value)
    Meteor.call 'foods_update', Session.get('id'), name, gram, price, (err, data) ->
      #Router.navigate('foods', {trigger: true})
  'click #back': -> window.Back('foods')
  'keyup #price': (e, t) ->
    # submit on enter key
    if e.keyCode is 13
      # use sugarjs to capitalize 
      name = t.find('#name').value.capitalize()
      # save as a number - otherwise it will default to string 
      gram = parseFloat(t.find('#pgram').value)
      price = parseFloat(t.find('#price').value)
      Meteor.call 'foods_update', Session.get('id'), name, gram, price, (err, data) ->
        Router.navigate('foods', {trigger: true})

# lists
Template.foods_index.foods = -> Foods.find()

# formatters
Template.food.pgram = -> accounting.formatMoney(@.pgram)
Template.food.price = -> accounting.formatMoney(@.price)

# populate the edit fields via knockout
Template.foods_edit.rendered = ->
  ko.validation.rules.pattern.message = 'Invalid.'
    
  ko.validation.configure
    registerExtenders: true
    messagesOnModified: true
    insertMessages: true
    parseInputAttributes: true
    messageTemplate: null

  viewModel = 
    firstName: ko.observable().extend({ minLength: 2, maxLength: 10 })
    lastName: ko.observable().extend({ required: true })
    emailAddress: ko.observable().extend({required: true})
    age: ko.observable().extend({ min: 1, max: 100 })
    location: ko.observable()
    subscriptionOptions: ['Technology', 'Music']
    subscription: ko.observable().extend({ required: true })
    submit: -> 
      if viewModel.errors().length is 0
        alert('Thank you.')
      else
        alert('Please check your submission.')
        viewModel.errors.showAllMessages()

  viewModel.errors = ko.validation.group(viewModel)
  ko.applyBindings(viewModel)
