MMReachabilityViewController
============================

A UIViewController subclass that using the apple reachability show a 'missing internet connection' content automatically adjusting the content or overlaying the view owned by the controller

**DEPENDENCIES:**

The only external source that you need to compile "MMReachabilityViewController" is the Apple Reachability, the recommended version is V 2.2 provided in this repo.

**INSTALL:**

Import MMReachabilityViewController (.h .m) in your project and the Apple Reachability if not yet imported.

**HOW TO USE:**

1.	Create your view controllers as subclass of MMReachabilityViewController. 

2.	Before the view owned by the view controller will be loaded: chose a 'mode', MMReachabilityModeOverlay or MMReachabilityModeResize, 
	and assign a view for the banner if you want a custom one, the should have the same width of the view of the viewcontroller, 
	and could be resized to support device orientation.
	
	    ExampleViewController *reachabilityVC = [[[ExampleViewController alloc] initWithNibName:@"ExampleViewController" bundle:nil] autorelease];
		reachabilityVC.mode = MMReachabilityModeOverlay;
	
3. 	Chose and assign a visibility time, values equal or minus than 0 make the banner permanent for the time that there is no connection,
	positive values represent the number of seconds that the banner will be visible when the connection status change to no internet connection.
	This value can be assigned later and changed after the first time, but it's better decide before the view appear, to have a consistent behaviour.
	
    	reachabilityVC.visibilityTime = 3.0;
	
4.	ARC forbids message send 'dealloc' so it's not possible to call [super dealloc] on subclasses, instead you have to call onDealloc,
	this will tear down all has been setted up (NSNotification observer etc...)
	
	Only ARC projects:
	
		- (void)dealloc {
		
			[self onDealloc];
			
			// your code for a specific reason
			...
		}
		
	you don't need to do that if it's not needed to overwrite the dealloc for a specific reason
	
	Not ARC projects:
	
		- (void)dealloc {
		
			[super dealloc];
			
			// your code for a specific reason
			...
			
			// release your stuff
			...
		}
		
	as usual on not ARC projects.
	
**CUSTOMISE THE BANNER VIEW:**

You can customise the bannerView in this way:

1.	Create a view that you want to use and assign it to the property bannerView:

        UILabel *noConnectionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(reachabilityVC.view.frame.origin.x, 0.0, reachabilityVC.view.frame.size.width, 36.0)] autorelease];
        [noConnectionLabel setText:@"No internet connection!"];
        [noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
        [noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [noConnectionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
       
       	reachabilityVC.bannerView = noConnectionLabel;
       	
2.	Overwrite the bannerView property getter method in your MMReachabilityViewController subclass:

		- (UIView*)bannerView {
    
    		if (!_bannerView) {
    			
    			UILabel *noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(reachabilityVC.view.frame.origin.x, 0.0, reachabilityVC.view.frame.size.width, 36.0)];
        		[noConnectionLabel setText:@"No internet connection!"];
        		[noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
        		[noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        		[noConnectionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        		
        		_bannerView = noConnectionLabel;
    		}
    		
    		return _bannerView;
		}
		
Into the TestProject you can find a nicer implementation of a custom banner view with gradient background text color etc...
