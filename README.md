# fake-local-storage

A non-persistent localStorage implementation.

Use this implementation if you're in need of a localStorage shim that doesn't implement persistence.

fake-local-storage can also be used for providing localStorage to node.js, so that you can test JavaScript code - that relies on localStorage - without having to run a full-fledged headless browser. It does however require a node.js version that has ES 2015 Proxy support (Node V6.0 or higher)

## How to Use:

### Installation:

Install with npm:

```
npm install fake-local-storage
```

Or download directly from github:

https://raw.githubusercontent.com/jeppester/fake-local-storage/master/dist/fake-local-storage.js

### Usage
 CommonJs (browserify / webpack / node):

```
require('fake-local-storage')()
```

Basic javascript:

```
<!-- Import script -->
<script type="text/javascript" src="[YOUR-JS-FILE-LOCATION]/fake-local-storage.js"></script>

<!-- Overwrite native localStorage -->
<script type="text/javascript">
  window.fakeLocalStorage()
</script>
```

## Known limitations

This module is primarily made for solving one specific problem (see **Why create a fake localStorage implementation?**), thus it is currently only implementing the functionality needed for solving that problem.

**All basic functionality is implemented EXCEPT EVENTS**

Events might be implemented in a later version - pull requests are welcome!

## Why create a fake localStorage implementation?

I was using Backbone.localStorage for a cordova app.

Because localStorage can be unreliable, I decided to save a backup to a file on each write, and to load the data from the file into localStorage on each application start.

I later figured out that cordova's localStorage might be synced to google/iCloud, but I wanted to control what to sync.

The most convenient way I could come up with for solving the above problem, was to create a fake local storage implementation.
