//
//  KBIPCForDO.m
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "KBIPCForDO.h"

@interface KBIPCForDO() {
    
    NSConnection *_connection;
}
@end

@implementation KBIPCForDO

- (void)sendMessage {
    
    NSArray *objects = @[@"First",@"Second"];
    //connection必须被对象持有，一旦成为野指针，接收方将引发SIGSTOP信号错误。
    _connection = [NSConnection connectionWithReceivePort:[NSPort port] sendPort:nil];
    [_connection setRootObject:objects];
    [_connection registerName:RegistName];
    
//    id proxy = [NSConnection rootProxyForConnectionWithRegisteredName:RegistName host:nil];
//    NSLog(@"%@",proxy.objects);
}

@end
