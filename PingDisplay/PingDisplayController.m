//
// Created by Mitchell Vanderhoeff on 2012-12-14.
//


#import "PingDisplayController.h"
#import "SimplePingHelper.h"


@implementation PingDisplayController {

}

- (void)setup {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
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
        unsigned int pingMillis = (unsigned int) ((currentTime - self.pingTime) * 1000);
        [self displayAverage:pingMillis];
        [self displayPingMillis:pingMillis];
    } else {
        self.statusItem.attributedTitle =
                [[NSAttributedString alloc] initWithString:self.statusItem.attributedTitle.string
                  attributes:@{ NSFontSizeAttribute : @2.0,
                                NSForegroundColorAttributeName: [NSColor colorWithDeviceRed:0.5 green:0 blue:0 alpha:1.0] }];
    }
}

- (void)displayAverage:(unsigned int)pingMillis {
    static unsigned int averageSamples[20];
    static unsigned long pingCount = 0;
    averageSamples[pingCount % 20] = pingMillis;
    if (pingCount >= 19) {
        unsigned int sum = 0;
        for (int i = 0; i < 20; i++) {
            sum += averageSamples[i];
        }
        double average = (double) sum / 20.0;
        self.pingAverageMenuItem.title = [NSString stringWithFormat:@"Average: %0.1fms", average];
    }
    pingCount++;
}

- (void)displayPingMillis:(unsigned int)pingMillis {
    self.statusItem.attributedTitle =
            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ims", pingMillis]
                 attributes:@{ NSFontSizeAttribute : @2.0 }];
}
@end