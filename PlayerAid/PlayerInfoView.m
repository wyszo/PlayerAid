//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "PlayerInfoView.h"

static NSString *const kNibFileName = @"PlayerInfo";


@interface PlayerInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) UIView *view;

@end

@implementation PlayerInfoView

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self xibSetup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self xibSetup];
  }
  return self;
}

- (void)xibSetup
{
  self.view = [self loadViewFromNib];
  self.view.frame = self.bounds;
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:self.view];
}

- (UIView *)loadViewFromNib
{
  NSBundle *bundle = [NSBundle mainBundle];
  UINib *nib = [UINib nibWithNibName:kNibFileName bundle:bundle];
  const NSUInteger viewIndexInXib = 0;
  NSArray *nibViews = [nib instantiateWithOwner:self options:nil];
  AssertTrueOrReturnNil(nibViews.count > viewIndexInXib);
  UIView *view = nibViews[viewIndexInXib];
  return view;
}

@end
