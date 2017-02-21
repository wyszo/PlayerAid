#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KZPropertyDescriptor+Validators.h"
#import "KZPropertyDescriptor.h"
#import "KZPropertyMapper.h"
#import "KZPropertyMapperCommon.h"
#import "KZPropertyMapperFramework.h"

FOUNDATION_EXPORT double KZPropertyMapperVersionNumber;
FOUNDATION_EXPORT const unsigned char KZPropertyMapperVersionString[];

