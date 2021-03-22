//
//  Dog.m
//  XPCServiceDemo
//
//  Created by Marek Přidal on 22.03.2021.
//

#import "Dog.h"

#define kDogName @"name"

@implementation Dog

-(instancetype)initWithName:(NSString *)name {
    self = [super init];
    self.name = name;
    return self;
}

+(BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.name forKey:kDogName];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    NSString *name = [coder decodeObjectOfClass:NSString.class forKey:kDogName];
    if (name == nil) {
        return nil;
    }
    return [self initWithName:name];
}

@end
