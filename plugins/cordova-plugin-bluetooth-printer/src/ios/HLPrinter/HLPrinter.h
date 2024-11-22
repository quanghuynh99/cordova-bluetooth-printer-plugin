//
//  HLPrinter.h
//  HLBluetoothDemo
//
//  Created by Harvey on 16/5/3.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIImage+Bitmap.h"

typedef NS_ENUM(NSInteger, HLPrinterStyle) {
    HLPrinterStyleDefault,
    HLPrinterStyleCustom
};

typedef NS_ENUM(NSInteger, HLTextAlignment) {
    HLTextAlignmentLeft = 0x00,
    HLTextAlignmentCenter = 0x01,
    HLTextAlignmentRight = 0x02
};

typedef NS_ENUM(NSInteger, HLFontSize) {
    HLFontSizeTitleSmalle = 0x00,
    HLFontSizeTitleMiddle = 0x11,
    HLFontSizeTitleBig = 0x22,
    HLFontSizeTitleBig3 = 0x10,
    HLFontSizeTitleBig4 = 0x12,
    HLFontSizeTitleBig5 = 0x21,
    HLFontSizeTitleBig6 = 0x22,
    HLFontSizeTitleBig7 = 0x33,
    HLFontSizeTitleBig8 = 0x44
};

@interface HLPrinter : NSObject
@property (nonatomic, assign) NSInteger maxLength3Text;
@property (nonatomic, assign) NSInteger maxLength4Text;
@property (nonatomic, assign) NSInteger pageWidth;      

+ (instancetype)sharedInstance;
- (void)defaultSetting;

/**
 *  
 *
 *  @param title     
 *  @param alignment 
 */
- (void)appendText:(NSString *)text alignment:(HLTextAlignment)alignment;

/**
 *  
 *
 *  @param title     
 *  @param alignment 
 *  @param fontSize  
 */
- (void)appendText:(NSString *)text alignment:(HLTextAlignment)alignment fontSize:(HLFontSize)fontSize;

/**
 *  
 *  @param title    
 *  @param value    
 */
- (void)appendTitle:(NSString *)title value:(NSString *)value;

/**
 *  @param title    
 *  @param value    
 *  @param fontSize 
 */
- (void)appendTitle:(NSString *)title value:(NSString *)value fontSize:(HLFontSize)fontSize;

/**
 *
 *  @param title    
 *  @param value    
 *  @param offset   
 */
- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset;

/**
 *
 *  @param title    
 *  @param value    
 *  @param offset   
 *  @param fontSize 
 */
- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset fontSize:(HLFontSize)fontSize;
- (void)appendTextArray:(NSArray *)texts isTitle:(BOOL)isTitle;

/**
 *
 *  @param LeftText   
 *  @param middleText 
 *  @param rightText  
 */
- (void)appendLeftText:(NSString *)left middleText:(NSString *)middle rightText:(NSString *)right isTitle:(BOOL)isTitle;

/**
 *
 *  @param image     
 *  @param alignment 
 *  @param maxWidth  
 */
- (void)appendImage:(UIImage *)image alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth;

/**
 *
 *  @param info 
 */
- (void)appendBarCodeWithInfo:(NSString *)info;

/**
 *
 *  @param info      
 *  @param alignment 
 *  @param maxWidth  
 */
- (void)appendBarCodeWithInfo:(NSString *)info alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth;

/**
 *
 *  @param info 
 *  @param size
 */
- (void)appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size;

/**
 *  
 *
 *  @param info      
 *  @param size      
 *  @param alignment
 */
- (void)appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(HLTextAlignment)alignment;

/**
 *
 *  @param info 
 */
- (void)appendQRCodeWithInfo:(NSString *)info;

/**
 *
 *  @param info        
 *  @param centerImage 
 *  @param alignment   
 *  @param maxWidth    
 */
- (void)appendQRCodeWithInfo:(NSString *)info centerImage:(UIImage *)centerImage alignment:(HLTextAlignment)alignment maxWidth:(CGFloat )maxWidth;

/**
 */
- (void)appendSeperatorLine;
- (void)appendSpaceLine;
- (void)appendNewLine;
/**
 *  
 *
 *  @param footerInfo
 */
- (void)appendFooter:(NSString *)footerInfo;

/**
 * 
 */
- (void)appendCutPaper;

/**
 

 @param data 
 */
- (void)appendCustomData:(NSData *)data;

/**
 *  
 *
 *  @return 
 */
- (NSData *)getFinalData;



@end


@interface MKPageWidthConfig : NSObject
@property (nonatomic, copy) NSString *lineStr;
@property (nonatomic, copy) NSArray *offsetAryfor3Text;
@property (nonatomic, copy) NSArray *offsetAryfor4Text;
@property (nonatomic, assign) int virtualWidth;
- (void)setupConfigWith:(NSInteger)width;
@end
