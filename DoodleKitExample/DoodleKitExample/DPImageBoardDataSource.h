//
//  DPImageBoardDataSource.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPImageBoardDataSource <NSObject>

- (UIImageView *)viewForIndex:(NSUInteger)index;

@end
