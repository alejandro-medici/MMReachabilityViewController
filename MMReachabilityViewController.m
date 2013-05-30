//
//  MMReachabilityViewController.m
//  MMReachabilityViewController
//
//  Version 1.0
//
//  Created by Manuele Maggi on 28/05/2013.
//  email: manuele.maggi@gmail.com
//  Copyright (c) 2013-present Manuele Maggi. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "MMReachabilityViewController.h"
#import "Reachability.h"

#define MM_DefaultBannerHeight  36.0f
#define MM_AnimationDuration    0.5f

@interface MMView : UIView

@property (atomic, assign) BOOL animating;

- (id)initWithView:(UIView*)view;
@end

@implementation MMView

@synthesize animating;

- (id)initWithView:(UIView *)view {
    
    self = [super initWithFrame:view.frame];
    if (self) {
        
        self.alpha = view.alpha;
        self.autoresizesSubviews = view.autoresizesSubviews;
        self.autoresizingMask = view.autoresizingMask;
        self.backgroundColor = view.backgroundColor;
        self.clearsContextBeforeDrawing = view.clearsContextBeforeDrawing;
        self.clipsToBounds = view.clipsToBounds;
        self.contentMode = view.contentMode;
        self.contentScaleFactor = view.contentScaleFactor;
        self.exclusiveTouch = view.exclusiveTouch;
        self.hidden = view.hidden;
        self.multipleTouchEnabled = view.multipleTouchEnabled;
        self.opaque = view.opaque;
        self.restorationIdentifier = view.restorationIdentifier;
        self.tag = view.tag;
        self.transform = view.transform;
        self.userInteractionEnabled = view.userInteractionEnabled;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    if (!self.animating && self.frame.origin.y >= 0) {
        frame.origin.y = self.frame.origin.y;
    }
    
    [super setFrame:frame];
}

@end

static Reachability *_reachability = nil;
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

- (void)startInternetReachability;
- (void)stopInternerReachability;
- (void)checkNetworkStatus;
@end

@implementation MMReachabilityViewController {
    
    BOOL _loaded;
}

@synthesize bannerView = _bannerView;
@synthesize mode = _mode;
@synthesize visibilityTime;

- (void)dealloc {
    
    [self onDealloc];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loaded = TRUE;
    
    [self.bannerView setHidden:YES];

    switch (self.mode) {
            
        case MMReachabilityModeOverlay:
        {
            CGRect bannerFrame = self.bannerView.frame;
            bannerFrame.origin.y = -self.bannerView.frame.size.height;
            [self.bannerView setFrame:bannerFrame];
            break;
        }
            
        default:
        case MMReachabilityModeResize:
        {
            // replace the view controller view with an MMView
            MMView *view = [[MMView alloc] initWithView:self.view];
            NSArray *subviews = [self.view subviews];
            for (UIView *subview in subviews) {
                [view addSubview:subview];
            }
            
            [self setView:view];
            
#if !__has_feature(objc_arc)
            [view release];
#endif
            break;
        }
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.bannerView.superview == nil) {
        
        switch (self.mode) {
                
            case MMReachabilityModeOverlay:
            {
                [self.view addSubview:self.bannerView];
                [self.view bringSubviewToFront:self.bannerView];
                break;
            }
            default:
            case MMReachabilityModeResize:
                [self.view.superview addSubview:self.bannerView];
                [self.view.superview sendSubviewToBack:self.bannerView];
                break;
        }
    }
    
    //  the banner view is added after the viewDidLoad
    //  so we need to adjust the width in case of rotated interface
    CGRect bannerFrame = self.bannerView.frame;
    bannerFrame.size.width = self.view.frame.size.width;
    [self.bannerView setFrame:bannerFrame];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self startInternetReachability];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Public interface

- (void)onDealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancel];
}

#pragma mark - Properties overrides methods

- (UIView*)bannerView {
    
    if (!_bannerView) {
        
        UILabel *noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, MM_DefaultBannerHeight)];
        [noConnectionLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [noConnectionLabel setTextColor:[UIColor whiteColor]];
        [noConnectionLabel setShadowColor:[UIColor blackColor]];
        [noConnectionLabel setText:@"No internet connection!"];
        [noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
        [noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [noConnectionLabel setBackgroundColor:[UIColor redColor]];
        [noConnectionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self setBannerView:noConnectionLabel];
        
#if !__has_feature(objc_arc)
        [noConnectionLabel release];
#endif
    }
    
    return _bannerView;
}

- (void)setBannerView:(UIView*)bannerView {
    
#if !__has_feature(objc_arc)
    [_bannerView release];
    [bannerView retain];
#endif
    
    _bannerView = bannerView;
}

- (void)setMode:(MMReachabilityMode)mode {
    
    if (!_loaded) {
        _mode = mode;
    }
}

#pragma mark - Private methods

- (void)startInternetReachability {
    
    if (!_reachabilityOn) {
        _reachabilityOn = TRUE;
        [defaultReachability() startNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    [self checkNetworkStatus];
}

- (void)stopInternerReachability {
    
    _reachabilityOn = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)showBanner {
    
    CGRect viewFrame;
    UIView *view = nil;
    
    switch (self.mode) {
            
        default:
        case MMReachabilityModeResize:
        {
            view = self.view;
            if (view.frame.origin.y == 0) {
                
                ((MMView*)view).animating = TRUE;
                
                viewFrame = self.view.frame;
                viewFrame.origin.y += self.bannerView.frame.size.height;
                viewFrame.size.height -= self.bannerView.frame.size.height;
            }
            else
                return;
            break;
        }
            
        case MMReachabilityModeOverlay:
        {
            view = self.bannerView;

            if (view.frame.origin.y == -view.frame.size.height) {
                
                viewFrame = view.frame;
                viewFrame.origin.y += view.frame.size.height;
                
                [self.view bringSubviewToFront:view];
            }
            else
                return;
            break;
        }
    }
    
    [self.bannerView setHidden:NO];
    
    [UIView animateWithDuration:MM_AnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [view setFrame:viewFrame];
                     }
                     completion:^(BOOL finished) {
                         
                         if (self.mode == MMReachabilityModeResize) {
                             ((MMView*)self.view).animating = FALSE;
                         }
                         
                         if (self.visibilityTime > 0) {
                             [self cancel];
                             [self performSelector:@selector(hideBanner) withObject:nil afterDelay:self.visibilityTime];
                         }
                     }];
}

- (void)hideBanner {
    
    CGRect viewFrame;
    UIView *view = nil;
    
    switch (self.mode) {
            
        default:
        case MMReachabilityModeResize:
        {
            view = self.view;
            if (view.frame.origin.y > 0) {
                
                ((MMView*)view).animating = TRUE;
                viewFrame = self.view.frame;
                viewFrame.origin.y -= self.bannerView.frame.size.height;
                viewFrame.size.height += self.bannerView.frame.size.height;
            }
            else
                return;
            break;
        }
            
        case MMReachabilityModeOverlay:
        {
            view = self.bannerView;
            if (view.frame.origin.y > -view.frame.size.height) {
                
                viewFrame = self.bannerView.frame;
                viewFrame.origin.y = -view.frame.size.height;
            }
            else
                return;
            break;
        }
    }
    
    [UIView animateWithDuration:MM_AnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [view setFrame:viewFrame];
                     }
                     completion:^(BOOL finished) {
                         
                         [self.bannerView setHidden:YES];

                         if (self.mode == MMReachabilityModeResize) {
                             ((MMView*)self.view).animating = FALSE;
                         }
                     }];

}

- (void)checkNetworkStatus {
    
    // called after network status changes
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            
            [self cancel];
            [self performSelector:@selector(showBanner) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            break;
        }
            
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            
            [self cancel];
            [self performSelector:@selector(hideBanner) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            break;
        }
            
        default:
            break;
    }
}

- (void)cancel {
    
    [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
    [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
}

@end
