//
//  HelloWorldLayer.h
//  coco2d_learn
//
//  Created by Peteo on 11-8-14.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	CCMenuItemLabel *item1;
	CCMenuItemLabel *item2;
	CCMenuItemLabel *item3;
	CCMenuItemLabel *item4;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
