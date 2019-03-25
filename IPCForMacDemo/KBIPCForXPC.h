//
//  KBIPCForXPC.h
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPC_XPCProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface KBIPCForXPC : NSObject <IPC_XPCHostProtocol> {
    
    NSXPCConnection *_xpcConnection;
}

- (void)sendMessageToXPC;
@end

NS_ASSUME_NONNULL_END
