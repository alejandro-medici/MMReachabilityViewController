//
//  MMReachabilityViewController.m
//  MMReachabilityViewController
//
//  Created by Manuele Maggi on 28/05/2013.
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//

#import "MMReachabilityViewController.h"
#import "Reachability.h"

#define MM_DefaultBannerHeight  44.0f
#define MM_AnimationDuration    0.5f

static Reachability *_reachability = nil;
UIView *_bannerView = nil;
BOOL _reachabilityOn;

static inline Reachability* defaultReachability () {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
#if !__has_feature(objc_arc)
        [_reachability retain];
#endif
    });
    
    return _reachability;
}

@interface MMReachabilityViewController ()
@property (nonatomic, readonly) UIView *bannerView;

- (void)startInternetReachability;
- (void)stopInternerReachability;
- (void)checkNetworkStatus;
@end

@implementation MMReachabilityViewController

- (void)dealloc {
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
    [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
}

+ (void)setBannerView:(UIView*)bannerView {
    
#if !__has_feature(objc_arc)
    [_bannerView release];
    [bannerView retain];
#endif
    
    _bannerView = bannerView;
    _bannerView.autoresizingMask = UIViewAutoresizingNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view.superview addSubview:self.bannerView];
    [self.view.superview sendSubviewToBack:self.bannerView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self startInternetReachability];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Properties overrides methods

- (UIView*)bannerView {
    
    if (!_bannerView) {
        
        UILabel *noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, MM_DefaultBannerHeight)];
        [noConnectionLabel setText:@"No internet connection!"];
        [noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
        [noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [noConnectionLabel setBackgroundColor:[UIColor yellowColor]];
        [MMReachabilityViewController setBannerView:noConnectionLabel];
        
#if !__has_feature(objc_arc)
        [noConnectionLabel release];
#endif
    }
    
    return _bannerView;
}

#pragma mark - Private methods

- (void)startInternetReachability {
    
    if (!_reachabilityOn) {
        
        _reachabilityOn = TRUE;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
        [defaultReachability() startNotifier];
    }
    
    [self checkNetworkStatus];
}

- (void)stopInternerReachability {
    
    _reachabilityOn = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)showBanner {
    
    if (self.view.frame.origin.y == 0) {
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += self.bannerView.frame.size.height;
        viewFrame.size.height -= self.bannerView.frame.size.height;
        
        [UIView animateWithDuration:MM_AnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view setFrame:viewFrame];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hideBanner {
    
    if (self.view.frame.origin.y > 0) {
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= self.bannerView.frame.size.height;
        viewFrame.size.height += self.bannerView.frame.size.height;
        
        [UIView animateWithDuration:MM_AnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view setFrame:viewFrame];
            
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)checkNetworkStatus {
    
    // called after network status changes
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
            [self performSelector:@selector(showBanner) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            break;
        }
            
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
            [self performSelector:@selector(hideBanner) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            break;
        }
            
        default:
            break;
    }
}

@end
