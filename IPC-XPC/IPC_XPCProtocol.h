//
//  IPC_XPCProtocol.h
//  IPC-XPC
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHeader.h"
// The protocol that this service will vend as its API. This header file will also need to be visible to the process hosting the service.
@protocol IPC_XPCServiceProtocol

// Replace the API of this protocol with an API appropriate to the service you are vending.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply;
- (void)operateWith:(MessageType)type
             action:(IPCAction)action
               info:(NSString *)info
           callback:(void (^)(NSString *))reply;
@end

@protocol IPC_XPCHostProtocol

- (void)messageDidCall:(NSString *)msg reply:(void (^)(BOOL))reply;

@end

/*
 To use the service from an application or other process, use NSXPCConnection to establish a connection to the service by doing something like this:

     _connectionToService = [[NSXPCConnection alloc] initWithServiceName:@"www.koebluo.com.IPC-XPC"];
     _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(IPC_XPCProtocol)];
     [_connectionToService resume];

Once you have a connection to the service, you can use it like this:

     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello" withReply:^(NSString *aString) {
         // We have received a response. Update our text field, but do it on the main thread.
         NSLog(@"Result string was: %@", aString);
     }];

 And, when you are finished with the service, clean up the connection like this:

     [_connectionToService invalidate];
*/
