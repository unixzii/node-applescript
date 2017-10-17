# applescript2

> Run AppleScript through Node.js

## Why **"2"**?

Well, there is indeed an existing package named [`applescript`](https://www.npmjs.com/package/applescript) can do almost the same thing. But these packages are just wrappers around a command called `osascript`, which can only do very limited works.

`applescript2` is built on a native module that can directly talk to system via `Foundation` framework. This package can pass user's scripts to that module and fetch the result or errors back. By this way, performance is enhanced and operations can be more flexible (this package is pretty new, and more functionality is to be developed, such as transforming results to JavaScript objects).

## Install

```shell
$ npm install --save applescript2
```

## Usage

```javascript
const applescript2 = require('applescript2');

const script = '1 + 1';  // this can also be a buffer.
applescript2(script, function (err, res) {
  // do something...
});

// You can also get a Promise by leaving the callback parameter null.
applescript2(script).then(res => {
  // ...
});
```

**Caution:** Due to the restriction of macOS, there can only be **one** AppleScript that is running, that situation may be difficult to control sometimes (ex. a user is executing an AppleScript himself via user interfaces), so please always notice the error parameter and handle that exception properly.

## License

MIT © [Cyandev](https://unixzii.github.io)