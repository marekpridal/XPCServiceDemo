//
//  ProxyObjectModel.m
//  XPCServiceDemo
//
//  Created by Marek Přidal on 25.03.2021.
//

#import "ProxyObjectModel.h"

@implementation ProxyObjectModel

@synthesize stringProperty;

- (nonnull instancetype)initWithStringProperty:(nonnull NSString *)stringProperty {
    self = [super init];
    self.stringProperty = stringProperty;
    return self;
}

@end
