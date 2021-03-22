//
//  Dog.h
//  XPCServiceDemo
//
//  Created by Marek Přidal on 22.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject <NSSecureCoding>

@property (nonatomic) NSString* name;
@property (nonatomic, nullable) NSNumber* age;

-(instancetype)initWithName:(NSString *)name;
-(instancetype)initWithName:(NSString *)name age:(NSNumber * _Nullable)age;

- (NSString *)formattedNameWithAge;

@end

NS_ASSUME_NONNULL_END
