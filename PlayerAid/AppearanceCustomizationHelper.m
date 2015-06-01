//
//  PlayerAid
//

#import "AppearanceCustomizationHelper.h"
#import "ColorsHelper.h"
#import "TabBarHelper.h"
#import "FontsHelper.h"


static const NSUInteger kTabBarCreateTutorialItemIndex = 1; // index == 1 when there's no 'Browse' tab and 2 when 'Browse' tab is wired up
static const NSUInteger kTabBarItemCreateTutorialTag = 300;


@implementation AppearanceCustomizationHelper

#pragma mark - public

- (void)customizeApplicationAppearance
{
  [self customizeStatusBarAppearance];
  [self customizeNavigationBarsAppearance];
  [self customizeNavigationBarButtonsAppearance];
  [self customizeTabbar];
}

#pragma mark - private implementation

- (void)customizeStatusBarAppearance
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
}

- (void)customizeNavigationBarsAppearance
{
  [[UINavigationBar appearance] setBarTintColor:[ColorsHelper navigationBarColor]];
  [[UINavigationBar appearance] setTintColor:[ColorsHelper navigationBarButtonsColor]];
  
  UIFont *font = [FontsHelper navbarTitleFont];
  AssertTrueOrReturn(font);
  [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : font
                                                        }];
}

- (void)customizeNavigationBarButtonsAppearance
{
  // enabled buttons
  NSDictionary *textAttributes = [self barButtonItemsTextAttributesDictionaryWithColor:[UIColor whiteColor]];
  [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
  
  // disabled buttons
  textAttributes = [self barButtonItemsTextAttributesDictionaryWithColor:[ColorsHelper navigationBarDisabledButtonsColor]];
  [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateDisabled];
}

- (NSDictionary *)barButtonItemsTextAttributesDictionaryWithColor:(UIColor *)color
{
  UIFont *font = [FontsHelper navbarButtonsFont];
  AssertTrueOrReturnNil(color);
  AssertTrueOrReturnNil(font);
  
  return @{
           NSForegroundColorAttributeName : color,
           NSFontAttributeName : font
          };
}

- (void)customizeTabbar
{
  [self customizeTabbarFontColors];
  [self customizeTabbarTintColors];
  [self customizeTabbarItemTitles];
  [self customizeCreateTutorialTabBarButton];
}

- (void)customizeTabbarFontColors
{
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorsHelper tabBarUnselectedTextColor] } forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorsHelper tabBarSelectedTextColor] } forState:UIControlStateSelected];
}

- (void)customizeTabbarTintColors
{
  [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
  [[UITabBar appearance] setTintColor:[ColorsHelper tabBarSelectedImageTintColor]];
}

- (void)customizeTabbarItemTitles
{
  [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
  
  UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:10.0f];
  AssertTrueOrReturn(font);
  
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : font } forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : font } forState:UIControlStateSelected];
}

#pragma mark - Create Tutorial TabBar button

- (void)customizeCreateTutorialTabBarButton
{
  [self customizeCreateTutorialTabBarButtonBackground];
  [self customizeCreateTutorialTabBarButtonFont];
}

- (void)customizeCreateTutorialTabBarButtonBackground
{
  UIView *createButtonBackgroundView = [self createTutorialBackgroundView];
  
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  AssertTrueOrReturn(tabBarController);
  
  UIView *tabBarBackgroundView = [TabBarHelper tabBarControllerBackgroundView];
  if (tabBarBackgroundView) {
    [tabBarBackgroundView addSubview:createButtonBackgroundView];
  }
  else {
    [tabBarController.tabBar insertSubview:createButtonBackgroundView atIndex:0];
  }
}

- (UIView *)createTutorialBackgroundView
{
  CGRect frame = [TabBarHelper frameForTabBarItemAtIndex:kTabBarCreateTutorialItemIndex];
  AssertTrueOrReturnNil(frame.origin.x != 0);
  
  UIView *createButtonBackgroundView = [[UIView alloc] initWithFrame:frame];
  UIColor *createButtonBackgroundColor = [ColorsHelper tabBarCreateTutorialBackgroundColor];
  createButtonBackgroundView.backgroundColor = createButtonBackgroundColor;
  
  return createButtonBackgroundView;
}

- (void)customizeCreateTutorialTabBarButtonFont
{
  UITabBarItem *createTutorialTabBarItem = [TabBarHelper tabBarItemAtIndex:kTabBarCreateTutorialItemIndex];
  AssertTrueOrReturn(createTutorialTabBarItem.tag == kTabBarItemCreateTutorialTag && @"Ensure kTabBarCreateTutorialItemIndex points to create tutorial tabbar item and that the item has tag equal kTabBarItemCreateTutorialTag in interface builder");
  
  NSDictionary *attributes = @{ NSForegroundColorAttributeName : [ColorsHelper tabBarCreateTutorialTextColor] };
  
  [createTutorialTabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
  [createTutorialTabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
  
  UIImage *createTutorialOriginalImage = [[UIImage imageNamed:@"createtutorial"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  createTutorialTabBarItem.image = createTutorialOriginalImage;
  createTutorialTabBarItem.selectedImage = createTutorialOriginalImage;
}

@end
