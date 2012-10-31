# events
# note: e is event and t is template
# find is Template find
Template.orders_index.events
  'click .edit': -> Router.orders_edit_path(@)
  'click .delete': -> Orders.remove({_id: @._id})
  'click #new': -> Router.navigate('orders/new', {trigger: true})
        
Template.orders_edit.events
  'change #barista': (e, t) -> 
    barista = t.find('#barista option:selected').value
    Orders.update({_id: Session.get('id')}, {$set: {barista: barista}})
  'change #status': ->
    status = $('#status option:selected').val()
    Orders.update({_id: Session.get('id')}, {$set: {status: status}})
  'click #add': -> Meteor.call 'products_insert', Session.get('id')
  'click #back': -> window.Back('orders')

# formatters
Template.order.subtotal = -> accounting.formatMoney(@.subtotal)
Template.order.total = -> accounting.formatMoney(@.total)

# lists
Template.orders_index.orders = -> Orders.find()

# selects
Template.orders_main.baristas = -> 
  bar = Baristas.findOne({key: 1})
  data = bar and bar.data
  if !data
  else
    options = []
    for x in data
      options.push({name: x})
    return options
Template.orders_main.statuses = -> 
  stat = Statuses.findOne({key: 1})
  data = stat and stat.data
  if !data
  else
    options = []
    for x in data
      options.push({name: x})
    return options
Template.orders_edit.products = -> Products.find({order_id: Session.get('id')})

# on re-render - use Mini-Mongo with short-circuting to re-paint both selects in-sync
# using a server method with a callback - re-paints out of sync
Template.orders_main.rendered = -> 
  order = Orders.findOne({_id: Session.get('id')})
  barista = order and order.barista
  status = order and order.status
  if !barista and !status
  else
    $("#barista option[value='" + barista + "']").attr('selected', 'selected')
    $("#status option[value='" + status + "']").attr('selected', 'selected')

Template.orders_new.rendered = -> 
  ko.validation.configure
      registerExtenders: true
      messagesOnModified: true
      insertMessages: true
      parseInputAttributes: true
      messageTemplate: null

  Meteor.call 'baristas', (err, data) ->
    model =  
      barista: ko.observable().extend({required: true})
      baristas: ko.observableArray(data.data)
      back: -> window.Back('orders')
      submit: ->
        if model.errors().length is 0
          Meteor.call 'orders_insert', ko.toJS(@), (err, data) ->
            Router.navigate("orders/#{data}/edit", {trigger: true})
        else
          model.errors.showAllMessages()

    model.errors = ko.validation.group(model)
    ko.applyBindings(model)

# dynamic values
Template.orders_edit.totaled = ->
  order = Orders.findOne({_id: Session.get('id')})
  total = order and order.total
  if total > 0 then return true else return false
Template.orders_total.subtotal = -> 
  order = Orders.findOne({_id: Session.get('id')})
  subtotal = order and order.subtotal
  accounting.formatMoney(subtotal)
Template.orders_total.hst = -> 
  order = Orders.findOne({_id: Session.get('id')})
  hst = order and order.hst
  accounting.formatMoney(hst)
Template.orders_total.total = -> 
  order = Orders.findOne({_id: Session.get('id')})
  total = order and order.total
  accounting.formatMoney(total)

