//
//  XPCServiceDemoTitleLabelService.m
//  XPCServiceDemoTitleLabelService
//
//  Created by Marek Přidal on 17.03.2021.
//

#import "XPCServiceDemoTitleLabelService.h"

@implementation XPCServiceDemoTitleLabelService

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
