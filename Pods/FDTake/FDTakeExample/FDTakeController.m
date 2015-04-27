//
//  FDTakeController.m
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import "FDTakeController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kPhotosActionSheetTag 1
#define kVideosActionSheetTag 2
#define kVideosOrPhotosActionSheetTag 3

static NSString * const kTakePhotoKey = @"takePhoto";
static NSString * const kTakeVideoKey = @"takeVideo";
static NSString * const kChooseFromLibraryKey = @"chooseFromLibrary";
static NSString * const kChooseFromPhotoRollKey = @"chooseFromPhotoRoll";
static NSString * const kCancelKey = @"cancel";
static NSString * const kNoSourcesKey = @"noSources";
static NSString * const kStringsTableName = @"FDTake";

@interface FDTakeController() <UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *sources;
@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

// Returns either optional view control for presenting or main window
- (UIViewController*)presentingViewController;

// encapsulation of actionsheet creation
- (void)_setUpActionSheet;
- (NSString*)textForButtonWithTitle:(NSString*)title;
@end

@implementation FDTakeController
@synthesize sources = _sources;
@synthesize buttonTitles = _buttonTitles;
@synthesize alertController = _alertController;
@synthesize imagePicker = _imagePicker;
@synthesize popover = _popover;
@synthesize viewControllerForPresentingImagePickerController = _viewControllerForPresenting;
@synthesize popOverPresentRect = _popOverPresentRect;

- (NSMutableArray *)sources
{
    if (!_sources) _sources = [[NSMutableArray alloc] init];
    return _sources;
}

- (NSMutableArray *)buttonTitles
{
    if (!_buttonTitles) _buttonTitles = [[NSMutableArray alloc] init];
    return _buttonTitles;
}

- (CGRect)popOverPresentRect
{
    // See https://github.com/hborders/MGSplitViewController/commit/9247c81d6b8c9ad183f67ad01384a76302ed7f0b
    if (_popOverPresentRect.size.height == 0 || _popOverPresentRect.size.width == 0)
        _popOverPresentRect = CGRectMake(0, 0, 1, 1);
    return _popOverPresentRect;
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

- (UIPopoverController *)popover
{
    if (!_popover) _popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
    return _popover;
}

- (void)takePhotoOrChooseFromLibrary
{
    self.sources = nil;
    self.buttonTitles = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kTakePhotoKey]];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kChooseFromLibraryKey]];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kChooseFromPhotoRollKey]];
    }
    [self _setUpActionSheet];
    [self.alertController.view setTag:kPhotosActionSheetTag];
}

- (void)takeVideoOrChooseFromLibrary
{
    self.sources = nil;
    self.buttonTitles = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kTakeVideoKey]];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kChooseFromLibraryKey]];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kChooseFromPhotoRollKey]];
    }
    [self _setUpActionSheet];
    [self.alertController.view setTag:kVideosActionSheetTag];
}

- (void)takePhotoOrVideoOrChooseFromLibrary
{
    self.sources = nil;
    self.buttonTitles = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kTakePhotoKey]];
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kTakeVideoKey]];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kChooseFromLibraryKey]];
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [self.buttonTitles addObject:[self textForButtonWithTitle:kChooseFromPhotoRollKey]];
    }
    [self _setUpActionSheet];
    [self.alertController.view setTag:kVideosOrPhotosActionSheetTag];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(takeController:didCancelAfterAttempting:)])
        [self.delegate takeController:self didCancelAfterAttempting:NO];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else if (originalImage) {
            imageToSave = originalImage;
        } else {
            if ([self.delegate respondsToSelector:@selector(takeController:didFailAfterAttempting:)])
                [self.delegate takeController:self didFailAfterAttempting:YES];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(takeController:gotPhoto:withInfo:)])
            [self.delegate takeController:self gotPhoto:imageToSave withInfo:info];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self.popover dismissPopoverAnimated:YES];
    }
    // Handle a movie capture
    else if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        if ([self.delegate respondsToSelector:@selector(takeController:gotVideo:withInfo:)])
            [self.delegate takeController:self gotVideo:[info objectForKey:UIImagePickerControllerMediaURL] withInfo:info];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;

    if ([self.delegate respondsToSelector:@selector(takeController:didCancelAfterAttempting:)])
        [self.delegate takeController:self didCancelAfterAttempting:YES];
}

#pragma mark - Private methods

- (UIViewController*)presentingViewController
{
    // Use optional view controller for presenting the image picker if set
    UIViewController *presentingViewController = nil;
    if (self.viewControllerForPresentingImagePickerController!=nil) {
        presentingViewController = self.viewControllerForPresentingImagePickerController;
    }
    else {
        // Otherwise do this stuff (like in original source code)
        presentingViewController = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
    return presentingViewController;
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (void)_setUpActionSheet
{
  if (self.sources.count) {
    self.alertController = [self constructAlertControllerFromButtonTitles];
    [self.presentingViewController presentViewController:self.alertController animated:YES completion:nil];
  }
  else {
    NSString *message = [self textForButtonWithTitle:kNoSourcesKey];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:nil] show];
  }
}

- (UIAlertController *)constructAlertControllerFromButtonTitles
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  for (int i=0; i < self.buttonTitles.count; i++) {
    NSString *title = self.buttonTitles[i];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [self actionSheetDidDismissWithButtonIndex:i cancelButton:NO];
    }];
    [alertController addAction:alertAction];
  }
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [self.delegate takeController:self didCancelAfterAttempting:NO];
  }];
  [alertController addAction:cancelAction];
  
  return alertController;
}

#pragma mark - ActionSheet handling

- (void)actionSheetDidDismissWithButtonIndex:(NSInteger)buttonIndex cancelButton:(BOOL)cancelButton
{
  UIViewController *aViewController = [self _topViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] ];
  
  if (!cancelButton) {
    self.imagePicker.sourceType = [[self.sources objectAtIndex:buttonIndex] integerValue];
    
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
      if (self.defaultToFrontCamera && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [self.imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
      }
    }
    
    // set the media type: photo or video
    if (self.alertController.view.tag == kPhotosActionSheetTag) {
      self.imagePicker.allowsEditing = self.allowsEditingPhoto;
      self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    } else if (self.alertController.view.tag == kVideosActionSheetTag) {
      self.imagePicker.allowsEditing = self.allowsEditingVideo;
      self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    } else if (self.alertController.view.tag == kVideosOrPhotosActionSheetTag) {
      if ([self.sources count] == 1) {
        if (buttonIndex == 0) {
          self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        }
      } else {
        if (buttonIndex == 0) {
          self.imagePicker.allowsEditing = self.allowsEditingPhoto;
          self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        } else if (buttonIndex == 1) {
          self.imagePicker.allowsEditing = self.allowsEditingVideo;
          self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        } else if (buttonIndex == 2) {
          self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        }
      }
    }
    
    if (self.isInPhotoCaptureMode) {
      if (self.presentCustomPhotoCaptureViewBlock) {
        self.presentCustomPhotoCaptureViewBlock();
        return;
      }
    }
    
    // On iPad use pop-overs.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      [self.popover presentPopoverFromRect:self.popOverPresentRect
                                    inView:aViewController.view
                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                  animated:YES];
    }
    else {
      // On iPhone use full screen presentation.
      [[self presentingViewController] presentViewController:self.imagePicker animated:YES completion:nil];
    }
    
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera && [self imagePickerSupportsOnlyMovieMediaType]) {
      if ([self.delegate respondsToSelector:@selector(takeControllerDidStartTakingVideo:withImagePickerController:)]) {
        [self.delegate takeControllerDidStartTakingVideo:self withImagePickerController:self.imagePicker];
      }
    }
  }
}

- (BOOL)isInPhotoCaptureMode
{
  return (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera && [self.imagePicker.mediaTypes containsObject:(NSString *)kUTTypeImage]);
}

- (BOOL)imagePickerSupportsOnlyMovieMediaType
{
  return ([self.imagePicker.mediaTypes containsObject:kUTTypeMovie] && ![self.imagePicker.mediaTypes containsObject:kUTTypeImage]);
}

#pragma mark - Auxiliary methods

// This is a hack required on iPad if you want to select a photo and you already have a popup on the screen
// see: http://stackoverflow.com/questions/11748845/present-more-than-one-modalview-in-appdelegate
- (UIViewController *)_topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
        return rootViewController;
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self _topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self _topViewController:presentedViewController];
}

- (NSString*)textForButtonWithTitle:(NSString*)title
{
	if ([title isEqualToString:kTakePhotoKey])
		return self.takePhotoText ?: NSLocalizedStringFromTable(kTakePhotoKey, kStringsTableName, @"Option to take photo using camera");
	else if ([title isEqualToString:kTakeVideoKey])
		return self.takeVideoText ?: NSLocalizedStringFromTable(kTakeVideoKey, kStringsTableName, @"Option to take video using camera");
	else if ([title isEqualToString:kChooseFromLibraryKey])
		return self.chooseFromLibraryText ?: NSLocalizedStringFromTable(kChooseFromLibraryKey, kStringsTableName, @"Option to select photo/video from library");
	else if ([title isEqualToString:kChooseFromPhotoRollKey])
		return self.chooseFromPhotoRollText ?: NSLocalizedStringFromTable(kChooseFromPhotoRollKey, kStringsTableName, @"Option to select photo from photo roll");
	else if ([title isEqualToString:kCancelKey])
		return self.cancelText ?: NSLocalizedStringFromTable(kCancelKey, kStringsTableName, @"Decline to proceed with operation");
	else if ([title isEqualToString:kNoSourcesKey])
		return self.noSourcesText ?: NSLocalizedStringFromTable(kNoSourcesKey, kStringsTableName, @"There are no sources available to select a photo");
	
	NSAssert(NO, @"Invalid title passed to textForButtonWithTitle:");
	
	return nil;
}

#pragma mark - UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

}

@end
