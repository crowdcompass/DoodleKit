//
//  DPImageQuadrantDataSource.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPImageBoardTiler.h"

@interface DPImageBoardTiler() {
    CGSize _tileSize;
    dispatch_once_t onceToken;
}

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSMutableDictionary *tiledImages;

- (void)tileRect:(CGRect)rect index:(NSUInteger)index;

@end

@implementation DPImageBoardTiler

#pragma mark - DPImageBoardTiler

- (id)initWithImage:(UIImage *)image tileSize:(CGSize)tileSize delegate:(id<DPImageBoardTilerDelegate>)delegate {
    if (!image) {
        [NSException raise:NSInternalInconsistencyException format:@"BAD THINGS"];
    }
    
    self = [super init];
    if (self) {
        _tiledImages = [NSMutableDictionary dictionaryWithCapacity:4];
        _tileSize = tileSize;
        _originalImage = image;
        _userIndex = 0;
        _delegate = delegate;
        onceToken = 0;
    }
    
    return self;
}

- (void)tile {
    if (_userIndex > 3) [NSException raise:NSInternalInconsistencyException format:@"must set player index (0-3)"];
    
    for (NSUInteger i = 0; i <= 3; i++) {
        if (i == _userIndex) continue;
        
        [self tileRect:[self frameForIndex:i]
                 index:i];
    }
}

- (void)tileRect:(CGRect)rect index:(NSUInteger)index {
    __weak DPImageBoardTiler *selfRef = self;
    
    __block BOOL done = NO;
    dispatch_queue_t hiPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(hiPriority, ^{
    @autoreleasepool {
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect scaledRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
        CGImageRef cgImage = CGImageCreateWithImageInRect(self.originalImage.CGImage, scaledRect);
        selfRef.tiledImages[@(index)] = [UIImage imageWithCGImage:cgImage];
        CFRelease(cgImage);
        @synchronized(selfRef.tiledImages) {
            if (selfRef.tiledImages.count == 3u) {
                done = YES;
            }
        }
        if (done) {
            //FIXME: hack preventing this from firing multiple times
            dispatch_once(&onceToken, ^{
                [selfRef.delegate imageTilerFinished:selfRef
                                         tiledImages:selfRef.tiledImages];
            });
        }
    }
        
    });
}

#pragma mark - DPImageBoardDataSource

- (CGRect)frameForIndex:(NSUInteger)index {
    CGFloat x = (index == 0 || index == 2) ? 0.f : _tileSize.width;
    CGFloat y = (index <= 1) ? 0.f : _tileSize.height;
    y += 44.f;
    CGRect rectForIndex = CGRectMake(x, y, _tileSize.width, _tileSize.height);
    return rectForIndex;
}


@end
