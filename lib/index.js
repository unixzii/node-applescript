const osa = require('bindings')('applescript_2');

module.exports = function (script, cb) {
  if (!script) {
    throw new TypeError('Must specify a script to execute.');
  }
  script = script.toString();

  if (cb && typeof cb === 'function') {
    osa.executeScript(script, cb);
  } else {
    return new Promise(function (resolve, reject) {
      osa.executeScript(script, function (err, res) {
        if (err) {
          reject(err);
        } else {
          resolve(res);
        }
      });
    });
  }
};