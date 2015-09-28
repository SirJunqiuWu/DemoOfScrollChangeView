//
//  ScrollheaderView.m
//  DomeOfScrollHeader
//
//  Created by 吴 吴 on 15/9/28.
//  Copyright © 2015年 吴 吴. All rights reserved.
//

#import "ScrollheaderView.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface ScrollheaderView()

/**
 *  拉动变化图片数组
 */
@property (nonatomic, strong) NSMutableArray *blurImagesArray;

/**
 *  变化视图变化高度
 */
@property (nonatomic, assign) CGFloat OTCoverHeight;


@end

@implementation ScrollheaderView
@synthesize headerImageView,infoTable,baseSV;

- (id)initTableWithFrame:(CGRect)frame CoverHeight:(CGFloat)height {
    self = [super initWithFrame:frame];
    if (self) {
        self.OTCoverHeight = height;
        self.blurImagesArray = [NSMutableArray array];
        [self setupTableUI];
    }
    return self;
}

- (id)initScrollViewWithFrame:(CGRect)frame CoverHeight:(CGFloat)height {
    self = [super initWithFrame:frame];
    if (self) {
        self.OTCoverHeight = height;
        self.blurImagesArray = [NSMutableArray array];
        [self setupScrollViewUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupTableUI {
    
    headerImageView = [[ScrollHeaderContentView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.OTCoverHeight)];
    [self addSubview:headerImageView];
    
    infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height) style:UITableViewStylePlain];
    infoTable.tableHeaderView.backgroundColor = [UIColor clearColor];
    infoTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.OTCoverHeight)];
    infoTable.backgroundColor = [UIColor clearColor];
    [infoTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:infoTable];
}

- (void)setupScrollViewUI {
    headerImageView = [[ScrollHeaderContentView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.OTCoverHeight)];
    [self addSubview:headerImageView];
    
    baseSV = [[UIScrollView alloc] initWithFrame:self.frame];
    baseSV.backgroundColor = [UIColor clearColor];
    [baseSV addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:baseSV];
    
    self.scrollContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.OTCoverHeight, self.frame.size.width,self.frame.size.height)];
    self.scrollContentView.backgroundColor = [UIColor whiteColor];
    baseSV.contentSize = self.scrollContentView.frame.size;
    [baseSV addSubview:self.scrollContentView];
    
}

#pragma mark - 数据源

- (void)initViewWithDic:(NSDictionary  *)dic {
    headerImageView.headerIcon.image = [UIImage imageNamed:@"image"];
    [self.blurImagesArray removeAllObjects];
    [self prepareForBlurImages];
    
    self.scrollContentHeight = [[UIScreen mainScreen]bounds].size.height +200;
    if (baseSV) {
        baseSV.contentSize = CGSizeMake(self.frame.size.width,self.scrollContentHeight);
    }
}

- (void)prepareForBlurImages {
    CGFloat factor = 0.1;
    [self.blurImagesArray addObject:self.headerImageView.headerIcon.image];
    for (NSUInteger i = 0; i < self.OTCoverHeight/10; i++) {
        [self.blurImagesArray addObject:[self.headerImageView.headerIcon.image boxblurImageWithBlur:factor]];
        factor+=0.04;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (infoTable) {
        [self animationForTableView];
    }
    else{
        [self animationForScrollView];
    }
}

- (void)animationForTableView {
    
    CGFloat offset = infoTable.contentOffset.y;
    
    if (infoTable.contentOffset.y > 0) {
        
        NSInteger index = offset / 10;
        if (index < 0) {
            index = 0;
        }
        else if(index >= self.blurImagesArray.count) {
            index = self.blurImagesArray.count - 1;
        }
        UIImage *image = self.blurImagesArray[index];
        if (self.headerImageView.headerIcon.image != image) {
            [self.headerImageView.headerIcon setImage:image];
            
        }
        infoTable.backgroundColor = [UIColor clearColor];
    }
    else {
        self.headerImageView.headerIcon.frame = CGRectMake(offset,0, self.frame.size.width+ (-offset) * 2, self.OTCoverHeight + (-offset));
        self.headerImageView.titleLbl.frame = CGRectMake(0, self.headerImageView.headerIcon.frame.size.height-20,[[UIScreen mainScreen]bounds].size.width, 20);
    }
}

- (void)animationForScrollView{
    CGFloat offset = baseSV.contentOffset.y;
    if (baseSV.contentOffset.y > 0) {
        
        NSInteger index = offset / 10;
        if (index < 0) {
            index = 0;
        }
        else if(index >= self.blurImagesArray.count) {
            index = self.blurImagesArray.count - 1;
        }
        UIImage *image = self.blurImagesArray[index];
        if (self.headerImageView.headerIcon.image != image) {
            [self.headerImageView.headerIcon setImage:image];
            
        }
        baseSV.backgroundColor = [UIColor clearColor];
    }
    else {
        self.headerImageView.headerIcon.frame = CGRectMake(offset,0, self.frame.size.width + (-offset) * 2, self.OTCoverHeight + (-offset));
        self.headerImageView.titleLbl.frame = CGRectMake(0, self.headerImageView.headerIcon.frame.size.height-20,[[UIScreen mainScreen]bounds].size.width, 20);
    }
}


#pragma mark - 视图 和 KVO移除

- (void)removeFromSuperview {
    if (infoTable) {
        [infoTable removeObserver:self forKeyPath:@"contentOffset"];
    }
    else{
        [baseSV removeObserver:self forKeyPath:@"contentOffset"];
    }
    [super removeFromSuperview];
}

- (void)dealloc {
    if (infoTable) {
        [infoTable removeObserver:self forKeyPath:@"contentOffset"];
    }else{
        [baseSV removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end

@implementation UIImage (Blur)

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
