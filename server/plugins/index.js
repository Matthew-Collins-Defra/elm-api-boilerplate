module.exports = {
  development: [
    require('blipp'),
    require('./logging')
  ],
  universal: [
    require('./error-pages'),
    require('./graceful-stop'),
    require('./router')
  ]
}
