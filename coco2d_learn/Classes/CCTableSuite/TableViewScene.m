////  TableViewScene.m//  CCTable////  Created by Sangwoo Im on 6/4/10.//  Copyright 2010 Sangwoo Im. All rights reserved.//#import "TableViewScene.h"#import "MyCell.h"#import "MyDoubleSizedCell.h"#import "CCTableViewCell.h"#import "CCMultiColumnTableView.h"@implementation TableViewScene+(id)scene {    CCScene *scene;    scene = [CCScene node];    [scene addChild:[TableViewScene node]];    return scene;}-(id)init {    if ((self = [super init])) {        NSAutoreleasePool *pool;        CGSize            winSize, cSize;                pool    = [NSAutoreleasePool new];        cSize   = [MyCell cellSize];        winSize = [[CCDirector sharedDirector] winSize];         hTable  = [[CCTableView tableViewWithDataSource:self size:CGSizeMake(winSize.width, cSize.height)] retain];        vTable  = [[CCTableView tableViewWithDataSource:self size:CGSizeMake(cSize.width, winSize.height-cSize.height)] retain];        mhTable = [[CCMultiColumnTableView tableViewWithDataSource:self size:CGSizeMake(cSize.width * 2, cSize.height * 2)] retain];        mvTable = [[CCMultiColumnTableView tableViewWithDataSource:self size:CGSizeMake(cSize.width * 2, cSize.height * 2)] retain];        mbTable = [[CCMultiColumnTableView tableViewWithDataSource:self size:[MyDoubleSizedCell cellSize]] retain];                hTable.direction  = mhTable.direction = CCScrollViewDirectionHorizontal;        vTable.direction  = mvTable.direction = CCScrollViewDirectionVertical;        mbTable.direction = CCScrollViewDirectionBoth;                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cell.plist"];                hTable.position  = ccp(0.0, 0.0);        vTable.position  = ccp(0.0, cSize.height);        mhTable.position = ccp(cSize.width, cSize.height);        mvTable.position = ccp(cSize.width + mhTable.viewSize.width, cSize.height);        mbTable.position = ccp(cSize.width + mhTable.viewSize.width + mvTable.viewSize.width, cSize.height);        hTable.tDelegate = vTable.tDelegate = mhTable.tDelegate = mvTable.tDelegate = mbTable.tDelegate = self;        mbTable.colCount = 2;                [self addChild:hTable];        [self addChild:vTable];        [self addChild:mvTable];        [self addChild:mhTable];        [self addChild:mbTable];                [hTable reloadData];        [vTable reloadData];        [mvTable reloadData];        [mhTable reloadData];        [mbTable reloadData];		        [pool drain];    }    return self;}#pragma mark -#pragma mark TableView Delegate-(void)table:(CCTableView *)table cellTouched:(CCTableViewCell *)cell {    //CCLog(@"cell touched at index: %i", cell.idx);}#pragma mark -#pragma mark TableView DataSource-(Class)cellClassForTable:(CCTableView *)table {    if (table == mbTable) {        return [MyDoubleSizedCell class];    }    return [MyCell class];}-(CCTableViewCell *)table:(CCTableView *)table cellAtIndex:(NSUInteger)idx {    CCTableViewCell *cell;    NSString        *spriteName;    CCSprite        *sprite;        cell       = [table dequeueCell];    spriteName = [NSString stringWithFormat:@"cell%i.png", idx%10];    sprite     = [CCSprite spriteWithSpriteFrameName:spriteName];    if (!cell) {        if (table == mbTable) {            cell = [[MyDoubleSizedCell new] autorelease];        } else {            cell = [[MyCell new] autorelease];        }    }    cell.node = sprite;         if (table == mbTable) {        sprite.scale = 2;    }        return cell;}-(NSUInteger)numberOfCellsInTableView:(CCTableView *)table {    return 20;}-(void) dealloc {    [mbTable release];    [hTable  release];    [vTable  release];    [mhTable release];    [mvTable release];    [super   dealloc];    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];}@end