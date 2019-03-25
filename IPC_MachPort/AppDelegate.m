//
//  AppDelegate.m
//  IPC_MachPort
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "AppDelegate.h"
#import "MachPortConnector.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [MachPortConnector connect];
    [MachPortConnector observeMessage:^NSString *(NSString * _Nonnull c, int msgid) {
       
        NSLog(@"client did received message: %@",c);
        
        NSString *str = [NSString stringWithFormat:@"client did received host msg:%@",c];
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(t, dispatch_get_main_queue(), ^{
            [MachPortConnector sendMessage:str];
        });
        return @"client did received message";
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
