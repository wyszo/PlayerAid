//
//  ParallaxBlurViewController.h
//  Pods
//
//  Created by Joseph Pintozzi on 8/22/14.
//
//

#import <UIKit/UIKit.h>

@protocol JPBParallaxBlurInteractionsDelegate;

@interface JPBParallaxBlurViewController : UIViewController

@property (nonatomic, assign) CGFloat blurIterations;
@property (nonatomic, assign) UIColor *headerOverscrollBackgroundColor;
@property (nonatomic, assign) UIColor *headerImageViewBackgroundColor;

- (void)setHeaderImage:(UIImage*)headerImage;
- (void)addHeaderOverlayView:(UIView*)overlay;
- (void)setHeaderTintColor:(UIColor *)tintColor;
- (void)setOverscrollOverlay:(UIView *)overlay;
- (CGFloat)headerHeight;
- (UIScrollView*)mainScrollView;

// overridable
- (UIView *)subHeaderView;
- (CGFloat)subHeaderHeight;

/**
 *  This should be called whenever the content size of the scrollview need to be adjusted.
 */
- (void)setNeedsScrollViewAppearanceUpdate;

@property (weak, nonatomic, readwrite) id <JPBParallaxBlurInteractionsDelegate> interactionsDelegate;

@end

///-------------------------------------------------------------------------------------------------------
/// Interactions Delegate
///-------------------------------------------------------------------------------------------------------

@protocol JPBParallaxBlurInteractionsDelegate <NSObject>

@optional

/**
 Called when the header imageview is tapped.
 */
- (void)didTapHeaderImageView:(UIImageView*)imageView;

@end
