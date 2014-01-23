# create pubs 
# create ok for allow
ok = -> true
# foods
Foods = new Meteor.Collection('foods')
Meteor.publish 'foods', -> Foods.find()
# drinks
Drinks = new Meteor.Collection('drinks')
Meteor.publish 'drinks', -> Drinks.find()
# types
Types = new Meteor.Collection('types')
Meteor.publish 'types', -> Types.find()
# sizes
Sizes = new Meteor.Collection('sizes')
Meteor.publish 'sizes', -> Sizes.find()
# orders
Orders = new Meteor.Collection('orders')
Meteor.publish 'orders', -> Orders.find()
Orders.allow
  update: ok
# products
Products = new Meteor.Collection('products')
Meteor.publish 'products', -> Products.find()
Products.allow
  update: ok
# baristas
Baristas = new Meteor.Collection('baristas')
Meteor.publish 'baristas', -> Baristas.find()
# order number
OrderNumber = new Meteor.Collection('order_number')
# status
Statuses = new Meteor.Collection('statuses')
Meteor.publish 'statuses', -> Statuses.find()
# modifications
Modifications = new Meteor.Collection('modifications')
Meteor.publish 'modifications', -> Modifications.find()
# mods
Mods = new Meteor.Collection('mods')
Meteor.publish 'mods', -> Mods.find()

# create server methods - this allows callbacks on the client - useful for navigation
Meteor.methods
  'foods_remove': (id) ->
    Foods.remove({_id: id})
  'foods_insert': (js) -> 
    # save as a number - otherwise it will default to string 
    price = parseFloat(js.price)
    pgram = parseFloat(js.pgram)
    # use sugarjs to capitalize 
    name = js.name.capitalize()
    Foods.insert({name: name, pgram: pgram, price: price})
  'foods_update': (id, js) -> 
    # save as a number - otherwise it will default to string 
    price = parseFloat(js.price)
    pgram = parseFloat(js.pgram)
    # use sugarjs to capitalize 
    name = js.name.capitalize()
    Foods.update({_id: id}, {$set: {name: name, pgram: pgram, price: price}})
  'drinks_remove': (id) ->
    Drinks.remove({_id: id})
  'drinks_insert': (js) -> 
    # save as a number - otherwise it will default to string 
    price = parseFloat(js.price)
    size = js.size
    # use sugarjs to capitalize 
    name = js.name.capitalize()
    Drinks.insert({name: name, size: size, price: price})
  'drinks_update': (id, js) -> 
    # save as a number - otherwise it will default to string 
    price = parseFloat(js.price)
    size = js.size
    # use sugarjs to capitalize 
    name = js.name.capitalize()
    Drinks.update({_id: id}, {$set: {name: name, size: size, price: price}})
  'orders_remove': (id) ->
    Orders.remove({_id: id})
  'orders_insert': (js) -> 
    # increment by 1 on insert (auto-increment)
    number = OrderNumber.findOne({num: 1}).number
    OrderNumber.update({num: 1}, {$inc: {number: 1}})
    status = "Waiting"
    barista = js.barista
    Orders.insert({number: number, barista: barista, status: status})
  'products_remove': (id) -> Products.remove({_id: id})
  'products_insert': (order_id) -> Products.insert({order_id: order_id, type: "Drink"})
  'barista_update': (id, barista) -> Orders.update({_id: id}, {$set: {barista: barista}})
  'status_update': (id, status) -> Orders.update({_id: id}, {$set: {status: status}})
  'mods_remove': (id) ->  Mods.remove({_id: id})
  'mods_insert': (name, type, id) -> Mods.insert({name: name, type: type, product_id: id})

# on startup - create collections with default values
Meteor.startup ->
  # create auto-increment collection for orders
  if OrderNumber.find().count() is 0
    OrderNumber.insert({num: 1, number: 1})
  if Modifications.find().count() is 0
    mods = [
      {name: "Shot of Expresso", type: "Drink"}
      {name: "Grill", type: "Food"}
      {name: "Heat", type: "Food"}
      {name: "Low Fat", type: "Drink"}
      {name: "Soy Milk", type: "Drink"}
      {name: "Add Cheese", type: "Food"}
      {name: "Add Bacon", type: "Food"}
      {name: "Extra Cream", type: "Drink"}
    ]
    for mod in mods
      Modifications.insert({name: mod.name, type: mod.type})
  if Types.find().count() is 0
    types = ["Drink", "Food"]
    Types.insert({key: 1, data: types})
  if Sizes.find().count() is 0
    sizes = ["Small", "Medium", "Large"]
    for size in sizes
      Sizes.insert({name: size})
  if Baristas.find().count() is 0
    baristas = ["Kim", "Heather", "Janice", "Paul"]
    for barista in baristas
      Baristas.insert({name: barista})
  if Statuses.find().count() is 0
    statuses = ["Waiting", "Making", "Done"]
    Statuses.insert({key: 1, data: statuses})