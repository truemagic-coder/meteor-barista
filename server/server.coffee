# create pubs 
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
# products
Products = new Meteor.Collection('products')
Meteor.publish 'products', -> Products.find()
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
  'order_main': ->
    return {baristas: Baristas.findOne({key: 1}), statuses: Statuses.findOne({key: 1})}
  'food': (id) -> Foods.findOne({_id: id})
  'baristas': -> Baristas.findOne({key: 1})
  'sizes': -> Sizes.findOne({key: 1})
  'drink': (id) -> 
    return {sizes: Sizes.findOne(key: 1), drink: Drinks.findOne({_id: id})}
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
  'orders_insert': (js) -> 
    # increment by 1 on insert (auto-increment)
    number = OrderNumber.findOne({num: 1}).number
    OrderNumber.update({num: 1}, {$inc: {number: 1}})
    status = "Waiting"
    barista = js.barista
    Orders.insert({number: number, barista: barista, status: status})
  'products_insert': (order_id) -> Products.insert({order_id: order_id, type: "Drink"})

# on startup - create collections with default values
Meteor.startup ->
  # create auto-increment collection for orders
  if OrderNumber.find().count() is 0
    OrderNumber.insert({num: 1, number: 1})
  if Modifications.find().count() is 0
    # use underscores rather than spaces 
    # Handlebars breaks the value at the space when inserting into an option
    mods = [
      {name: "Shot_of_Expresso", type: "Drink"}
      {name: "Grill", type: "Food"}
      {name: "Heat", type: "Food"}
      {name: "Low_Fat", type: "Drink"}
      {name: "Soy_Milk", type: "Drink"}
      {name: "Add_Cheese", type: "Food"}
      {name: "Add_Bacon", type: "Food"}
      {name: "Extra_Cream", type: "Drink"}
    ]
    for mod in mods
      Modifications.insert
        name: mod.name
        type: mod.type
  if Types.find().count() is 0
    types = ["Drink", "Food"]
    Types.insert(types)
  if Sizes.find().count() is 0
    sizes = ["Small", "Medium", "Large"]
    Sizes.insert(key: 1, data: sizes)
  if Baristas.find().count() is 0
    baristas = ["Kim", "Heather", "Janice", "Paul"]
    Baristas.insert(key: 1, data: baristas)
  if Statuses.find().count() is 0
    statuses = ["Waiting", "Making", "Done"]
    Statuses.insert(key: 1, data: statuses)