//
//  IPC_XPC.m
//  IPC-XPC
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "IPC_XPC.h"

@interface IPC_XPC() {
    
    NSXPCListener *_listener;
}

@end

@implementation IPC_XPC

#pragma mark - XPC Listener Delegate
- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    
    _listener = listener;
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(IPC_XPCServiceProtocol)];
    newConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(IPC_XPCHostProtocol)];
    newConnection.exportedObject = self;
    self.connection = newConnection;
    
    [self.connection resume];
    
    return YES;
}

#pragma mark - XPC Interface Delegate
- (void)operateWith:(MessageType)type
             action:(IPCAction)action
               info:(NSString *)info
           callback:(void (^)(NSString *))reply {
    
    if (reply) {
        
        reply(@"xpc did received message");
    }
    
    NSString *str = [NSString stringWithFormat:@"xpc did received host message,type:%ld,action:%ld,info:%@",(long)type,(long)action,info];
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(t, dispatch_get_main_queue(), ^{
        
        [self->_connection.remoteObjectProxy messageDidCall:str reply:^(BOOL v) {}];
    });
}

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
