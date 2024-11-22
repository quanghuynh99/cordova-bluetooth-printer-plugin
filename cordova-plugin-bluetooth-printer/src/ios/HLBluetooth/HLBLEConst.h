#ifndef HLBLEConst_h
#define HLBLEConst_h

typedef NS_ENUM(NSInteger, HLOptionStage) {
    HLOptionStageConnection,            
    HLOptionStageSeekServices,         
    HLOptionStageSeekCharacteristics,   
    HLOptionStageSeekdescriptors,     
};

#pragma mark ------------------- 通知的定义 --------------------------

#define kCentralManagerStateUpdateNoticiation @"kCentralManagerStateUpdateNoticiation"

#pragma mark ------------------- block的定义 --------------------------

typedef void(^HLStateUpdateBlock)(CBCentralManager *central);


typedef void(^HLDiscoverPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);


typedef void(^HLConnectCompletionBlock)(CBPeripheral *peripheral, NSError *error);


typedef void(^HLDiscoveredServicesBlock)(CBPeripheral *peripheral, NSArray *services, NSError *error);


typedef void(^HLDiscoveredIncludedServicesBlock)(CBPeripheral *peripheral,CBService *service, NSArray *includedServices, NSError *error);


typedef void(^HLDiscoverCharacteristicsBlock)(CBPeripheral *peripheral, CBService *service, NSArray *characteristics, NSError *error);


typedef void(^HLNotifyCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);


typedef void(^HLDiscoverDescriptorsBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSArray *descriptors, NSError *error);


typedef void(^HLBLECompletionBlock)(HLOptionStage stage, CBPeripheral *peripheral,CBService *service, CBCharacteristic *character, NSError *error);


typedef void(^HLValueForCharacteristicBlock)(CBCharacteristic *characteristic, NSData *value, NSError *error);


typedef void(^HLValueForDescriptorBlock)(CBDescriptor *descriptor,NSData *data,NSError *error);


typedef void(^HLWriteToCharacteristicBlock)(CBCharacteristic *characteristic, NSError *error);


typedef void(^HLWriteToDescriptorBlock)(CBDescriptor *descriptor, NSError *error);


typedef void(^HLGetRSSIBlock)(CBPeripheral *peripheral,NSNumber *RSSI, NSError *error);

#endif
