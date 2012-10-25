# foods
Meteor.subscribe('foods')
Foods = new Meteor.Collection('foods')
# drinks
Meteor.subscribe('drinks')
Drinks = new Meteor.Collection('drinks')
# types
Meteor.subscribe('types')
Types = new Meteor.Collection('types')
# sizes
Meteor.subscribe('sizes')
Sizes = new Meteor.Collection('sizes')
# orders
Meteor.subscribe('orders')
Orders = new Meteor.Collection('orders')
# baristas
Meteor.subscribe('baristas')
Baristas = new Meteor.Collection('baristas')
# statuses
Meteor.subscribe('statuses')
Statuses = new Meteor.Collection('statuses')
# products
Meteor.subscribe('products')
Products = new Meteor.Collection('products')
# modifications
Meteor.subscribe('modifications')
Modifications = new Meteor.Collection('modifications')
# mods
Meteor.subscribe('mods')
Mods = new Meteor.Collection('mods')

window.Back = (root) ->
  if Backbone.history.length > 0
    prev_url = Backbone.history[Backbone.history.length - 1]
  else
    prev_url = root
  Router.navigate(prev_url, {trigger: true})

MyRouter = ReactiveRouter.extend
  routes: 
    '': 'home'
    'foods': 'foods_index'
    'foods/new': 'foods_new'
    'foods/:id/edit': 'foods_edit'
    'drinks': 'drinks_index'
    'drinks/new': 'drinks_new'
    'drinks/:id/edit': 'drinks_edit'
    'orders': 'orders_index'
    'orders/new': 'orders_new'
    'orders/:id/edit': 'orders_edit'
  home: ->
    @.goto 'home'
  foods_index: ->
    @.goto 'foods_index' 
  foods_new: ->
    @.goto 'foods_new'
  foods_edit: (id) ->
    Session.set 'id', id
    @.goto 'foods_edit'
  foods_edit_path: (product) ->
    url = "foods/#{product._id}/edit"
    @.navigate(url, {trigger: true})
  drinks_index: ->
    @.goto 'drinks_index' 
  drinks_new: ->
    @.goto 'drinks_new'
  drinks_edit: (id) ->
    Session.set 'id', id
    @.goto 'drinks_edit'
  drinks_edit_path: (product) ->
    url = "drinks/#{product._id}/edit"
    @.navigate(url, {trigger: true})
  orders_index: ->
    @.goto 'orders_index' 
  orders_new: ->
    @.goto 'orders_new'
  orders_edit: (id) ->
    Session.set 'id', id
    @.goto 'orders_edit'
  orders_edit_path: (product) ->
    url = "orders/#{product._id}/edit"
    @.navigate(url, {trigger: true})
Router = new MyRouter()

Template.layout.events
  'click #logo': -> Router.navigate('', {trigger: true})
  'click #foods': -> Router.navigate('foods', {trigger: true})
  'click #drinks': -> Router.navigate('drinks', {trigger: true})
  'click #orders': -> Router.navigate('orders', {trigger: true})

Meteor.startup -> Backbone.history.start({pushState: true})