//
//  Created by merowing on 09/10/2013.
//
//
//


#import <Foundation/Foundation.h>

@interface KZPropertyDescriptor : NSObject
@property(nonatomic, copy, readonly) NSString *stringMapping;
@property(nonatomic, copy, readonly) NSString *propertyName;

+ (instancetype)descriptorWithPropertyName:(NSString*)name andMapping:(NSString *)mapping;
+ (instancetype)descriptorWithPropertyName:(NSString*)name andMappings:(id)descriptors, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype)descriptorWithPropertyName:(NSString*)name selector:(SEL)selector;

- (void)addValidatonWithBlock:(NSError * (^)(id value, NSString *propertyName))validationBlock;
- (void)addValidatorWithName:(NSString *)name validation:(BOOL (^)(id value))validator;

- (NSArray *)validateValue:(id)value;
@end