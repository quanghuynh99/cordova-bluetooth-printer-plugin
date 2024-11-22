#import <Cordova/CDVPlugin.h>
#import "BluetoothPrinter.h"

typedef void(^CommandBlcok)(BOOL success, NSString *message);

@interface BluetoothPrinter : CDVPlugin

- (void)setPrinterPageWidth:(CDVInvokedUrlCommand *)command;

- (void)getCurrentSetPageWidth:(CDVInvokedUrlCommand *)command;

- (void)autoConnectPeripheral:(CDVInvokedUrlCommand *)command;

- (void)isConnectPeripheral:(CDVInvokedUrlCommand *)command;

- (void)scanForPeripherals:(CDVInvokedUrlCommand *)command;

- (void)stopScan:(CDVInvokedUrlCommand *)command;

- (void)getPeripherals:(CDVInvokedUrlCommand *)command;

- (void)connectPeripheral:(CDVInvokedUrlCommand *)command;

- (void)setPrinterInfoAndPrinter:(CDVInvokedUrlCommand *)command;

- (void)stopPeripheralConnection:(CDVInvokedUrlCommand *)command;

- (void)printLog:(CDVInvokedUrlCommand *)command;

@end








