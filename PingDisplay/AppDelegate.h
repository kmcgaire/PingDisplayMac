//
//  AppDelegate.h
//  PingDisplay
//
//  Created by Mitchell Vanderhoeff on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PingDisplayController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic,strong)PingDisplayController *pingDisplayController;

@end