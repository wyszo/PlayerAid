//
//  TWCommonLib
//

#ifndef TWCommonLib_TWCommonMacros_h
#define TWCommonLib_TWCommonMacros_h


#pragma mark -  Inside methods

#define CallBlock(block, ...) (block ? block(__VA_ARGS__) : nil);
#define defineWeakSelf() __weak typeof(self) weakSelf = self

#define UIColorMake(r,g,b) [UIColor colorWithRed:((CGFloat)r)/255.0 green:((CGFloat)g)/255.0 blue:((CGFloat)b)/255 alpha:1.0];
#define UIColorWithAlphaMake(r,g,b,a) [UIColor colorWithRed:((CGFloat)r)/255.0 green:((CGFloat)g)/255.0 blue:((CGFloat)b)/255 alpha:a];
#define UIFontMake(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize];

#define SuppressPerformSelectorLeakWarning(Code) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Code; \
_Pragma("clang diagnostic pop") \
} while (0)

#define NOOP ; // No operation

#define ObjectOrNull(object) ((object != nil) ? (id)(object) : (id)([NSNull null]))

/**
 Useful when we want to have selector as NSString but we still want to get an error if a selector is not implemented
 */
#define SelectorString(methodName) NSStringFromSelector(@selector(methodName))


#pragma mark - Assertions inside methods

#define NOT_IMPLEMENTED_YET_RETURN AssertTrueOrReturn(NO && @"Not implemented yet");
#define NOT_IMPLEMENTED_YET_RETURN_NIL AssertTrueOrReturnNil(NO && @"Not implemented yet");


#pragma mark - Inside class interface definition

#define NEW_AND_INIT_UNAVAILABLE + (instancetype)new __unavailable; - (instancetype)init __unavailable;
#define SHARED_INSTANCE_GENERATE_INTERFACE + (instancetype)sharedInstance;


#pragma mark - Inside class implementation

#define SHARED_INSTANCE_GENERATE_IMPLEMENTATION \
+ (instancetype)sharedInstance \
{ \
  static id sharedInstance = nil; \
  static dispatch_once_t onceToken; \
  dispatch_once(&onceToken, ^{ \
    sharedInstance = [[self alloc] init]; \
  }); \
  return sharedInstance; \
}


#endif
