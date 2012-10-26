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
  'food': (id) -> Foods.findOne({_id: id})
  'drink': (id) -> Drinks.findOne({_id: id})
  'foods_insert': (name, gram, price) -> Foods.insert({name: name, pgram: gram, price: price, grams: 0})
  'foods_update': (id, name, gram, price) -> Foods.update({_id: id}, {name: name, pgram: gram, price: price})
  'drinks_insert': (name, size, price) -> Drinks.insert({name: name, size: size, price: price})
  'drinks_update': (id, name, size, price) -> Drinks.update({_id: id}, {name: name, size: size, price: price})
  'orders_insert': (barista) -> 
    # increment by 1 on insert (auto-increment)
    number = OrderNumber.findOne({num: 1}).number
    OrderNumber.update({num: 1}, {$inc: {number: 1}})
    status = "Waiting"
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
    types = [
      "Drink"
      "Food"
    ]
    for type in types
      Types.insert
        name: type
  if Sizes.find().count() is 0
    sizes = [
      "Small"
      "Medium"
      "Large"
    ]
    for size in sizes
      Sizes.insert
        name: size
  if Baristas.find().count() is 0
    baristas = [ 
      "Kim"
      "Heather"
      "Janice"
      "Paul"
    ]
    for barista in baristas
      Baristas.insert
        name: barista
  if Statuses.find().count() is 0
    statuses = [
      "Waiting"
      "Making"
      "Done"
    ]
    for status in statuses
      Statuses.insert
        name: status