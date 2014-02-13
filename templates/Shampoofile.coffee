module.exports =
  
  # The "default" is run when you run "shampoo" without any arguments
  default:
    options: {}
    files:
      "./build.js": "./source.js"

  # Run when you call "shampoo custom". Make as many custom builds as you want.
  custom:
    options: {}
    files:
      "./build.js": "./source.js"