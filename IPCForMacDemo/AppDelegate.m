//
//  AppDelegate.m
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "AppDelegate.h"
#import "KBIPCForXPC.h"
#import "MachPortConnector.h"
@interface AppDelegate ()  {
    
    KBIPCForXPC *_xpc;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [MachPortConnector connect];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)XPCAction:(id)sender {
    
    if (!_xpc) { _xpc = [KBIPCForXPC new]; }
    [_xpc sendMessageToXPC];
}
- (IBAction)machPortAction:(id)sender {
    
    NSLog(@"call client");
    NSString *result = [MachPortConnector sendMessage:@"call client"];
    NSLog(@"Mach port return:%@",result);
    [MachPortConnector observeMessage:^NSString *(NSString * _Nonnull c, int msgid) {
        
        NSLog(@"Mach port invoke:%@",c);
        return @"Host did received message";
    }];
}
- (IBAction)socketAction:(id)sender {
}
- (IBAction)notificationAction:(id)sender {
}
- (IBAction)appleEventAction:(id)sender {
}
- (IBAction)distributesAction:(id)sender {
}
- (IBAction)pasteboardAction:(id)sender {
}


@end
