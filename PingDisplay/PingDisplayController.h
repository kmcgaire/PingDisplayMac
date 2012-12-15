//
// Created by Mitchell Vanderhoeff on 2012-12-14.
//


#import <Foundation/Foundation.h>


@interface PingDisplayController : NSObject
@property (nonatomic,strong)NSStatusItem *pingDisplayItem;
@property (nonatomic,strong)NSTimer *pingTimer;
@property (nonatomic)CFAbsoluteTime pingTime;

@property (nonatomic,strong)NSMenuItem *pingAverageMenuItem;

-(void)setup;

-(void)startPinging;

-(void)stopPinging;
@end