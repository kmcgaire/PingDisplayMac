//
// Created by Mitchell Vanderhoeff on 2012-12-14.
//


#import "PingDisplayController.h"
#import "SimplePingHelper.h"


@implementation PingDisplayController {

}

-(void)setup {
    self.pingDisplayItem =  [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
}

- (void)startPinging {
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:0.85 target:self selector:@selector(initiatePing) userInfo:nil repeats:YES];
}

- (void)stopPinging {
    [self.pingTimer invalidate];
}

- (void)initiatePing {
    self.pingTime = CFAbsoluteTimeGetCurrent();
    [SimplePingHelper ping:@"4.2.2.2" target:self sel:@selector(pingReturned:)];
}

- (void)pingReturned:(NSNumber *)success {
    if (success.boolValue == YES){
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        int pingMs = (long) ((currentTime - self.pingTime) * 1000);
        NSString *pingDisplayString = [NSString stringWithFormat:@"%ims", pingMs];
        [self displayStatusString:pingDisplayString];
    } else {
        [self displayStatusString:@"ms"];
    }
}

- (void)displayStatusString:(NSString *)statusString {
    self.pingDisplayItem.attributedTitle =
                [[NSAttributedString alloc] initWithString:statusString attributes:@{NSFontSizeAttribute : @2.0}];
}
@end