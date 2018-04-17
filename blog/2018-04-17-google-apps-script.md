# String.prototype.includes

## Google Apps Script

This script doesn't has `String.prototype.includes`.
There are compatibility issues.

### Resolve

https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/String/includes

It uses compatibility of this page.

```js
if (!String.prototype.includes) {
  String.prototype.includes = function(search, start) {
    'use strict';
    if (typeof start !== 'number') {
      start = 0;
    }

    if (start + search.length > this.length) {
      return false;
    } else {
      return this.indexOf(search, start) !== -1;
    }
  };
}
```
