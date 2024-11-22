#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BitPixels) {
    BPAlpha = 0,
    BPBlue = 1,
    BPGreen = 2,
    BPRed = 3
};

@interface UIImage (Bitmap)

/**
 *  @return 
 */
- (NSData *)bitmapData;

/**
 *
 *  @return
 */
- (CGContextRef)bitmapRGBA8Context;

/**
 *  @param maxWidth 
 *
 *  @return 
 */
- (UIImage *)imageWithscaleMaxWidth:(CGFloat)maxWidth;

/**
 *  @return 
 */
- (UIImage *)blackAndWhiteImage;

/** image base64  */
- (NSString *)mk_imageToBase64;
+ (UIImage *)mk_imageWithBase64:(NSString *)string;

@end

#pragma mark - -----------制作二维码 条形码------------
@interface UIImage (QRCode)

/**
 *  @param info 
 *
 *  @return 
 */
+ (UIImage *)barCodeImageWithInfo:(NSString *)info;

/**
 *
 *  @param info  
 *  @param image 
 *  @param width 
 *
 *  @return 
 */
+ (UIImage *)qrCodeImageWithInfo:(NSString *)info centerImage:(UIImage *)image  width:(CGFloat)width;

/**
 *
 *  @param image 
 *  @param size  
 *
 *  @return UIImage
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

/**
 
 *  @param image 
 *  @param red   red
 *  @param green green
 *  @param blue  blue
 *
 *  @return 
 */
+ (UIImage*)imageBgColorToTransparentWith:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
