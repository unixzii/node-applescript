const assert = require('assert');
const fs = require('fs');
const applescript2 = require('.');

describe('calling without parameters', function () {
  it('should throw an error', function () {
    assert.throws(function () {
      applescript2();
    });
  });
});

describe('calling without callback', function () {
  it('should return a Promise', function (done) {
    function _done() {
      done();
    }

    const promise = applescript2('1 + 1');
    assert.equal(Object.prototype.toString.call(promise), '[object Promise]');
    promise.then(_done).catch(_done);
  });
});

describe('calling with callback', function () {
  it('should return results in callback', function (done) {
    applescript2('1 + 1', function (err, res) {
      assert.equal(err, null);
      assert.equal(res, '2');
      done();
    });
  });
});

describe('calling with script contains errors', function () {
  it('should return errors in callback', function (done) {
    applescript2('something', function (err, res) {
      assert.notEqual(err, null);
      assert.equal(res.errorMessage, 'The variable something is not defined.');
      done();
    });
  });
});

describe('calling with a buffer type script', function () {
  this.timeout(5000);

  it('should return correct results in callback', function (done) {
    const buf = fs.readFileSync('fixtures/example.applescript');
    applescript2(buf, function (err, res) {
      assert.notEqual(err, null);
      assert.equal(res.errorMessage, 'No user interaction allowed.');
      done();
    });
  });
});