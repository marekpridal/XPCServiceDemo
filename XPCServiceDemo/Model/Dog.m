//
//  Dog.m
//  XPCServiceDemo
//
//  Created by Marek Přidal on 22.03.2021.
//

#import "Dog.h"

#define kDogName @"name"
#define kDogAge @"age"

@implementation Dog

-(instancetype)initWithName:(NSString *)name {
    self = [super init];
    self.name = name;
    return self;
}

-(instancetype)initWithName:(NSString *)name age:(NSNumber * _Nullable)age {
    self = [super init];
    self.name = name;
    self.age = age;
    return self;
}

+(BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.name forKey:kDogName];
    [coder encodeObject:self.age forKey:kDogAge];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    NSString *name = [coder decodeObjectOfClass:NSString.class forKey:kDogName];
    if (name == nil) {
        return nil;
    }
    return [self initWithName:name age:[coder decodeObjectOfClass:NSNumber.class forKey:kDogAge]];
}

- (NSString *)formattedNameWithAge {
    if (self.age == nil) {
        return self.name;
    }
    return [NSString stringWithFormat:@"%@ %d years", self.name, self.age.intValue];
}

@end
