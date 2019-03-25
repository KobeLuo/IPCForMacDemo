//
//  KBIPCForDOProtocol.h
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#ifndef KBIPCForDOProtocol_h
#define KBIPCForDOProtocol_h

#define RegistName @"www.koebluo.com.IPC-DO"

@protocol DOProtocol <NSObject>

- (NSArray *)objects;

@end

#endif /* KBIPCForDOProtocol_h */
