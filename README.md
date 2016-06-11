# fake-local-storage

Use this implementation if your project relies on localStorage, but you don't want to persist any data.

## Motivation for creating this module

I was using Backbone.localStorage for a cordova app.

Because localStorage can be unreliable, I decided to save a backup to a file on each write, and to load the data from the file into localStorage on each application start.

I later figured out that cordova's localStorage might be synced to google/iCloud, but I wanted to control what to sync.

The most convenient way I could come up with for solving the above problem, was to create a fake local storage implementation.

## How to Use:

### Installation:

```
npm install fake-local-storage
```


### CommonJs (browserify / webpack):

```
require('fake-local-storage')()
```

### Basic javascript (download from `dist/fake-local-storage.js`):

```
<!-- Import script -->
<script type="text/javascript" src="[YOUR-JS-FILE-LOCATION]/fake-local-storage.js"></script>

<!-- Overwrite native localStorage -->
<script type="text/javascript">
  window.fakeLocalStorage()
</script>
```

## Known limitations

This module is primarily made for solving one specific problem (see motivation section), thus it is currently only implementing the functionality needed for solving that problem.

**All basic functionality is implemented EXCEPT EVENTS**

Events might be implemented in a later version - pull requests are welcome!
