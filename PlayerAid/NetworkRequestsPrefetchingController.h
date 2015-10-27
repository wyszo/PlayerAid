//
//  PlayerAid
//

@import Foundation;
#import <TWCommonLib/TWCommonTypes.h>


/**
 The class allows to implement requesting image from network and then pushing that request on a background queue, if the image is no longer imediately needed (to be displayed)
 */
@interface NetworkRequestsPrefetchingController : NSObject

// Makes a network request on a default queue
- (void)prefetchImageWithURLString:(nonnull NSString *)imageURLString forIndexPath:(nonnull NSIndexPath *)indexPath completion:(nullable VoidBlockWithImage)completion;

// Cancels a network requests and reschedules it onto a lower priority sequential queue
- (void)cancelFetchingImageForNetworkForIndexPath:(nonnull NSIndexPath *)indexPath;

@end
