Template.foods_index.events
  'click .edit': -> Router.foods_edit_path(@)
  'click .delete': -> Foods.remove({_id: @._id})
  'click #new': -> Router.navigate('foods/new', {trigger: true})
        
Template.foods_new.events
  'click #create': (e, t) -> 
    name = t.find('#name').value.capitalize()
    gram = parseFloat(t.find('#gram').value)
    price = parseFloat(t.find('#price').value)
    Meteor.call 'foods_insert', name, gram, price, (err, data) ->
      Router.navigate('foods', {trigger: true})
  'click #back': -> window.Back('foods')
  'keyup #price': (e, t) ->
    # submit on enter key
    if e.keyCode is 13
      name = t.find('#name').value.capitalize()
      gram = parseFloat(t.find('#gram').value)
      price = parseFloat(t.find('#price').value)
      Meteor.call 'foods_insert', name, gram, price, (err, data) ->
        Router.navigate('foods', {trigger: true})

Template.foods_edit.events
  'click #update': (e, t) -> 
    name = t.find('#name').value.capitalize()
    gram = parseFloat(t.find('#gram').value)
    price = parseFloat(t.find('#price').value)
    Meteor.call 'foods_update', Session.get('id'), name, gram, price, (err, data) ->
      Router.navigate('foods', {trigger: true})
  'click #back': -> window.Back('foods')
  'keyup #price': (e, t) ->
    # submit on enter key
    if e.keyCode is 13
      name = t.find('#name').value.capitalize()
      gram = parseFloat(t.find('#gram').value)
      price = parseFloat(t.find('#price').value)
      Meteor.call 'foods_update', Session.get('id'), name, gram, price, (err, data) ->
        Router.navigate('foods', {trigger: true})


Template.foods_index.foods = -> Foods.find()
Template.food.pgram = -> accounting.formatMoney(@.pgram)
Template.food.price = -> accounting.formatMoney(@.price)
Template.foods_edit.created = -> 
  Meteor.call 'food', Session.get('id'), (err, data) ->
    # use jQuery as @.data is not in the created method
    $('#name').val(data.name)
    $('#price').val(data.price)
    $('#gram').val(data.pgram)