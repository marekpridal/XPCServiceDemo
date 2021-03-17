//
//  XPCServiceDemoSwiftServiceProtocol.h
//  XPCServiceDemoSwiftService
//
//  Created by Marek Přidal on 17.03.2021.
//

#import <Foundation/Foundation.h>

// The protocol that this service will vend as its API. This header file will also need to be visible to the process hosting the service.
@protocol XPCServiceDemoSwiftServiceProtocol

// Replace the API of this protocol with an API appropriate to the service you are vending.
- (void)upperCaseString:(nonnull NSString *)aString withReply:(void (^ _Nonnull)(NSString * _Nonnull))reply;
    
@end

/*
 To use the service from an application or other process, use NSXPCConnection to establish a connection to the service by doing something like this:

     _connectionToService = [[NSXPCConnection alloc] initWithServiceName:@"eu.marekpridal.XPCServiceDemoSwiftService"];
     _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCServiceDemoSwiftServiceProtocol)];
     [_connectionToService resume];

Once you have a connection to the service, you can use it like this:

     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello" withReply:^(NSString *aString) {
         // We have received a response. Update our text field, but do it on the main thread.
         NSLog(@"Result string was: %@", aString);
     }];

 And, when you are finished with the service, clean up the connection like this:

     [_connectionToService invalidate];
*/
