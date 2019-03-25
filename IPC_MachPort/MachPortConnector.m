//
//  MachPortConnector.m
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "MachPortConnector.h"

__strong static MachPortConnector *_connector = nil;

@interface MachPortConnector() {
    
    MessageInvoke _invoke;
    
    CFMessagePortRef _portListener;
    
    SInt32 _msgid;
    
    CFMessagePortRef _remoteRef;
}
@end

@implementation MachPortConnector

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _connector = [MachPortConnector new];
        _connector->_msgid = 1;
    });
    
    return _connector;
}


+ (void)connect {
    
    if (!([MachPortConnector sharedInstance]->_portListener)) {
        
        [[MachPortConnector sharedInstance] registerPort];
    }
}

+ (void)unconnect {
    
    [[MachPortConnector sharedInstance] unRegisterPort];
}

+ (void)observeMessage:(MessageInvoke)invoke {
    
    [MachPortConnector sharedInstance]->_invoke = invoke;
}
+ (int)currentMessageId {
    
    return _connector->_msgid * MESSAGE_ID_SIGNATUR;
}

+ (void)generateNewMessageId {
    
    _connector->_msgid = _connector->_msgid + 1;
    if (_connector->_msgid >= pow(2, 32) - 1) {
        
        _connector->_msgid = 1;
    }
}

+ (NSString *)sendMessage:(NSString *)content {
    
    return [self sendMessage:content messageId:[self currentMessageId]];
}

+ (NSString *)sendMessage:(NSString *)content messageId:(SInt32)msgid {
    
    CFStringRef ref = CFSTR(CONNECTOR_SEND_GROUP_ID);
    
    CFMessagePortRef remoteRef = CFMessagePortCreateRemote(kCFAllocatorDefault, ref);
    _connector->_remoteRef = remoteRef;
    
    if (nil == remoteRef) {
        
        NSLog(@"create remote ref failed");
        return nil;
    }
    
    const char *msg = [content UTF8String];
    CFDataRef data = nil;
    CFDataRef receiveData = nil;
    
    data = CFDataCreate(NULL, (UInt8 *)msg, strlen(msg));
    
    /// send message.
    CFMessagePortSendRequest(remoteRef,
                             msgid,
                             data,
                             0.0,
                             MESSAGE_TIMEOUT_STAMP,
                             kCFRunLoopDefaultMode,
                             &receiveData);
    
    if (nil == receiveData) {
        
        NSLog(@"received data is nil");
        CFRelease(data);
        CFMessagePortInvalidate(remoteRef);
        CFRelease(remoteRef);
        return nil;
    }
    
    const UInt8 *receiveMsg = CFDataGetBytePtr(receiveData);
    if (nil == receiveMsg) {
        
        NSLog(@"receive data error");
        CFRelease(data);
        CFMessagePortInvalidate(remoteRef);
        CFRelease(remoteRef);
        return nil;
    }
    NSString *strMsg = [NSString stringWithCString:(char *)receiveMsg encoding:NSUTF8StringEncoding];
    
    CFRelease(data);
    CFMessagePortInvalidate(remoteRef);
    CFRelease(remoteRef);
    CFRelease(receiveData);
    
    [MachPortConnector generateNewMessageId];
    
    return strMsg;
}

static CFDataRef Callback(CFMessagePortRef port, SInt32 messageID, CFDataRef data, void* info)
{
    NSData* objcData = (__bridge NSData*) data;
    NSString *msg = [NSString.alloc initWithData:objcData encoding:NSUTF8StringEncoding];
    
    NSString *returnMsg = nil;
    if (_connector->_invoke) {
        
        returnMsg = _connector->_invoke(msg,messageID);
    }
    if (nil == returnMsg || ![returnMsg isKindOfClass:[NSString class]]) {
        
        returnMsg = @"";
    }
    //为了测试，生成返回数据
    const char* cStr = [returnMsg UTF8String];
    NSUInteger ulen = [returnMsg lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    CFDataRef sgReturn = CFDataCreate(NULL, (UInt8 *)cStr, ulen);
    return sgReturn;
}

- (void)registerPort {
    
    if (0 != _portListener && CFMessagePortIsValid(_portListener)) {
        
        CFMessagePortInvalidate(_portListener);
    }
    CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault, CFSTR(CONNECTOR_LISTEN_GROUP_ID), Callback, NULL,NULL);
    
    int pid = [NSProcessInfo processInfo].processIdentifier;
    
    if (nil == port) {
        
        NSString *msg = [NSString stringWithFormat:@"create local ref failed,pid:%d",pid];
        [self.class sendMessage:msg];
        NSLog(@"%@", msg);
        //多个client同时注册同一个 pid 会导致crash.
        return;
    }
    
    if (port) {
        
        NSString *msg = [NSString stringWithFormat:@"create local ref success,pid:%d",pid];
        [self.class sendMessage:msg];
        NSLog(@"%@", msg);
    }
    
    CFRunLoopSourceRef runLoopSource = CFMessagePortCreateRunLoopSource(nil, port, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
}

- (void)unRegisterPort {
    
    if (_portListener) {
        
        CFMessagePortInvalidate(_portListener);
        CFRelease(_portListener);
    }
}

@end
