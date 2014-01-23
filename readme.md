# Barista - CoffeeShop Ordering System 
## How to use:
  1. npm install -g meteorite (if not already installed)
  2. git clone https://github.com/bevanhunt/meteor-barista.git
  3. cd meteor-barista
  4. mrt
  5. open browser to http://localhost:3000
  6. add foods and drinks then add orders

## Why:
  Meteor.js vs. Batman-Rails using a LOB app 

## Notes: 
  * Meteor.js version is real-time 
  * When you update foods or drinks - the updated versions will only be available to products that have not been added to an order yet

## Demo:
  http://barista.meteor.com 

## Batman-Barista:
  https://github.com/bevanhunt/batman-barista

## Comparsion:
  Batman-Rails:
    
    Pros:
      * Model relationship keywords (rather than having to set MongoDB keys manually)

    Cons: 
      * 3 specified model schemas (duplication) = ActiveModel, JSON Serializer, and Batman Models
      * Real-time is not built-in (no real-time in Batman-Barita)
      * Manually refreshing browser is required to see app changes
  
  Meteor.js:
  
    Pros:
      * The same schemaless model on both server and client = no duplication 
      * Real-time built-in 
      * Auto-refreshes browser on app changes 
      * Decent documentation