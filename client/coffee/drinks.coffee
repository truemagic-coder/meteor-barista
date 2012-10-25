Template.drinks_index.events
  'click .edit': -> Router.drinks_edit_path(@)
  'click .delete': -> Drinks.remove({_id: @._id})
  'click #new': -> Router.navigate('drinks/new', {trigger: true})
        
Template.drinks_new.events
  'click #create': -> 
    size = $('#size option:selected').val()
    name = $('#name').val().capitalize()
    price = parseFloat($('#price').val())
    Meteor.call 'drinks_insert', name, size, price, (err, data) ->
      Router.navigate('drinks', {trigger: true})
  'click #back': -> window.Back('drinks')

Template.drinks_edit.events
  'click #update': -> 
    size = $('#size option:selected').val()
    name = $('#name').val().capitalize()
    price = parseFloat($('#price').val())
    Meteor.call 'drinks_update', Session.get('id'), name, size, price, (err, data) ->
      Router.navigate('drinks', {trigger: true})
    Router.navigate('drinks', {trigger: true})
  'click #back': -> window.Back('drinks')

Template.drinks_index.drinks = -> Drinks.find()
Template.drinks_new.sizes = -> Sizes.find()
Template.drinks_edit.sizes = -> Sizes.find()
Template.drink.price = -> accounting.formatMoney(@.price)
Template.drinks_edit.created = -> 
  Meteor.call 'drink', Session.get('id'), (err, data) ->
    # use jQuery as @.data is not in the created method
    $("#size option[value='" + data.size + "']").attr('selected', 'selected')
    $('#name').val(data.name)
    $('#price').val(data.price)