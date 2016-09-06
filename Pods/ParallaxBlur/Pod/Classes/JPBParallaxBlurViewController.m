//
//  ParallaxBlurViewController.m
//  Pods
//
//  Created by Joseph Pintozzi on 8/22/14.
//
//

#import "JPBParallaxBlurViewController.h"
#import "FXBlurView.h"

@interface JPBParallaxBlurViewController ()<UIScrollViewDelegate> {
    UIScrollView *_mainScrollView;
    UIScrollView *_backgroundScrollView;
    UIView *_floatingHeaderView;
    UIImageView *_headerImageView;
    UIImageView *_blurredImageView;
    UIColor *_headerTintColor;
    UIImage *_originalImageView;
    UIView *_scrollViewContainer;
    UIScrollView *_contentView;
    UIView *_subHeaderView;
    UIView *_headerOverscrollOverlay;
    UIView *_tintSubview;
    
    NSMutableArray *_headerOverlayViews;
}
@end

@implementation JPBParallaxBlurViewController

static CGFloat INVIS_DELTA = 50.0f;
static CGFloat BLUR_DISTANCE = 200.0f;
static CGFloat HEADER_HEIGHT = 60.0f;
static CGFloat IMAGE_HEIGHT = 320.0f;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if (_blurIterations == 0) {
        _blurIterations = 40.0f;
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    _headerOverlayViews = [NSMutableArray array];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = YES;
    _mainScrollView.alwaysBounceVertical = YES;
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainScrollView.autoresizesSubviews = YES;
    self.view = _mainScrollView;
    
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), IMAGE_HEIGHT)];
    _backgroundScrollView.scrollEnabled = NO;
    _backgroundScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _backgroundScrollView.autoresizesSubviews = YES;
    _backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backgroundScrollView.frame), CGRectGetHeight(_backgroundScrollView.frame))];
    _headerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    _headerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageTapped:)]];
    [_headerImageView setUserInteractionEnabled:YES];
    [_backgroundScrollView addSubview:_headerImageView];
    
    _blurredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backgroundScrollView.frame), CGRectGetHeight(_backgroundScrollView.frame))];
    [_blurredImageView setContentMode:UIViewContentModeScaleAspectFill];
    _blurredImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_blurredImageView setAlpha:1.0f];
    [_blurredImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageTapped:)]];
    [_blurredImageView setUserInteractionEnabled:YES];
    
    if (self.headerImageViewBackgroundColor) {
        _blurredImageView.backgroundColor = self.headerImageViewBackgroundColor;
    }
    
    _floatingHeaderView = [[UIView alloc] initWithFrame:_backgroundScrollView.frame];
    [_floatingHeaderView setBackgroundColor:[UIColor clearColor]];
    
    [_backgroundScrollView addSubview:_blurredImageView];
    
    _scrollViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backgroundScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - [self offsetHeight] )];
    _scrollViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _contentView = [self contentView];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _subHeaderView = [self subHeaderView];
    [_scrollViewContainer addSubview:_subHeaderView];
    [_scrollViewContainer addSubview:_contentView];
    
    [_mainScrollView addSubview:_backgroundScrollView];
    [_mainScrollView addSubview:_floatingHeaderView];
    [_mainScrollView addSubview:_scrollViewContainer];
}

- (void)setOverscrollOverlay:(UIView *)overlay {
    _headerOverscrollOverlay = overlay;
    overlay.frame = CGRectMake(0, 0, CGRectGetWidth(_backgroundScrollView.frame), CGRectGetHeight(_backgroundScrollView.frame));
    overlay.hidden = YES;
    [self addHeaderOverlayView:overlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_contentView setFrame:CGRectMake(0, [self subHeaderHeight], CGRectGetWidth(_scrollViewContainer.frame), CGRectGetHeight(self.view.frame) - [self offsetHeight])];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNeedsScrollViewAppearanceUpdate];
}

- (void)setNeedsScrollViewAppearanceUpdate
{
    _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _contentView.contentSize.height + CGRectGetHeight(_backgroundScrollView.frame) + [self subHeaderHeight]);
}

- (CGFloat)navBarHeight{
    if (self.navigationController && !self.navigationController.navigationBarHidden && self.navigationController.navigationBar.translucent) {
        return CGRectGetHeight(self.navigationController.navigationBar.frame);
    }
    return 0.0f;
}

- (CGFloat)offsetHeight{
    return HEADER_HEIGHT + [self navBarHeight] + [self subHeaderHeight];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = 0.0f;
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(_scrollViewContainer.frame), IMAGE_HEIGHT);
    
    CGFloat backgroundScrollViewLimit = _backgroundScrollView.frame.size.height - [self offsetHeight];
    _headerOverscrollOverlay.hidden = YES;
    
    // Here is where I do the "Zooming" image and the quick fade out the text and toolbar
    if (scrollView.contentOffset.y < 0.0f) {
        // strong swipe down (as much as possible)
        
        //calculate delta
        delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y + [self navBarHeight]));
        _backgroundScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0f, CGRectGetMinY(rect) - delta, CGRectGetWidth(_scrollViewContainer.frame) + delta, CGRectGetHeight(rect) + delta);
        [_floatingHeaderView setAlpha:(INVIS_DELTA - delta) / INVIS_DELTA];
        [_blurredImageView setAlpha:(INVIS_DELTA - delta) / INVIS_DELTA];
        
        _headerOverscrollOverlay.hidden = YES;
        
    } else {
        delta = _mainScrollView.contentOffset.y;
        
        //set alfas
        CGFloat newAlpha = 1 - ((BLUR_DISTANCE - delta)/ BLUR_DISTANCE);
        [_floatingHeaderView setAlpha:1];
        
        if (delta > backgroundScrollViewLimit) {
            [_blurredImageView setAlpha:newAlpha];
        } else {
            [_blurredImageView setAlpha:1.0];
        }
        
        // Here I check whether or not the user has scrolled passed the limit where I want to stick the header, if they have then I move the frame with the scroll view
        // to give it the sticky header look
        if (delta > backgroundScrollViewLimit) {
            // strong swipe up
            
            _backgroundScrollView.frame = (CGRect) {.origin = {0, delta - _backgroundScrollView.frame.size.height + [self offsetHeight]}, .size = {CGRectGetWidth(_scrollViewContainer.frame), IMAGE_HEIGHT}};
            _floatingHeaderView.frame = (CGRect) {.origin = {0, delta - _floatingHeaderView.frame.size.height + [self offsetHeight]}, .size = {CGRectGetWidth(_scrollViewContainer.frame), IMAGE_HEIGHT}};
            _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(_backgroundScrollView.frame) + CGRectGetHeight(_backgroundScrollView.frame)}, .size = _scrollViewContainer.frame.size };
            _contentView.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
            CGFloat contentOffsetY = -backgroundScrollViewLimit * 0.5f;
            [_backgroundScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
            
            _headerOverscrollOverlay.hidden = NO;
            _headerOverscrollOverlay.alpha = 1.0;
        }
        else {
            // light swipe up
            
            _backgroundScrollView.frame = rect;
            _floatingHeaderView.frame = rect;
            _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _scrollViewContainer.frame.size };
            [_contentView setContentOffset:(CGPoint){0,0} animated:NO];
            [_backgroundScrollView setContentOffset:CGPointMake(0, -delta * 0.5f)animated:NO];
            
            // header overscroll overlay alpha
            CGFloat edge = CGRectGetHeight(rect);
            CGFloat alpha = MAX(0, 3 * (delta - (edge/2.0)) / edge);
            
            _headerOverscrollOverlay.alpha = alpha;
            _headerOverscrollOverlay.hidden = NO;
        }
    }
}

- (UIScrollView*)contentView{
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    contentView.scrollEnabled = NO;
    return contentView;
}

- (UIView *)subHeaderView {
    UIView *subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [self subHeaderHeight])];
    subHeaderView.backgroundColor = [UIColor blueColor];
    subHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return subHeaderView;
}

- (CGFloat)subHeaderHeight {
    return 50;
}

- (void)setHeaderImage:(UIImage*)headerImage{
    _originalImageView = headerImage;
    [_headerImageView setImage:headerImage];
    
    [_blurredImageView setImage:[headerImage blurredImageWithRadius:self.blurIterations iterations:4 tintColor:nil]];
    [self setupTintSubview];
}

- (void)setupTintSubview {
    if (_tintSubview == nil && _headerTintColor != nil) {
        _tintSubview = [[UIView alloc] initWithFrame:_blurredImageView.bounds];
        _tintSubview.backgroundColor = _headerTintColor;
        _tintSubview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_blurredImageView addSubview:_tintSubview];
    }
}

- (void)addHeaderOverlayView:(UIView*)overlay{
    [_headerOverlayViews addObject:overlay];
    [_floatingHeaderView addSubview:overlay];
}

- (void)setHeaderTintColor:(UIColor *)tintColor {
    _headerTintColor = tintColor;
}

- (void)setHeaderImageViewBackgroundColor:(UIColor *)headerImageViewBackgroundColor {
    _headerImageViewBackgroundColor = headerImageViewBackgroundColor;
    _blurredImageView.backgroundColor = self.headerImageViewBackgroundColor;
}

- (CGFloat)headerHeight{
    return CGRectGetHeight(_backgroundScrollView.frame);
}

- (UIColor *)headerOverscrollBackgroundColor {
    if (!_headerOverscrollBackgroundColor) {
        _headerOverscrollBackgroundColor = [UIColor blueColor];
    }
    return _headerOverscrollBackgroundColor;
}

- (UIScrollView*)mainScrollView{
    return _mainScrollView;
}

- (void)headerImageTapped:(UITapGestureRecognizer*)tapGesture
{
    if ([self.interactionsDelegate respondsToSelector:@selector(didTapHeaderImageView:)]) {
        [self.interactionsDelegate didTapHeaderImageView:_headerImageView];
    }
}

@end
