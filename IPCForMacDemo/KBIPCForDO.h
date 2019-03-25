//
//  KBIPCForDO.h
//  IPCForMacDemo
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBIPCForDOProtocol.h"
/* 相关资料链接
 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DistrObjects/Concepts/AboutDistributedObjects.html
 https://stackoverflow.com/questions/11548458/distributed-objects-in-cocoa
 https://www.mikeash.com/pyblog/friday-qa-2009-02-20-the-good-and-bad-of-distributed-objects.html
 http://cocoadevcentral.com/articles/000062.php
 */
NS_ASSUME_NONNULL_BEGIN

@interface KBIPCForDO : NSObject 

- (void)sendMessage;

@end

NS_ASSUME_NONNULL_END
