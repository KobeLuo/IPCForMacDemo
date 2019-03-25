//
//  IPC_XPC.h
//  IPC-XPC
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPC_XPCProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface IPC_XPC : NSObject <IPC_XPCProtocol>
@end
