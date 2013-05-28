//
//  MMReachabilityViewController.h
//  MMReachabilityViewController
//
//  Created by Manuele Maggi on 28/05/2013.
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMReachabilityViewController : UIViewController

+ (void)setBannerView:(UIView*)bannerView;

#if __has_feature(objc_arc)
- (void)dealloc;
#endif

@end
