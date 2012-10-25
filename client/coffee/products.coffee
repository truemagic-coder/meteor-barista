Template.product.events
  'change #type': (e, t) ->
    n = t.find('#type')
    val = n.options[n.selectedIndex].value
    if @.type is 'Drink'
      Products.update({_id: @._id}, {$set: {type: val, name: "", size: "", units: 0}})
    if @.type is 'Food'
      Products.update({_id: @._id}, {$set: {type: val, name: "", units: 0}})
  'change #name': (e, t) ->
    n = t.find('#name')
    val = n.options[n.selectedIndex].value
    if @.type is 'Drink'
      Products.update({_id: @._id}, {$set: {name: val, size: "", units: 0}})
    if @.type is 'Food'
      food = Foods.findOne({name: val})
      Products.update({_id: @._id}, {$set: {name: val, price: food.price, pgram: food.pgram, units: 0}})
  'change #size': (e, t) ->
    n = t.find('#size')
    val = n.options[n.selectedIndex].value
    drink = Drinks.findOne({name: @.name, size: val})
    Products.update({_id: @._id}, {$set: {size: val, price: drink.price, units: 0, total: 0}})
  'change #gram': (e, t) ->
    n = t.find('#gram')
    val = n.value
    food = Foods.findOne({name: @.name})
    Products.update({_id: @._id}, {$set: {grams: val, units: 0, total: 0}})
  'change #unit': (e, t) ->
    n = t.find('#unit')
    val = n.value
    if @.type is 'Drink'
      total = @.price * val
    if @.type is 'Food'
      total = (@.price + (@.pgram * @.grams)) * val
    Products.update({_id: @._id}, {$set: {total: total, units: val}})
    # calc total
    products = Products.find({order_id: Session.get('id')})
    subtotal = 0
    products.forEach (x) ->
      subtotal += x.total
    tax = 0.12
    hst = subtotal * tax
    total = subtotal * (1 + tax)
    Orders.update({_id: Session.get('id')}, {$set: {subtotal: subtotal, hst: hst, total: total}})
  'click #destroy': -> 
    Products.remove({_id: @._id})
    # calc total
    products = Products.find({order_id: Session.get('id')})
    subtotal = 0
    products.forEach (x) ->
      subtotal += x.total
    tax = 0.12
    hst = subtotal * tax
    total = subtotal * (1 + tax)
    Orders.update({_id: Session.get('id')}, {$set: {subtotal: subtotal, hst: hst, total: total}})
Template.product_total.events
  'click #add': (e, t) ->
    s = t.find('#mod')
    mod = Modifications.findOne({name: s.value})
    Mods.insert({name: mod.name, type: mod.type, product_id: @._id})
Template.product_mods.events
  'click #mod_destroy': ->
    Mods.remove({_id: @._id})

Template.mod.name_formatted = -> @.name.replace(/_/g, " ")
Template.product_mods.mod = -> @.name.replace(/_/g, " ")
Template.product_total.mods = -> Mods.find({product_id: @._id})
Template.product_total.modifications = -> Modifications.find({type: @.type})
Template.product_total.total = -> accounting.formatMoney(@.total)
Template.product.drink = -> if @.type is 'Drink' then return true else return false
Template.product.food = -> if @.type is 'Food' then return true else return false
Template.product.total = -> if @.total > 0 then return true else return false
Template.product.types = -> Types.find()
Template.product_drink.sizes = -> 
  sizes = []
  items = [{size: ""}]
  Drinks.find({name: @.name}).forEach (x) -> 
    if sizes.length is 0 or !sizes.any(x.size) 
      items.add(x)
      sizes.add(x.size)
  return items
Template.product_food.names = ->
  names = []
  items = [{name: ""}]
  Foods.find().forEach (x) -> 
    if names.length is 0 or !names.any(x.name) 
      items.add(x)
      names.add(x.name)
  return items
Template.product_drink.names = -> 
  names = []
  items = [{name: ""}]
  Drinks.find().forEach (x) -> 
    if names.length is 0 or !names.any(x.name) 
      items.add(x)
      names.add(x.name)
  return items
Template.product.rendered = ->
  # preserve input values
  product = Products.findOne({_id: @.data._id})
  # loop through options and match then set the selected index
  if product.type 
    t = @.find('#type')
    count = 0
    for x in t.options
      if x.value is product.type
        t.selectedIndex = count
      count++
    if !product.name
    else
      n = @.find('#name')
      count = 0
      matched = false
      for x in n.options
        if x.value is product.name
          n.selectedIndex = count
          matched = true
        count++
      # if the associated record is deleted - then show the current value
      if count > 0 and !matched
        if n.selectedIndex = -1
          option = document.createElement("option")
          option.text = product.name
          option.value = product.name
          n.add(option, null)
          n.selectedIndex = n.options.length - 1
      if !product.grams
      else
        u = @.find('#gram')
        u.value = product.grams
      if !product.size
      else
        s = @.find('#size')
        count = 0
        matched = false
        for x in s.options
          if x.value is product.size
            s.selectedIndex = count
            matched = true
          count++
        # if the associated record is deleted - then show the current value
        if count > 0 and !matched
          if s.selectedIndex = -1
            option = document.createElement("option")
            option.text = product.size
            option.value = product.size
            s.add(option, null)
            s.selectedIndex = s.options.length - 1
    if product.units > 0
        u = @.find('#unit')
        u.value = product.units  