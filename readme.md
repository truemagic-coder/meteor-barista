# Barista - CoffeeShop Ordering System 
## How to use:
  1. npm install meteorite (if not already installed)
  2. git clone https://github.com/bevanhunt/meteor-barista.git
  3. cd meteor-barista
  4. mrt
  5. open browser to http://localhost:3000
  6. add foods and drinks then add orders

## Why:
  Meteor.js vs. Batman-Rails using a LOB app

## Notes: 
  Meteor.js version is real-time 
  
  When you update foods or drinks - the updated versions will only be available to products that have not been added to an order yet

## Demo:
  http://barista.meteor.com

## Batman-Barista:
  https://github.com/bevanhunt/batman-barista

## ToDo:
  * Meteor: Create form validations

## Comparsion:
  Batman-Rails:
    
    Pros:
      * Full MVC REST support built-in
      * HTML data-bindings
      * Validations built-in
      * HTML templating language - HAML (optional)
      * Model relationship keywords (rather than having to set MongoDB keys manually)

    Cons: 
      * Bad documentation 
      * 3 specified model schemas (duplication) = ActiveModel, JSON Serializer, and Batman Models
      * Real-time is not built-in (no real-time in Batman-Barita)
      * Manually refreshing browser is required to see app changes
  
  Meteor.js:
  
    Pros:
      * The same schemaless model on both server and client = no duplication 
      * Real-time built-in 
      * Auto-refreshes browser on app changes 
      * Decent documentation
  
    Cons:
      * Validations are not built-in
      * Client-side REST requires manually writing Backbone routes - requires a 3rd party library (Reactive Router)
      * No HTML templating language - should support Jade 
      * Has no concept of form value preservation for non-focused inputs
      * Re-renders the entire template - should support HTML data-bindings