var exec = require('cordova/exec');

function BluetoothPrinter() {};

BluetoothPrinter.prototype.setPrinterPageWidth = function(success, fail, width) {
    exec(success, fail, 'BluetoothPrinter', 'setPrinterPageWidth', [width]);
}

BluetoothPrinter.prototype.setFirstRankMaxLength = function(success, fail, text3, text4) {
    exec(success, fail, 'BluetoothPrinter', 'setFirstRankMaxLength', [text3, text4])
}

BluetoothPrinter.prototype.getCurrentSetPageWidth = function(success, fail) {
    exec(success, fail, 'BluetoothPrinter', 'getCurrentSetPageWidth');
}

BluetoothPrinter.prototype.autoConnectPeripheral = function(success, fail) {
    exec(success, fail, 'BluetoothPrinter', 'autoConnectPeripheral', []);
}

BluetoothPrinter.prototype.isConnectPeripheral = function(success, fail) {
    exec(success, fail, 'BluetoothPrinter', 'isConnectPeripheral', []);
}


BluetoothPrinter.prototype.scanForPeripherals = function(success, fail, keep) {
    exec(success, fail, 'BluetoothPrinter', 'scanForPeripherals', [keep]);
}

BluetoothPrinter.prototype.stopScan = function(success, fail) {
    exec(success, fail, 'BluetoothPrinter', 'stopScan', [])
}

BluetoothPrinter.prototype.getDeviceList = function(success, fail) {
    exec(success, fail, 'BluetoothPrinter', 'getPeripherals', []);
}

BluetoothPrinter.prototype.connectPeripheral = function(success, fail, uuid) {
    exec(success, fail, 'BluetoothPrinter', 'connectPeripheral', [uuid]);
}

BluetoothPrinter.prototype.setPrinterInfoAndPrinter = function(success, fail, jsonString) {
    exec(success, fail, 'BluetoothPrinter', 'setPrinterInfoAndPrinter', [jsonString]);
}

BluetoothPrinter.prototype.stopConnection = function(success, fail) {
    exec(success, fail, 'BluetoothPrinter', 'stopPeripheralConnection', []);
}

BluetoothPrinter.prototype.printOCLog = function(success, fail, message) {
    exec(success, fail, 'BluetoothPrinter', 'printLog', [message]);
}

if (typeof BTPInfoType == "undefined") {
    var BTPInfoType = {};
    BTPInfoType.text = 0;
    BTPInfoType.textList = 1;
    BTPInfoType.barCode = 2;
    BTPInfoType.qrCode = 3;
    BTPInfoType.image = 4;
    BTPInfoType.seperatorLine = 5;
    BTPInfoType.spaceLine = 6;
    BTPInfoType.footer = 7;
    BTPInfoType.cutpage = 8;
}

if (typeof BTPFontType == "undefined") {
    var BTPFontType = {};
    BTPFontType.smalle = 0;
    BTPFontType.middle = 1;
    BTPFontType.big = 2;
    BTPFontType.big3 = 3;
    BTPFontType.big4 = 4;
    BTPFontType.big5 = 5;
    BTPFontType.big6 = 6;
    BTPFontType.big7 = 7;
    BTPFontType.big8 = 8;
}

if (typeof BTPAlignmentType == "undefined") {
    var BTPAlignmentType = {};
    BTPAlignmentType.left = 0;
    BTPAlignmentType.center = 1;
    BTPAlignmentType.right = 2;
}

var _printerInfos = [];

function PrinterInfoHelper() {};

PrinterInfoHelper.prototype.resetInfos = function() {
    _printerInfos = [];
}

PrinterInfoHelper.prototype.appendText = function(text, alignment, fontType) {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.text;
    infoModel.text = text;
    infoModel.fontType = fontType;
    infoModel.aligmentType = alignment;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendTextList = function(textList, isTitle, fontType) {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.textList;
    infoModel.textArray = textList;
    infoModel.isTitle = isTitle;
    if (fontType !== undefined) {
        infoModel.fontType = fontType;
    }

    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendBarCode = function(text, maxWidth, alignment) {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.barCode;
    infoModel.text = text;
    infoModel.aligmentType = alignment;
    infoModel.maxWidth = maxWidth;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendQrCode = function(text, size, alignment) {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.qrCode;
    infoModel.text = text;
    infoModel.aligmentType = alignment;
    infoModel.qrCodeSize = size;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendImage = function(text, maxWidth, alignment) {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.image;
    infoModel.text = text;
    infoModel.aligmentType = alignment;
    infoModel.maxWidth = maxWidth;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendSeperatorLine = function() {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.seperatorLine;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendSpaceLine = function() {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.spaceLine;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendCutpage = function() {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.cutpage;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.appendFooter = function(text) {
    var infoModel = new Object();
    infoModel.infoType = BTPInfoType.footer;
    infoModel.text = text;
    _printerInfos.push(infoModel);
}

PrinterInfoHelper.prototype.getPrinterInfoJsonString = function() {
    var jsonStr = JSON.stringify(_printerInfos);
    _printerInfos = [];
    return jsonStr;
}

var printerHelper = new BluetoothPrinter();
var printerInfoHelper = new PrinterInfoHelper();

window.printerHelper = printerHelper;
window.printerInfoHelper = printerInfoHelper;
window.BTPInfoType = BTPInfoType;
window.BTPFontType = BTPFontType;
window.BTPAlignmentType = BTPAlignmentType;


module.exports.printerHelper = printerHelper;
module.exports.printerInfoHelper = printerInfoHelper;
module.exports.BTPInfoType = BTPInfoType;
module.exports.BTPFontType = BTPFontType;
module.exports.BTPAlignmentType = BTPAlignmentType;


// module.exports = BluetoothPrinter;