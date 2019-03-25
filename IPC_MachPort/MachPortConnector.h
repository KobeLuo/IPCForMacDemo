//
//  MachPortConnector.h
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *(^MessageInvoke)(NSString *c,int msgid);

#define GROUP_ID "group.machport.kobeluo.www"

#if HOST_APP
#define CONNECTOR_LISTEN_GROUP_ID GROUP_ID".client"
#define CONNECTOR_SEND_GROUP_ID   GROUP_ID".host"
#define MESSAGE_ID_SIGNATUR 1
#else
#define CONNECTOR_LISTEN_GROUP_ID GROUP_ID".host"
#define CONNECTOR_SEND_GROUP_ID   GROUP_ID".client"
#define MESSAGE_ID_SIGNATUR -1
#endif

#define MESSAGE_TIMEOUT_STAMP 5.0

@interface MachPortConnector : NSObject

+ (void)connect;
+ (void)unconnect;
+ (void)observeMessage:(MessageInvoke)invoke;
+ (NSString *)sendMessage:(NSString *)content;
+ (NSString *)sendMessage:(NSString *)content messageId:(SInt32)msgid;
+ (int)currentMessageId;

@end

NS_ASSUME_NONNULL_END
