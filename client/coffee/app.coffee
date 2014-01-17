Meteor.startup ->
  # foods
  @Foods = new Meteor.Collection('foods')
  Meteor.subscribe('foods')
  # drinks
  @Drinks = new Meteor.Collection('drinks')
  Meteor.subscribe('drinks')
  # types
  @Types = new Meteor.Collection('types')
  Meteor.subscribe('types')
  # sizes
  @Sizes = new Meteor.Collection('sizes')
  Meteor.subscribe('sizes')
  # orders
  @Orders = new Meteor.Collection('orders')
  Meteor.subscribe('orders')
  # baristas
  @Baristas = new Meteor.Collection('baristas')
  Meteor.subscribe('baristas')
  # statuses
  @Statuses = new Meteor.Collection('statuses')
  Meteor.subscribe('statuses')
  # products
  @Products = new Meteor.Collection('products')
  Meteor.subscribe('products')
  # modifications
  @Modifications = new Meteor.Collection('modifications')
  Meteor.subscribe('modifications')
  # mods
  @Mods = new Meteor.Collection('mods')
  Meteor.subscribe('mods')

  # for edit action -> store object id in a Session variable as accessing Template.data is not always possible
  Router.map ->
    @.route 'home',
      path: '/'
    @.route 'foods',
      path: '/foods'
      template: 'foods_index'
    @.route 'foods_new',
      path: '/foods/new'
      template: 'foods_new'
    @.route 'foods_edit',
      path: '/foods/:id/edit'
      template: 'foods_edit'
    @.route 'drinks',
      path: '/drinks'
      template: 'drinks_index'
    @.route 'drinks_new'
      path: '/drinks/new'
      template: 
  # go to /_routes to view routes
  Router.configure
    routesUri: '_routes'

  # '/drinks': 'drinks_index'
  # '/drinks/new': 'drinks_new'
  # '/drinks/:id/edit': (params) ->
  #   Session.set('id', params[0])
  #   'drinks_edit'
  # '/orders': 'orders_index'
  # '/orders/new': 'orders_new'
  # '/orders/:id/edit': (params) ->
  #   Session.set('id', params[0])
  #   'orders_edit'

# create links on the layout to access the various index pages 
Template.layout.events
  'click #logo': -> Router.go('logos')
  'click #foods': -> Router.go('foods')
  'click #drinks': -> Router.go('drinks')
  'click #orders': -> Router.go('orders')