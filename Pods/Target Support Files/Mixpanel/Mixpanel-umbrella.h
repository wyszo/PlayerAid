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

#import "Mixpanel.h"
#import "MPAbstractABTestDesignerMessage.h"
#import "MPABTestDesignerChangeRequestMessage.h"
#import "MPABTestDesignerChangeResponseMessage.h"
#import "MPABTestDesignerClearRequestMessage.h"
#import "MPABTestDesignerClearResponseMessage.h"
#import "MPABTestDesignerConnection.h"
#import "MPABTestDesignerDeviceInfoRequestMessage.h"
#import "MPABTestDesignerDeviceInfoResponseMessage.h"
#import "MPABTestDesignerDisconnectMessage.h"
#import "MPABTestDesignerMessage.h"
#import "MPABTestDesignerSnapshotRequestMessage.h"
#import "MPABTestDesignerSnapshotResponseMessage.h"
#import "MPABTestDesignerTweakRequestMessage.h"
#import "MPABTestDesignerTweakResponseMessage.h"
#import "MPApplicationStateSerializer.h"
#import "MPClassDescription.h"
#import "MPDesignerEventBindingMessage.h"
#import "MPDesignerSessionCollection.h"
#import "MPEnumDescription.h"
#import "MPEventBinding.h"
#import "MPLogger.h"
#import "MPNotification.h"
#import "MPNotificationViewController.h"
#import "MPObjectIdentifierProvider.h"
#import "MPObjectIdentityProvider.h"
#import "MPObjectSelector.h"
#import "MPObjectSerializer.h"
#import "MPObjectSerializerConfig.h"
#import "MPObjectSerializerContext.h"
#import "MPPropertyDescription.h"
#import "MPSequenceGenerator.h"
#import "MPSurvey.h"
#import "MPSurveyNavigationController.h"
#import "MPSurveyQuestion.h"
#import "MPSurveyQuestionViewController.h"
#import "MPSwizzler.h"
#import "MPTweak.h"
#import "MPTweakInline.h"
#import "MPTweakInlineInternal.h"
#import "MPTweakStore.h"
#import "MPTypeDescription.h"
#import "MPUIControlBinding.h"
#import "MPUITableViewBinding.h"
#import "MPValueTransformers.h"
#import "MPVariant.h"
#import "MPWebSocket.h"
#import "NSData+MPBase64.h"
#import "NSInvocation+MPHelpers.h"
#import "UIColor+MPColor.h"
#import "UIImage+MPAverageColor.h"
#import "UIImage+MPImageEffects.h"
#import "UIView+MPHelpers.h"
#import "_MPTweakBindObserver.h"

FOUNDATION_EXPORT double MixpanelVersionNumber;
FOUNDATION_EXPORT const unsigned char MixpanelVersionString[];

