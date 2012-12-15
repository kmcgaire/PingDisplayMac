//
// Created by Mitchell Vanderhoeff on 2012-12-14.
//


#import "PingDisplayController.h"
#import "SimplePingHelper.h"


@implementation PingDisplayController {

}

-(void)setup {
    self.statusItem =  [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.highlightMode = YES;
    self.statusItem.menu = [[NSMenu alloc] init];
    self.pingAverageMenuItem = [self.statusItem.menu addItemWithTitle:@"Average: calculating.." action:nil keyEquivalent:@""];
    NSMenuItem *quitItem = [self.statusItem.menu addItemWithTitle:@"Quit" action:nil keyEquivalent:@""];
    quitItem.target = self;
    quitItem.action = @selector(quitApplication);
    [quitItem setEnabled:YES];
}

- (void)quitApplication {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)startPinging {
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:1.15 target:self selector:@selector(initiatePing) userInfo:nil repeats:YES];
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
    self.statusItem.attributedTitle =
                [[NSAttributedString alloc] initWithString:statusString attributes:@{NSFontSizeAttribute : @2.0}];
}
@end