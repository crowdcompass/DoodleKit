//
//  DPSwatch.h
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/12/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPSwatch : UIButton

@property (nonatomic, strong) UIColor *swatchColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *borderColor;

- (id)initWithColor:(UIColor *)swatchColor;
- (id)initWithColor:(UIColor *)swatchColor andBorderColor:(UIColor *)borderColor;
- (id)initWithColor:(UIColor *)swatchColor borderColor:(UIColor *)borderColor andSelectedColor:(UIColor *)selectedColor;

@end
