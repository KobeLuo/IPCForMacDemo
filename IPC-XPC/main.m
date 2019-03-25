//
//  main.m
//  IPC-XPC
//
//  Created by Kobe on 2019/3/25.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPC_XPCProtocol.h"
#import "IPC_XPC.h"

int main(int argc, const char *argv[])
{
    // Create the delegate for the service.
    IPC_XPC *delegate = [IPC_XPC new];
    
    // Set up the one NSXPCListener for this service. It will handle all incoming connections.
    NSXPCListener *listener = [NSXPCListener serviceListener];
    listener.delegate = delegate;
    
    // Resuming the serviceListener starts this service. This method does not return.
    [listener resume];
    return 0;
}
