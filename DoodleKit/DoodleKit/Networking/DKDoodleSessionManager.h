//
//  DKDoodleSessionManager.h
//  DoodleKit
//
//  Created by Ryan Crosby on 7/14/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DKDoodleSessionManagerDelegate <NSObject>

// something

@end

@interface DKDoodleSessionManager : NSObject

@property (nonatomic, weak) id<DKDoodleSessionManagerDelegate> delegate;

@end
