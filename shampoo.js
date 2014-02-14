// This is just a shortcut to run "./lib/shampoo.coffee".
// It's in here for use during development.
// This is because "shampoo" isn't registered to run on the command line until
// we do an `npm install` which means we can't test the command line code
// interactively during development (i.e. we have to `npm install` every time
// we make a change)
require('coffee-script/register');
require('./lib/shampoo');