(function() {
  var app, express, messages;
  express = require("express");
  messages = require("express-messages");
  app = module.exports = express.createServer();
  app.set("views", __dirname + "/views");
  app.set("view engine", "jade");
  app.mounted(function(other) {
    return console.log("ive been mounted!");
  });
  app.dynamicHelpers({
    messages: messages,
    base: function() {
      if ("/" === app.route) {
        return "";
      } else {
        return app.route;
      }
    }
  });
  app.configure(function() {
    app.use(express.logger("\u001b[33m:method\u001b[0m \u001b[32m:url\u001b[0m :response-time"));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: "keyboard cat"
    }));
    app.use(app.router);
    app.use(express.static(__dirname + "/public"));
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  require("./routes/site")(app);
  require("./routes/post")(app);
  if (!module.parent) {
    app.listen(3000);
    console.log("Express started on port 3000");
  }
}).call(this);
