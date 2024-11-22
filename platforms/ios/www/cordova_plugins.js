cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "cordova-plugin-bluetooth-printer.BluetoothPrinter",
      "file": "plugins/cordova-plugin-bluetooth-printer/www/BluetoothPrinter.js",
      "pluginId": "cordova-plugin-bluetooth-printer",
      "clobbers": [
        "cordova.plugins.BluetoothPrinter"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-bluetooth-printer": "1.0.0"
  };
});