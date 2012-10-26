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
    name = t.find('#name').value.capitalize()
    # set the type of float - otherwise it save as string
    gram = parseFloat(t.find('#gram').value)
    price = parseFloat(t.find('#price').value)
    Meteor.call 'foods_insert', name, gram, price, (err, data) ->
      Router.navigate('foods', {trigger: true})
  'click #back': -> window.Back('foods')
  'keyup #price': (e, t) ->
    # submit on enter key
    if e.keyCode is 13
      # use sugarjs to capitalize 
      name = t.find('#name').value.capitalize()
      # set the type of float - otherwise it save as string
      gram = parseFloat(t.find('#gram').value)
      price = parseFloat(t.find('#price').value)
      Meteor.call 'foods_insert', name, gram, price, (err, data) ->
        Router.navigate('foods', {trigger: true})

Template.foods_edit.events
  'click #update': (e, t) -> 
    # use sugarjs to capitalize 
    name = t.find('#name').value.capitalize()
    # set the type of float - otherwise it save as string
    gram = parseFloat(t.find('#gram').value)
    price = parseFloat(t.find('#price').value)
    Meteor.call 'foods_update', Session.get('id'), name, gram, price, (err, data) ->
      Router.navigate('foods', {trigger: true})
  'click #back': -> window.Back('foods')
  'keyup #price': (e, t) ->
    # submit on enter key
    if e.keyCode is 13
      # use sugarjs to capitalize 
      name = t.find('#name').value.capitalize()
      # set the type of float - otherwise it save as string
      gram = parseFloat(t.find('#gram').value)
      price = parseFloat(t.find('#price').value)
      Meteor.call 'foods_update', Session.get('id'), name, gram, price, (err, data) ->
        Router.navigate('foods', {trigger: true})

# lists
Template.foods_index.foods = -> Foods.find()

# formatters
Template.food.pgram = -> accounting.formatMoney(@.pgram)
Template.food.price = -> accounting.formatMoney(@.price)

# populate the edit form with the existing values
Template.foods_edit.created = -> 
  Meteor.call 'food', Session.get('id'), (err, data) ->
    # use jQuery as @.data (Spark data) is only available in the rendered method
    $('#name').val(data.name)
    $('#price').val(data.price)
    $('#gram').val(data.pgram)