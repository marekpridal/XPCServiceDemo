//
//  XPCServiceDemoTitleLabelService.h
//  XPCServiceDemoTitleLabelService
//
//  Created by Marek Přidal on 17.03.2021.
//

#import <Foundation/Foundation.h>
#import "XPCServiceDemoTitleLabelServiceProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface XPCServiceDemoTitleLabelService : NSObject <XPCServiceDemoTitleLabelServiceProtocol>
@end
