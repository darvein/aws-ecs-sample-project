var express = require('express');
var app = express();
var uuid = require('node-uuid');

const { Client } = require('pg')
const connectionString = process.env.DB

const client = new Client({ connectionString: connectionString })
client.connect()

console.log('client connected');

// Routes
app.get('/api/status', async (req, res) => {

  console.log('[API] Hello Cloud La Paz!');

  const result = await client.query('SELECT now() as time', [])
  console.log('[API]' + result.rows[0].time);

  res.send({
    request_uuid: uuid.v4(),
    time: result.rows[0].time
  });
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.json({
    message: err.message,
    error: {}
  });
});


//client.end()
module.exports = app;
