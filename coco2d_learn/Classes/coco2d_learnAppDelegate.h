//
//  coco2d_learnAppDelegate.h
//  coco2d_learn
//
//  Created by Peteo on 11-8-14.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class RootViewController;

@interface coco2d_learnAppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow			*window;
	RootViewController	*viewController;
	
	CCScene				*scene;
}

@property (nonatomic, retain) UIWindow *window;

@end
