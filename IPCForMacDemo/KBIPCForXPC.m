//
//  KBIPCForXPC.m
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "KBIPCForXPC.h"

@implementation KBIPCForXPC

#pragma mark - XPC

- (instancetype)init {
    
    if (self = [super init]) {
        
        _xpcConnection = [[NSXPCConnection alloc] initWithServiceName:@"www.koebluo.com.IPC-XPC"];
        //configure remote object interface.
        _xpcConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(IPC_XPCServiceProtocol)];
        
        //configure local object interface and target.
        _xpcConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(IPC_XPCHostProtocol)];
        _xpcConnection.exportedObject = self;
        [_xpcConnection resume];
    }
    return self;
}

- (void)sendMessageToXPC {
    
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(t, dispatch_get_main_queue(), ^{
        
        [self sendMessage];
    });
}

- (void)sendMessage {
    
    [_xpcConnection.remoteObjectProxy operateWith:MT_1
                                           action:IPCAction_0
                                             info:@"test xpc"
                                         callback:^(NSString *info) {
                                             
                                             NSLog(@"XPC Reply:%@",info);
                                         }];
}

- (void)messageDidCall:(NSString *)msg reply:(void (^)(BOOL))reply {
    
    NSLog(@"XPC Invoke:%@",msg);
}

@end
