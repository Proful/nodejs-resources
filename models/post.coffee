ids = 0
db = {}
Post = exports = module.exports = Post = (title, body) ->
  @id = ++ids
  @title = title
  @body = body
  @createdAt = new Date

Post.prototype.save = (fn) ->
  db[@id] = this
  fn()

Post.prototype.validate = (fn) ->
  if not @title
    return fn(new Error("_title_ required"))
  if not @body
    return fn(new Error("_body_ required"))
  if @body.length < 10
    return fn(new Error("_body_ should be at least **10** characters long, was only _" + @title.length + "_"))
  fn()

Post.prototype.update = (data, fn) ->
  @updatedAt = new Date
  for key of data
    if undefined != data[key]
      this[key] = data[key]
  @save fn

Post.prototype.destroy = (fn) ->
  exports.destroy @id, fn

exports.count = (fn) ->
  fn null, Object.keys(db).length

exports.all = (fn) ->
  arr = Object.keys(db).reduce((arr, id) ->
    arr.push db[id]
    arr
  , [  ])
  fn null, arr

exports.get = (id, fn) ->
  fn null, db[id]

exports.destroy = (id, fn) ->
  if db[id]
    delete db[id]
    
    fn()
  else
    fn new Error("post " + id + " does not exist")