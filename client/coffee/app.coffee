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
      layoutTemplate: 'layout'
    @.route 'foods',
      path: '/foods',
      template: 'foods_index'
      layoutTemplate: 'layout'
    @.route 'foods_new',
      path: '/foods/new'
      template: 'foods_new',
      layoutTemplate: 'layout'
    @.route 'foods_edit',
      path: '/foods/:id/edit'
      template: 'foods_edit'
      layoutTemplate: 'layout'
      data: ->
        @.params.id
      onBeforeAction: ->
        Session.set('id', @.params.id)
    @.route 'drinks',
      path: '/drinks'
      template: 'drinks_index'
      layoutTemplate: 'layout'
    @.route 'drinks_new',
      path: '/drinks/new'
      template: 'drinks_new'
      layoutTemplate: 'layout'
    @.route 'drinks_edit',
      path: '/drinks/:id/edit'
      template: 'drinks_edit'
      layoutTemplate: 'layout'
      data: ->
        @.params.id
      onBeforeAction: ->
        Session.set('id', @.params.id)
    @.route 'orders',
      path: '/orders'
      template: 'orders_index'
      layoutTemplate: 'layout'
    @.route 'orders_new',
      path: '/orders/new'
      template: 'orders_new'
      layoutTemplate: 'layout'
    @.route 'orders_edit',
      path: '/orders/:id/edit'
      template: 'orders_edit'
      layoutTemplate: 'layout'
      data: ->
        @.params.id
      onBeforeAction: ->
        Session.set('id', @.params.id)
  # go to /_routes to view routes
  Router.configure
    routesUri: '_routes'

# create links on the layout to access the various index pages 
Template.layout.events
  'click #logo': -> Router.go('home')
  'click #foods': -> Router.go('foods')
  'click #drinks': -> Router.go('drinks')
  'click #orders': -> Router.go('orders')