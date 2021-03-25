//
//  ProxyObjectProtocol.h
//  XPCServiceDemo
//
//  Created by Marek Přidal on 25.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProxyObjectProtocol

@property (nonatomic) NSString * stringProperty;

- (instancetype)initWithStringProperty:(NSString *)stringProperty;

@end

NS_ASSUME_NONNULL_END
