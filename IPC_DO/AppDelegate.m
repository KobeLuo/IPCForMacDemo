//
//  AppDelegate.m
//  IPC_DO
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "AppDelegate.h"
#import "KBIPCForDOProtocol.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    id proxy = [NSConnection rootProxyForConnectionWithRegisteredName:RegistName host:nil];
    NSLog(@"proxy: %@",proxy);
//    [proxy setProtocolForProxy:@protocol(DOProtocol)];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
