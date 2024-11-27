#import "HLPrinter.h"

#define kHLMargin 20
#define kHLPadding 2
#define kHLPreviewWidth 320

#define KDefault_pageWidth 78
static NSString * const kUD_pringerPageWidth = @"kUD_pringerPageWidth";

#define kDefault_maxLength3Text 16
#define kDefault_maxLength4Text 20

static NSString * const kUD_maxLength3Text = @"kUD_maxLength3Text";
static NSString * const kUD_maxLength4Text = @"kUD_maxLength4Text";

@interface HLPrinter ()

@property (strong, nonatomic) NSMutableData *printerData;
@property (strong, nonatomic) MKPageWidthConfig *config;

@end

@implementation HLPrinter

static HLPrinter *sharedInstance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting{
    _printerData = [[NSMutableData alloc] init];
    
    Byte initBytes[] = {0x1B,0x40};
    [_printerData appendBytes:initBytes length:sizeof(initBytes)];
    Byte lineSpace[] = {0x1B,0x32};
    [_printerData appendBytes:lineSpace length:sizeof(lineSpace)];
    Byte fontBytes[] = {0x1B,0x4D,0x00};
    [_printerData appendBytes:fontBytes length:sizeof(fontBytes)];
    
    _pageWidth = [[NSUserDefaults standardUserDefaults] integerForKey:kUD_pringerPageWidth];
    if (_pageWidth <= 0) {
        _pageWidth = KDefault_pageWidth;
        [[NSUserDefaults standardUserDefaults] setInteger:_pageWidth forKey:kUD_pringerPageWidth];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _config = [[MKPageWidthConfig alloc] init];
    [_config setupConfigWith:_pageWidth];
    
    _maxLength3Text = [[NSUserDefaults standardUserDefaults] integerForKey:kUD_maxLength3Text];
    if (_maxLength3Text <= 0) {
        _maxLength3Text = kDefault_maxLength3Text;
    }
    
    _maxLength4Text = [[NSUserDefaults standardUserDefaults] integerForKey:kUD_maxLength4Text];
    if (_maxLength4Text <= 0) {
        _maxLength4Text = kDefault_maxLength4Text;
    }
}

- (void)setMaxLength3Text:(NSInteger)maxLength3Text{
    if (maxLength3Text > 0) {
        _maxLength3Text = maxLength3Text;
        [[NSUserDefaults standardUserDefaults] setInteger:_maxLength3Text forKey:kUD_maxLength3Text];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setMaxLength4Text:(NSInteger)maxLength4Text{
    if (maxLength4Text > 0) {
        _maxLength4Text = maxLength4Text;
        [[NSUserDefaults standardUserDefaults] setInteger:_maxLength4Text forKey:kUD_maxLength4Text];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - ***** 设置打印机纸张宽度 ******
- (void)setPageWidth:(NSInteger)pageWidth{
    if (pageWidth > 0) {
        _pageWidth = pageWidth;
        [[NSUserDefaults standardUserDefaults] setInteger:_pageWidth forKey:kUD_pringerPageWidth];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.config setupConfigWith:_pageWidth];
    }
}


#pragma mark - -----------------------------
/**
 *  
 */
- (void)appendNewLine{
    Byte nextRowBytes[] = {0x0A};
    [_printerData appendBytes:nextRowBytes length:sizeof(nextRowBytes)];
}

/**
 *  
 */
- (void)appendReturn{
    Byte returnBytes[] = {0x0D};
    [_printerData appendBytes:returnBytes length:sizeof(returnBytes)];
}

/**
 *  
 *
 *  @param alignment
 */
- (void)setAlignment:(HLTextAlignment)alignment{
    Byte alignBytes[] = {0x1B,0x61,alignment};
    [_printerData appendBytes:alignBytes length:sizeof(alignBytes)];
}

/**
 *
 */
- (void)setFontSize:(HLFontSize)fontSize{
    Byte fontSizeBytes[] = {0x1D,0x21,fontSize};
    [_printerData appendBytes:fontSizeBytes length:sizeof(fontSizeBytes)];
}

/**
 *
 */
- (void)setText:(NSString *)text{
    NSString *str;
    if ([text isKindOfClass:[NSNumber class]]) {
        str = [NSString stringWithFormat:@"%@", str];
    }else{
        str = text;
    }

    // NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_printerData appendData:data];
}

/**
 */
- (void)setText:(NSString *)text maxChar:(int)maxChar{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsVietnamese);
    NSData *data = [text dataUsingEncoding:enc];
    if (data.length > maxChar) {
        data = [data subdataWithRange:NSMakeRange(0, maxChar)];
        text = [[NSString alloc] initWithData:data encoding:enc];
        if (!text) {
            data = [data subdataWithRange:NSMakeRange(0, maxChar - 1)];
            text = [[NSString alloc] initWithData:data encoding:enc];
        }
        text = [text stringByAppendingString:@"..."];
    }
    [self setText:text];
}

/**
 *  
 */
- (void)setOffsetText:(NSString *)text{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:22.0]};
    NSAttributedString *valueAttr = [[NSAttributedString alloc] initWithString:text attributes:dict];
    int valueWidth = valueAttr.size.width;
    
    [self setOffset:368 - valueWidth];
    
    [self setText:text];
}

/**
 */
- (void)setOffset:(NSInteger)offset{
    NSInteger remainder = offset % 256;
    NSInteger consult = offset / 256;
    Byte spaceBytes2[] = {0x1B, 0x24, remainder, consult};
    [_printerData appendBytes:spaceBytes2 length:sizeof(spaceBytes2)];
}

/**
 */
- (void)setLineSpace:(NSInteger)points{
    Byte lineSpace[] = {0x1B,0x33,points};
    [_printerData appendBytes:lineSpace length:sizeof(lineSpace)];
}

/**
 */
- (void)setQRCodeSize:(NSInteger)size{
    Byte QRSize [] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x43,size};
//    Byte QRSize [] = {29,40,107,3,0,49,67,size};
    [_printerData appendBytes:QRSize length:sizeof(QRSize)];
}

/**
 */
- (void)setQRCodeErrorCorrection:(NSInteger)level{
    Byte levelBytes [] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x45,level};
//    Byte levelBytes [] = {29,40,107,3,0,49,69,level};
    [_printerData appendBytes:levelBytes length:sizeof(levelBytes)];
}

/**
 */
- (void)setQRCodeInfo:(NSString *)info{
    NSInteger kLength = info.length + 3;
    NSInteger pL = kLength % 256;
    NSInteger pH = kLength / 256;
    
    Byte dataBytes [] = {0x1D,0x28,0x6B,pL,pH,0x31,0x50,48};
    [_printerData appendBytes:dataBytes length:sizeof(dataBytes)];
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [_printerData appendData:infoData];
}

/**
 */
- (void)printStoredQRData{
    Byte printBytes [] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x51,48};
//    Byte printBytes [] = {29,40,107,3,0,49,81,48};
    [_printerData appendBytes:printBytes length:sizeof(printBytes)];
}

#pragma mark - ------------function method ----------------
#pragma mark
- (void)appendText:(NSString *)text alignment:(HLTextAlignment)alignment{
    [self appendText:text alignment:alignment fontSize:HLFontSizeTitleSmalle];
}

- (void)appendText:(NSString *)text alignment:(HLTextAlignment)alignment fontSize:(HLFontSize)fontSize{
    [self setAlignment:alignment];
    [self setFontSize:fontSize];
    [self setText:text];
    [self appendNewLine];
    if (fontSize != HLFontSizeTitleSmalle) {
        [self appendNewLine];
    }
}

- (void)appendTitle:(NSString *)title value:(NSString *)value{
    [self appendTitle:title value:value fontSize:HLFontSizeTitleSmalle];
}

- (void)appendTitle:(NSString *)title value:(NSString *)value fontSize:(HLFontSize)fontSize{
    [self setAlignment:HLTextAlignmentLeft];
    [self setFontSize:fontSize];
    
    NSString *text = [self getPrintString:title tail:value];
    [self setText:text];
    [self appendNewLine];
    if (fontSize != HLFontSizeTitleSmalle) {
        [self appendNewLine];
    }
}

- (NSString *)getPrintString:(NSString *)leader tail:(NSString *)tail{
    int TOTAL = self.config.virtualWidth;
    NSMutableString *printString = [NSMutableString new];
    [printString appendString:leader];
    
    int lenderLen = [self getTextLength:leader];
    
    if (tail) {
        int tailLen = [self getTextLength:tail];
        int detal = (int)(TOTAL - lenderLen - tailLen);
        for (int i = 0; i < detal; i ++) {
            [printString appendString:@" "];
        }
        [printString appendString:tail];
    }else{
        int detal = (int)(TOTAL - lenderLen);
        for (int i = 0; i < detal; i ++) {
            [printString appendString:@" "];
        }
    }
    return printString;
}

- (int)getTextLength:(NSString *)text{
    int strlength = 0;
    char *p = (char*)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
    }
    return strlength;
}

- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset{
    [self appendTitle:title value:value valueOffset:offset fontSize:HLFontSizeTitleSmalle];
}

- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset fontSize:(HLFontSize)fontSize{
    [self setAlignment:HLTextAlignmentLeft];
    [self setFontSize:fontSize];
    [self setText:title];
    [self setOffset:offset];
    [self setText:value];
    [self appendNewLine];
    if (fontSize != HLFontSizeTitleSmalle) {
        [self appendNewLine];
    }
}

- (void)appendLeftText:(NSString *)left middleText:(NSString *)middle rightText:(NSString *)right isTitle:(BOOL)isTitle{
    [self setAlignment:HLTextAlignmentLeft];
    
    NSInteger offset = 0;
    if (!isTitle) {
        offset = 10;
        [self setFontSize:HLFontSizeTitleMiddle];
    }
    
    if (left) {
        [self setText:left maxChar:(int)[HLPrinter sharedInstance].maxLength3Text];
    }
    
    if (middle) {
        [self setOffset:[self.config.offsetAryfor3Text[0] intValue] + offset];
        [self setText:middle];
    }
    
    if (right) {
        [self setOffset:[self.config.offsetAryfor3Text[1] intValue] + offset];
        [self setText:right];
    }
    
    [self appendNewLine];
    
}

- (void)appendTextArray:(NSArray *)texts isTitle:(BOOL)isTitle{
    if (texts.count == 4) {
        [self setAlignment:HLTextAlignmentLeft];
        [self setFontSize:HLFontSizeTitleSmalle];
        
        NSInteger offset = 0;
        if (!isTitle) {
            offset = 5;
        }
        
        if ([texts[0] length] > 0) {
            [self setText:texts[0] maxChar:(int)[HLPrinter sharedInstance].maxLength4Text];
        }
        
        if ([texts[1] length] > 0) {
            [self setOffset:[self.config.offsetAryfor4Text[0] intValue] + offset];
            [self setText:texts[1]];
        }
        if ([texts[2] length] > 0) {
            [self setOffset:[self.config.offsetAryfor4Text[1] intValue] + offset];
            [self setText:texts[2]];
        }
        if ([texts[3] length] > 0) {
            [self setOffset:[self.config.offsetAryfor4Text[2] intValue] + offset];
            [self setText:texts[3]];
        }
        [self appendNewLine];
    }
}

#pragma mark
- (void)appendImage:(UIImage *)image alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth{
    if (!image) {
        return;
    }
    [self setAlignment:alignment];
    
    UIImage *newImage = [image imageWithscaleMaxWidth:250];
    
    NSData *imageData = [newImage bitmapData];
    [_printerData appendData:imageData];
    
    [self appendNewLine];
    [self appendSpaceLine];

    Byte lineSpace[] = {0x1B,0x32};
    [_printerData appendBytes:lineSpace length:sizeof(lineSpace)];
}

- (void)appendBarCodeWithInfo:(NSString *)info{
    [self appendBarCodeWithInfo:info alignment:HLTextAlignmentCenter maxWidth:300];
}

- (void)appendBarCodeWithInfo:(NSString *)info alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth{
    UIImage *barImage = [UIImage barCodeImageWithInfo:info];
    [self appendImage:barImage alignment:alignment maxWidth:maxWidth];
}

- (void)appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size{
    [self appendQRCodeWithInfo:info size:size alignment:HLTextAlignmentCenter];
}

- (void)appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(HLTextAlignment)alignment{
    [self setAlignment:alignment];
    [self setQRCodeSize:size];
    [self setQRCodeErrorCorrection:48];
    [self setQRCodeInfo:info];
    [self printStoredQRData];
    [self appendNewLine];
}

- (void)appendQRCodeWithInfo:(NSString *)info{
    [self appendQRCodeWithInfo:info centerImage:nil alignment:HLTextAlignmentCenter maxWidth:250];
}

- (void)appendQRCodeWithInfo:(NSString *)info centerImage:(UIImage *)centerImage alignment:(HLTextAlignment)alignment maxWidth:(CGFloat )maxWidth{
    UIImage *QRImage = [UIImage qrCodeImageWithInfo:info centerImage:centerImage width:maxWidth];
    [self appendImage:QRImage alignment:alignment maxWidth:maxWidth];
}

/**
 */
- (void)appendCustomData:(NSData *)data{
    if (data.length <= 0) {
        return;
    }
    [_printerData appendData:data];
}

#pragma mark
- (void)appendSeperatorLine{
    [self setAlignment:HLTextAlignmentCenter];
    [self setFontSize:HLFontSizeTitleSmalle];
    NSString *line = self.config.lineStr;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [line dataUsingEncoding:enc];
    [_printerData appendData:data];
    [self appendNewLine];
}

- (void)appendSpaceLine{
    [self setAlignment:HLTextAlignmentCenter];
    [self setFontSize:HLFontSizeTitleSmalle];
    NSString *line = @"                           ";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [line dataUsingEncoding:enc];
    [_printerData appendData:data];
    [self appendNewLine];
}

- (void)appendCutPaper{
    Byte bytes[] = {0x1D,0x56,0x41,0x00}; 
    [_printerData appendBytes:bytes length:sizeof(bytes)];
}

- (void)appendFooter:(NSString *)footerInfo{
    if (!footerInfo || footerInfo.length == 0) {
        return;
    }
    [self appendSeperatorLine];
    [self appendText:footerInfo alignment:HLTextAlignmentCenter];
    [self appendNewLine];
}

- (NSData *)getFinalData{
    return _printerData;
}


#pragma mark - ***** page width auto adjust ******

@end

@implementation MKPageWidthConfig
- (void)setupConfigWith:(NSInteger)width{
    if (width == 58) {
        self.lineStr = @"- - - - - - - - - - - - - - - -";
        self.offsetAryfor3Text = [NSArray arrayWithObjects:@(150), @(300), nil];
        self.offsetAryfor4Text = [NSArray arrayWithObjects:@(140), @(220), @(300), nil];
        self.virtualWidth = 30;
    }else{
        self.lineStr = @"- - - - - - - - - - - - - - - - - - - - - - - -";
        self.offsetAryfor3Text = [NSArray arrayWithObjects:@(240), @(480), nil];
        self.offsetAryfor4Text = [NSArray arrayWithObjects:@(280), @(380), @(470), nil];
        self.virtualWidth = 46;
    }
}

@end
