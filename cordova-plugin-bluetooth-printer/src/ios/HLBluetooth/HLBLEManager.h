#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "HLBLEConst.h"

@interface HLBLEManager : NSObject

#pragma mark - properties

@property (copy, nonatomic) HLStateUpdateBlock                      stateUpdateBlock;

@property (copy, nonatomic) HLDiscoverPeripheralBlock               discoverPeripheralBlcok;

@property (copy, nonatomic) HLConnectCompletionBlock                connectCompleteBlock;

@property (copy, nonatomic) HLDiscoveredServicesBlock               discoverServicesBlock;

@property (copy, nonatomic) HLDiscoverCharacteristicsBlock          discoverCharacteristicsBlock;

@property (copy, nonatomic) HLNotifyCharacteristicBlock             notifyCharacteristicBlock;

@property (copy, nonatomic) HLDiscoveredIncludedServicesBlock       discoverdIncludedServicesBlock;

@property (copy, nonatomic) HLDiscoverDescriptorsBlock              discoverDescriptorsBlock;

@property (copy, nonatomic) HLBLECompletionBlock                    completionBlock;

@property (copy, nonatomic) HLValueForCharacteristicBlock           valueForCharacteristicBlock;

@property (copy, nonatomic) HLValueForDescriptorBlock               valueForDescriptorBlock;

@property (copy, nonatomic) HLWriteToCharacteristicBlock            writeToCharacteristicBlock;

@property (copy, nonatomic) HLWriteToDescriptorBlock                writeToDescriptorBlock;

@property (copy, nonatomic) HLGetRSSIBlock                          getRSSIBlock;

@property (strong, nonatomic, readonly) CBPeripheral                *connectedPerpheral;

@property (assign, nonatomic)   NSInteger             limitLength;

#pragma mark - method
+ (instancetype)sharedInstance;

/**
 *
 *  @param uuids        
 *  @param option       
 */
- (void)scanForPeripheralsWithServiceUUIDs:(NSArray<CBUUID *> *)uuids options:(NSDictionary<NSString *, id> *)options;

/**
 *
 *
 *  @param uuids         
 *  @param option        
 *  @param discoverBlock
 */
- (void)scanForPeripheralsWithServiceUUIDs:(NSArray<CBUUID *> *)uuids options:(NSDictionary<NSString *, id> *)options didDiscoverPeripheral:(HLDiscoverPeripheralBlock)discoverBlock;

/**
 *
 *  @param peripheral          
 *  @param connectOptions      
 *  @param stop                
 *  @param serviceUUIDs        
 *  @param characteristicUUIDs 
 *  @param completionBlock     
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
           connectOptions:(NSDictionary<NSString *,id> *)connectOptions
   stopScanAfterConnected:(BOOL)stop
          servicesOptions:(NSArray<CBUUID *> *)serviceUUIDs
   characteristicsOptions:(NSArray<CBUUID *> *)characteristicUUIDs
            completeBlock:(HLBLECompletionBlock)completionBlock;

/**
 *  
 *
 *  @param includedServiceUUIDs 
 *  @param service              
 */
- (void)discoverIncludedServices:(NSArray<CBUUID *> *)includedServiceUUIDs forService:(CBService *)service;

/**
 *  
 *
 *  @param characteristic 
 */
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;

/**
 *  
 *
 *  @param characteristic  
 *  @param completionBlock 
 */
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic completionBlock:(HLValueForCharacteristicBlock)completionBlock;

/**
 *  
 *
 *  @param data           
 *  @param characteristic 
 *  @param type           
 */
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;


/**
 *  
 *
 *  @param data           
 *  @param characteristic 
 *  @param type           
 *  @param completionBlock 
 */
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type completionBlock:(HLWriteToCharacteristicBlock)completionBlock;

/**
 *  
 *
 *  @param descriptor 
 */
- (void)readValueForDescriptor:(CBDescriptor *)descriptor;

/**
 *  
 *
 *  @param descriptor      
 *  @param completionBlock 
 */
- (void)readValueForDescriptor:(CBDescriptor *)descriptor completionBlock:(HLValueForDescriptorBlock)completionBlock;

/**
 *  
 *
 *  @param data       
 *  @param descriptor 
 */
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor;

/**
 *  
 *
 *  @param data       
 *  @param descriptor 
 *  @param completionBlock 
 */
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor completionBlock:(HLWriteToDescriptorBlock)completionBlock;

/**
 *  
 *
 *  @param completionBlock 
 */
- (void)readRSSICompletionBlock:(HLGetRSSIBlock)getRSSIBlock;

/**
 *  
 */
- (void)stopScan;

/**
 *  
 */
- (void)cancelPeripheralConnection;


@end
