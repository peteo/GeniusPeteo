////  ExampleLayer.m//  CCTable////  Created by Sangwoo Im on 6/3/10.//  Copyright 2010 Sangwoo Im. All rights reserved.//#import "ScrollViewScene.h"#import "CCScrollView.h"@implementation ScrollViewScene+(id)scene {    CCScene *scene;        scene = [CCScene node];        [scene addChild:[ScrollViewScene node]];    return scene;}-(id)init {    if ((self = [super init])) {        NSAutoreleasePool *pool;        CGSize            winSize;        CCSprite          *pic;        CCScrollView      *sclView;                pool    = [NSAutoreleasePool new];				winSize = [[CCDirector sharedDirector] winSize];				/*				CCSprite * pBg     = [CCSprite spriteWithFile:@"pic.jpg" rect:CGRectMake(0, 0, winSize.width*0.5, winSize.height*0.5)];		pBg.position       = ccp(winSize.width*0.5, winSize.height*0.5);		pBg.contentSize    = CGSizeMake(winSize.width*0.5, winSize.height*0.5);		[self addChild:pBg];		        //pic     = [CCSprite spriteWithFile:@"pic.jpg"];		CCLabel  * lbl1 = [CCLabel labelWithString:@"Next" fontName:@"Helvetica" fontSize:24];		        		        sclView = [CCScrollView scrollViewWithViewSize:CGSizeMake(winSize.width*0.5, winSize.height*0.5)];		        lbl1.position          = ccp(0.0f, 0.0f);        sclView.position       = ccp(winSize.width*0.5, winSize.height*0.5);        sclView.contentOffset  = ccp(0.0f, 0.0f);				        sclView.contentSize    = CGSizeMake(winSize.width*0.5, 30);		//sclView.bounces        = NO;                [sclView addChild:lbl1];								CCLabel  * lbl2 = [CCLabel labelWithString:@"Next2" fontName:@"Helvetica" fontSize:24];		lbl2.position          = ccp(0.0f, 30.0f);				sclView.contentSize    = CGSizeMake(winSize.width*0.5, 60);		[sclView addChild:lbl2];						        [self addChild:sclView];		*/        				        pic     = [CCSprite spriteWithFile:@"pic.jpg"];        sclView = [CCScrollView scrollViewWithViewSize:CGSizeMake(winSize.width*0.5, winSize.height*0.5)];        pic.position          = ccp(0.0f, 0.0f);        sclView.position      = ccp(sclView.viewSize.width, 0.0f);        sclView.contentOffset = ccp(0.0f, 0.0f);        sclView.contentSize   = pic.contentSize;        sclView.direction     = CCScrollViewDirectionVertical;                [sclView addChild:pic];        [self addChild:sclView];        		/*        pic     = [CCSprite spriteWithFile:@"pic.jpg"];        sclView = [CCScrollView scrollViewWithViewSize:CGSizeMake(winSize.width*0.5, winSize.height*0.5)];        pic.position          = ccp(0.0f, 0.0f);        sclView.position      = ccp(0.0f, sclView.viewSize.height);        sclView.contentOffset = ccp(0.0f, 0.0f);        sclView.contentSize   = pic.contentSize;        sclView.direction     = CCScrollViewDirectionHorizontal;                [sclView addChild:pic];        [self addChild:sclView];                pic     = [CCSprite spriteWithFile:@"pic.jpg"];        sclView = [CCScrollView scrollViewWithViewSize:CGSizeMake(winSize.width*0.5, winSize.height*0.5)];        pic.position          = ccp(0.0f, 0.0f);        sclView.position      = ccp(sclView.viewSize.width, sclView.viewSize.height);        sclView.contentOffset = ccp(0.0f, 0.0f);        sclView.contentSize   = pic.contentSize;        sclView.bounces       = NO;                [sclView addChild:pic];        [self addChild:sclView];		*/				/*		sclView = [CCScrollView scrollViewWithViewSize:CGSizeMake(winSize.width*0.5, winSize.height*0.5)];		sclView.position  = ccp(100, 100);				CCLabel  * lbl1 = [CCLabel labelWithString:@"Next" fontName:@"Helvetica" fontSize:24];		lbl1.position   = ccp(0.0f, 0.0f);		[sclView addChild:lbl1];        		sclView.contentSize   = lbl1.contentSize;				[self addChild:sclView];		*/		        [pool drain];    }    return self;}@end