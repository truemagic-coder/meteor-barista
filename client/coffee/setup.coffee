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

# create quasi-RESTful routing (new, index, and edit) - the first slash is required by page.js
# for edit action -> store object id in a Session variable as accessing Template.data is not always possible
Meteor.Router.add
  '/': 'home'
  '/foods': 'foods_index'
  '/foods/new': 'foods_new'
  '/foods/:id/edit': (params) ->
    Session.set('id', params[0])
    'foods_edit'
  '/drinks': 'drinks_index'
  '/drinks/new': 'drinks_new'
  '/drinks/:id/edit': (params) ->
    Session.set('id', params[0])
    'drinks_edit'
  '/orders': 'orders_index'
  '/orders/new': 'orders_new'
  '/orders/:id/edit': (params) ->
    Session.set('id', params[0])
    'orders_edit'

# create links on the layout to access the various index pages 
Template.layout.events
  'click #logo': -> Meteor.Router.to('/logos')
  'click #foods': -> Meteor.Router.to('/foods')
  'click #drinks': -> Meteor.Router.to('/drinks')
  'click #orders': -> Meteor.Router.to('/orders')