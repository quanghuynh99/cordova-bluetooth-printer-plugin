#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WKWebView (UIImage)

- (void)imageForWebViewWithCompletion:(void (^)(UIImage *))completion;

@end

@implementation WKWebView (UIImage)

- (void)imageForWebViewWithCompletion:(void (^)(UIImage *))completion {
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = self.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    
    NSMutableArray *images = [NSMutableArray array];
    
    // Chụp ảnh theo từng phần của webview
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // Render layer của WKWebView vào context
        [self.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = self.scrollView.contentOffset.y;
        self.scrollView.contentOffset = CGPointMake(0, offsetY + boundsHeight);
        contentHeight -= boundsHeight;
    }
    
    // Ghép tất cả các ảnh lại thành một ảnh lớn
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (completion) {
        completion(fullImage);
    }
}

@end