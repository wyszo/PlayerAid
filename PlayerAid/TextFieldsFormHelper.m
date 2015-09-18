//
//  PlayerAid
//

#import "TextFieldsFormHelper.h"

@interface TextFieldsFormHelper ()
@property (nonatomic, strong) NSArray *chainedTextFields;
@end

@implementation TextFieldsFormHelper

- (nullable instancetype)initWithTextFieldsToChain:(nonnull NSArray *)textfields
{
  AssertTrueOrReturnNil(textfields.count);
  
  self = [super init];
  if (self) {
    _chainedTextFields = textfields;
  }
  return self;
}

- (void)textFieldShouldReturn:(UITextField *)textField
{
  [self.chainedTextFields enumerateObjectsUsingBlock:^(UITextField *currentTextField, NSUInteger idx, BOOL *stop) {
    if (textField == currentTextField) {
      if (currentTextField != self.chainedTextFields.lastObject) {
        UITextField *nextResponder = self.chainedTextFields[idx + 1];
        [nextResponder becomeFirstResponder];
      } else {
        [currentTextField resignFirstResponder];
      }
      *stop = YES;
    }
  }];
}

@end