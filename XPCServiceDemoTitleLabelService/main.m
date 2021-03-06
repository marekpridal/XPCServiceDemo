//
//  main.m
//  XPCServiceDemoTitleLabelService
//
//  Created by Marek Přidal on 17.03.2021.
//

#import <Foundation/Foundation.h>
#import "XPCServiceDemoTitleLabelService-Swift.h"
#import "XPCServiceDemoViewControllerProtocol.h"

@interface ServiceDelegate : NSObject <NSXPCListenerDelegate>

@property (weak, nonatomic) NSXPCConnection *connection;

@end

@implementation ServiceDelegate

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    // This method is where the NSXPCListener configures, accepts, and resumes a new incoming NSXPCConnection.
    
    // Configure the connection.
    // First, set the interface that the exported object implements.
    
    NSXPCInterface * interface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCServiceDemoTitleLabelServiceProtocol)];
    [interface setClasses:[self getParameterDataTypes] forSelector:@selector(dogNamesForDogs:withReply:) argumentIndex:0 ofReply:NO];
    [interface setClasses:[self getParameterDataTypes] forSelector:@selector(setDogAgeForDogs:withReply:) argumentIndex:0 ofReply:NO];
    [interface setClasses:[self getParameterDataTypes] forSelector:@selector(setDogAgeForDogs:withReply:) argumentIndex:0 ofReply:YES];
    
    NSXPCInterface *proxyInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ProxyObjectProtocol)];
    
    [interface setInterface:proxyInterface
                forSelector:@selector(setPropertyForProxyObject:completion:)
              argumentIndex:0
                    ofReply:NO];
    
    newConnection.exportedInterface = interface;
    
    NSXPCInterface *viewControllerInteface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCServiceDemoViewControllerProtocol)];
    newConnection.remoteObjectInterface = viewControllerInteface;
    
    // Next, set the object that the connection exports. All messages sent on the connection to this service will be sent to the exported object to handle. The connection retains the exported object.
    XPCServiceDemoTitleLabelService *exportedObject = [XPCServiceDemoTitleLabelService new];
    newConnection.exportedObject = exportedObject;
    
    // Resuming the connection allows the system to deliver more incoming messages.
    [newConnection resume];
    
    self.connection = newConnection;
    
    [[self.connection remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }] connectionEstablishedWithMessage:@"Connection active and message sent from XPC service"];
    
    // Returning YES from this method tells the system that you have accepted this connection. If you want to reject the connection for some reason, call -invalidate on the connection and return NO.
    return YES;
}

- (NSSet<NSSecureCoding> *)getParameterDataTypes {
    return [NSSet setWithObjects:NSArray.class, Dog.class, nil];
}

@end

int main(int argc, const char *argv[])
{
    // Create the delegate for the service.
    ServiceDelegate *delegate = [ServiceDelegate new];
    
    // Set up the one NSXPCListener for this service. It will handle all incoming connections.
    NSXPCListener *listener = [NSXPCListener serviceListener];
    listener.delegate = delegate;
    
    // Resuming the serviceListener starts this service. This method does not return.
    [listener resume];
    return 0;
}
