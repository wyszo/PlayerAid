//
//  PlayerAid
//

@protocol ExtendedUIImagePickerControllerDelegate;



@interface UIImagePickerExtendedEventsObserver : NSObject

@property (nonatomic, weak) id<ExtendedUIImagePickerControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<ExtendedUIImagePickerControllerDelegate>)delegate;

@end


@protocol ExtendedUIImagePickerControllerDelegate <NSObject>
@required
- (void)imagePickerControllerUserDidCaptureItem;
- (void)imagePickerControllerUserDidPressRetake;
@end
