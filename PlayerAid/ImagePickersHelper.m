//
//  PlayerAid
//

#import "ImagePickersHelper.h"

@implementation ImagePickersHelper

+ (UIImagePickerController *)editableImagePickerWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.allowsEditing = YES;
  imagePicker.delegate = delegate;
  return imagePicker;
}

@end
