# events
Template.drinks_index.events
  'click .edit': -> Router.drinks_edit_path(@)
  'click .delete': -> Drinks.remove({_id: @._id})
  'click #new': -> Router.navigate('drinks/new', {trigger: true})
        
Template.drinks_new.events
  'click #create': -> 
    size = $('#size option:selected').val()
    # use sugarjs to capitalize 
    name = $('#name').val().capitalize()
    # save as a number - otherwise it will default to string 
    price = parseFloat($('#price').val())
    Meteor.call 'drinks_insert', name, size, price, (err, data) ->
      Router.navigate('drinks', {trigger: true})
  'click #back': -> window.Back('drinks')

Template.drinks_edit.events
  'click #update': -> 
    size = $('#size option:selected').val()
    name = $('#name').val().capitalize()
    # save as a number - otherwise it will default to string 
    price = parseFloat($('#price').val())
    Meteor.call 'drinks_update', Session.get('id'), name, size, price, (err, data) ->
      Router.navigate('drinks', {trigger: true})
    Router.navigate('drinks', {trigger: true})
  'click #back': -> window.Back('drinks')

# lists
Template.drinks_index.drinks = -> Drinks.find()

# selects
Template.drinks_new.sizes = -> Sizes.find()
Template.drinks_edit.sizes = -> Sizes.find()

# formatters
Template.drink.price = -> accounting.formatMoney(@.price)

# populate the edit form with the existing values
Template.drinks_edit.created = -> 
  Meteor.call 'drink', Session.get('id'), (err, data) ->
    # use jQuery as @.data is not in the created method
    $("#size option[value='" + data.size + "']").attr('selected', 'selected')
    $('#name').val(data.name)
    $('#price').val(data.price)