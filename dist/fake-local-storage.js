(function() {
  var error, fakeLocalStorage;

  fakeLocalStorage = function() {
    var clear, data, getItem, localStorage, removeItem, setItem;
    window.originalLocalStorage = window.localStorage;
    data = {};
    getItem = function(prop) {
      if (data[prop] !== void 0) {
        return data[prop];
      } else {
        return null;
      }
    };
    setItem = function(prop, value) {
      if (arguments.length === 1) {
        throw new Error('Uncaught TypeError: Failed to execute \'setItem\' on \'Storage\': 2 arguments required, but only 1 present.');
      }
      switch (value) {
        case void 0:
          value = 'undefined';
          break;
        case null:
          value = 'null';
          break;
        default:
          value = value.toString();
      }
      if (data[prop] === value) {
        return;
      }
      data[prop] = value;
    };
    removeItem = function(prop) {
      if (data[prop]) {
        return delete data[prop];
      }
    };
    clear = function() {
      var name;
      for (name in data) {
        delete data[name];
      }
    };
    localStorage = new Proxy(data, {
      set: function(obj, prop, value) {
        switch (prop) {
          case 'length':
          case 'getItem':
          case 'setItem':
          case 'removeItem':
            break;
          default:
            return setItem(prop, value);
        }
      },
      get: function(obj, prop) {
        var v;
        switch (prop) {
          case 'length':
            return Object.keys(data).length;
          case 'getItem':
            return getItem;
          case 'setItem':
            return setItem;
          case 'removeItem':
            return removeItem;
          case 'clear':
            return clear;
          default:
            v = getItem(prop);
            if (v !== null) {
              return v;
            } else {
              return void 0;
            }
        }
      }
    });
    return Object.defineProperty(window, 'localStorage', {
      get: function() {
        return localStorage;
      },
      set: function() {
        throw new Error('Using file-local-storage plugin - don\'t try to override');
      }
    });
  };

  try {
    module.exports = fakeLocalStorage;
  } catch (error) {
    window.fakeLocalStorage = fakeLocalStorage;
  }

}).call(this);
