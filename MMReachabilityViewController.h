//
//  MMReachabilityViewController.h
//  MMReachabilityViewController
//
//  Version 1.0
//
//  Created by Manuele Maggi on 28/05/2013.
//  email: manuele.maggi@gmail.com
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//
//  MMReachabilityViewController is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  MMReachabilityViewController is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with MMReachabilityViewController.  If not, see <http://www.gnu.org/licenses/>.


#import <UIKit/UIKit.h>

@interface MMReachabilityViewController : UIViewController {
    
    @protected
    UIView *_bannerView;
}

@property (nonatomic, strong) UIView *bannerView;

/**
 *  ARC forbids message send 'dealloc' so it's not possible to call [super dealloc] on subclasses, instead you can call onDealloc
 *  this will tear down all has been setted up (NSNotification observer etc...)
 */
- (void)onDealloc;

@end
