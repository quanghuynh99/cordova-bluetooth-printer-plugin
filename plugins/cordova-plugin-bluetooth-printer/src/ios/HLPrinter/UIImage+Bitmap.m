#import "UIImage+Bitmap.h"

#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Bitmap)

/** image base64 转换 */
- (NSString *)mk_imageToBase64{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    if ([self hasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType, [imageData base64EncodedStringWithOptions: 0]];
}

+ (UIImage *)mk_imageWithBase64:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

- (BOOL)hasAlpha{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


//
- (NSData *)bitmapData{
    CGImageRef imageRef = self.CGImage;
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self bitmapRGBA8Context];
    
    if(!context) {
        return nil;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    uint32_t *bitmapData = (uint32_t *)CGBitmapContextGetData(context);
    
    if(bitmapData) {
        uint8_t *m_imageData = (uint8_t *) malloc(width * height/8 + 8*height/8);
        memset(m_imageData, 0, width * height/8 + 8*height/8);
        int result_index = 0;
        
        for(int y = 0; (y + 24) < height; ) {
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 51;
            m_imageData[result_index++] = 0;
            
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 42;
            m_imageData[result_index++] = 33;
            
            m_imageData[result_index++] = width%256;
            m_imageData[result_index++] = width/256;
            for(int x = 0; x < width; x++) {
                int value = 0;
                for (int temp_y = 0 ; temp_y < 8; ++temp_y){
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[BPRed] + 0.59 * rgbaPixel[BPGreen] + 0.11 * rgbaPixel[BPBlue];
                    
                    if (gray < 127){
                        value += 1<<(7-temp_y)&255;
                    }
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 8 ; temp_y < 16; ++temp_y){
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[BPRed] + 0.59 * rgbaPixel[BPGreen] + 0.11 * rgbaPixel[BPBlue];
                    
                    if (gray < 127){
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 16 ; temp_y < 24; ++temp_y){
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[BPRed] + 0.59 * rgbaPixel[BPGreen] + 0.11 * rgbaPixel[BPBlue];
                    
                    if (gray < 127){
                        value += 1<<(7-temp_y%8)&255;
                    }
                }
                m_imageData[result_index++] = value;
            }
            m_imageData[result_index++] = 13;
            m_imageData[result_index++] = 10;
            y += 24;
        }
        
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
        [data appendBytes:m_imageData length:result_index];
        
        free(bitmapData);
        return data;
    }
    
    NSLog(@"Error getting bitmap pixel data\n");
    CGContextRelease(context);
    
    return nil ; 
}

- (CGContextRef)bitmapRGBA8Context{
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) {
        return NULL;
    }
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);	// RGBA
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;	

}

- (UIImage *)imageWithscaleMaxWidth:(CGFloat)maxWidth{
    CGFloat width = self.size.width;
    if (width > maxWidth){
        CGFloat height = self.size.height;
        CGFloat maxHeight = maxWidth * height / width;
        
        CGSize size = CGSizeMake(maxWidth, maxHeight);
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0, 0, maxWidth, maxHeight)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    
    return self;
}

- (UIImage *)blackAndWhiteImage{
    //    CGSize size = self.size;
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"
                                  keysAndValues:kCIInputImageKey,beginImage,kCIInputColorKey,[CIColor colorWithCGColor:[UIColor blackColor].CGColor],nil];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    //    UIImage *newImage = [UIImage createNonInterpolatedUIImageFormCIImage:outputImage withSize:size.width];

    return newImage;
}

@end

@implementation UIImage (QRCode)

+ (UIImage *)barCodeImageWithInfo:(NSString *)info{
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setDefaults];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    UIImage *image =[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:300];
    
    return image;
}

+ (UIImage *)qrCodeImageWithInfo:(NSString *)info centerImage:(UIImage *)centerImage  width:(CGFloat)width{
    if (!info) {
        return nil;
    }
    
    NSData *strData = [info dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    
    UIImage *codeImage = [UIImage createNonInterpolatedUIImageFormCIImage:qrImage withSize:width];
    
    CGRect rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height);
    UIGraphicsBeginImageContext(rect.size);
    [codeImage drawInRect:rect];
    if (centerImage) {
        CGSize logoSize = CGSizeMake(rect.size.width*0.2, rect.size.height*0.2);
        CGFloat x = CGRectGetMidX(rect) - logoSize.width*0.5;
        CGFloat y = CGRectGetMidY(rect) - logoSize.height*0.5;
        CGRect logoFrame = CGRectMake(x, y, logoSize.width, logoSize.height);
        [[UIBezierPath bezierPathWithRoundedRect:logoFrame cornerRadius:10] addClip];
        
        [centerImage drawInRect:logoFrame];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (UIImage*)imageBgColorToTransparentWith:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end