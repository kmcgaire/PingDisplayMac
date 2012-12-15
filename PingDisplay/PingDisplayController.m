//
// Created by Mitchell Vanderhoeff on 2012-12-14.
//


#import "PingDisplayController.h"
#import "SimplePingHelper.h"


@implementation PingDisplayController {

}

-(void)setup {
    self.pingDisplayItem =  [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.pingDisplayItem.highlightMode = YES;
    self.pingDisplayItem.menu = [[NSMenu alloc] init];
    self.pingAverageMenuItem = [self.pingDisplayItem.menu addItemWithTitle:@"Average: calculating.." action:nil keyEquivalent:@""];
}

- (void)startPinging {
    [self initiatePing];
}

- (void)stopPinging {
    [self.pingTimer invalidate];
}

- (void)initiatePing {
    self.pingTime = CFAbsoluteTimeGetCurrent();
    [SimplePingHelper ping:@"4.2.2.2" target:self sel:@selector(pingReturned:)];
}

- (void)pingReturned:(NSNumber *)success {

    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    if (success.boolValue == YES) {
        int pingMillis = (int) ((currentTime - self.pingTime) * 1000);
        [self displayAverage:pingMillis];
        [self displayStatusString:[NSString stringWithFormat:@"%ims", pingMillis]];
    }
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:1.15 target:self selector:@selector(initiatePing) userInfo:nil repeats:NO];
}

- (void)displayAverage:(int)pingMillis {
    static int averageSamples[20];
    static int pingCount = 0;
    averageSamples[pingCount % 20] = pingMillis;
    if (pingCount >= 19) {
            int sum = 0;
            for (int i = 0; i < 20; i++) {
                sum += averageSamples[i];
            }
            double average = (double) sum / 20.0;
            self.pingAverageMenuItem.title = [NSString stringWithFormat:@"Average: %0.1fms", average];
        }
    pingCount++;
}

- (void)displayStatusString:(NSString *)statusString {
    self.pingDisplayItem.attributedTitle =
                [[NSAttributedString alloc] initWithString:statusString attributes:@{NSFontSizeAttribute : @2.0}];
}
@end