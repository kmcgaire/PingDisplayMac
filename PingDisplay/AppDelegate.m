//
//  AppDelegate.m
//  PingDisplay
//
//  Created by Mitchell Vanderhoeff on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PingDisplayController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.pingDisplayController = [[PingDisplayController alloc] init];
    [self.pingDisplayController setup];
    [self.pingDisplayController startPinging];
}


@end