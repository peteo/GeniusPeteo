//
//  AppController.h
//  SimpleGame
//
//  Created by Peteo on 11-9-21.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate> {
    UIWindow *window;
    RootViewController	*viewController;
}

@end

