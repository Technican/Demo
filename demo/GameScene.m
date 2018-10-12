//
//  GameScene.m
//  myGame
//
//  Created by Sven Bayer on 13.06.18.
//  Copyright © 2018 Sven Bayer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GameScene.h"

CGFloat xPos = 0;
CGFloat yPos = 0;

float sinXPos = 0;
float sinYPos = 0;
float sinWave = 0;

float vuA = 0;
float vuB = 0;
float vuC = 0;
float vuD = 0;

float sx;
float cx;
float sy;
float cy;
float sz;
float cz;
float xy;
float xz;
float yz;
float yx;
float zx;
float zy;

float ang1;
float ang2;
float ang3;

float distance = 30;

NSInteger loop;
NSInteger maxPoints;


NSInteger textPos = 0;


NSString *textScrollerText = @"this is a old school - demo written for the ipad.....         greetings to all who nows and missing the old time.           is it over?     nope!        old school is back???            i want more........          and now it start from beginning.                                            ";
NSMutableArray *dataArray;
NSMutableArray *vectorTable;

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
	AVAudioPlayer *player;
	SKSpriteNode *vuMeterA;
	SKSpriteNode *vuMeterB;
	SKSpriteNode *vuMeterC;
	SKSpriteNode *vuMeterD;
}

- (void)sceneDidLoad {
    NSInteger maxBalls = 67;

    maxPoints = maxBalls - 1;

    NSArray *tmpArray = @[@-5,@-6,@0, @-5,@-5,@0, @-5,@-4,@0, @-5,@-3,@0,
                          @-5,@-2,@0, @-5,@-2,@0, @-5,@-1,@0, @-5,@0,@0,
                          @-5,@1,@0, @-5,@6,@0, @-5,@7,@0,  @-4,@-7,@0,
                          @-4,@-4,@0, @-4,@-1,@0, @-4,@2,@0, @-4,@2,@0,
                          @-4,@5,@0, @-4,@8,@0, @-3,@-7,@0, @-3,@-4,@0,
                          @-3,@-1,@0, @-3,@2,@0, @-3,@5,@0,
                          @-2,@-7,@0, @-2,@-4,@0, @-2,@-1,@0, @-2,@2,@0, @-2,@5,@0,
                          @-1,@-7,@0, @-1,@-6,@0, @-1,@-5,@0, @-1,@-4,@0, @-1,@-1,@0,
                          @-1,@0,@0, @-1,@1,@0, @-1,@5,@0, @-1,@7,@0, @-1,@8,@0,
                          @0,@-7,@0, @0,@-4,@0, @0,@-1,@0, @0,@5,@0, @0,@8,@0,
                          @1,@-7,@0, @1,@-4,@0, @1,@-1,@0, @1,@5,@0, @1,@8,@0,
                          @2,@-7,@0, @2,@-4,@0, @2,@-1,@0, @2,@4,@0, @2,@5,@0, @2,@8,@0,
                          @3,@-7,@0, @3,@-4,@0, @3,@-1,@0, @3,@3,@0, @3,@5,@0, @3,@8,@0,
                          @4,@-7,@0, @4,@-1,@0, @4,@0,@0, @4,@1,@0, @4,@2,@0, @4,@6,@0, @4,@7,@0];
    dataArray = [[NSMutableArray alloc]initWithArray:tmpArray];
    vectorTable = [[NSMutableArray alloc]initWithArray:tmpArray];
    // Setup your scene here
    
    // Initialize update time

    _lastUpdateTime = 0;
	yPos = 500;
	[self createTitle];
    [self createCharForScroller:@" "];
    [self createStars];

    //[self CreateVektorballs];
}

- (void)CreateVektorballs{

    NSInteger nodeDeep = 0;
    NSInteger loop = 0;

    for (int index = 0 ; index < maxPoints ; index++){
        CGFloat screenXCenter = 700;
        CGFloat screenYCenter = 386;
        SKSpriteNode *vBall;
        vBall = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bob"]];
        vBall.anchorPoint = CGPointMake(0.5, 0.5);
        float yVectorPos = [[vectorTable objectAtIndex:loop+0]floatValue];
        float xVectorPos = [[vectorTable objectAtIndex:loop+1]floatValue];
        float zVectorPos = [[vectorTable objectAtIndex:loop+2]floatValue];
        screenXCenter = screenXCenter + (xVectorPos*32);
        screenYCenter = screenYCenter + (yVectorPos*32);
        nodeDeep = zVectorPos;
        vBall.position = CGPointMake(screenYCenter,screenXCenter);
        vBall.name = @"vectorPoint";
        vBall.xScale = 1;
        vBall.yScale = 1;
        vBall.zPosition = index;
        [self addChild:vBall];
        loop = loop + 3;
    }
}
- (void)rotateVector:(float)xrot yrotation:(float)yrot zrotation:(float)zrot{
    sx = sin(xrot);
    cx = cos(yrot);
    sy = sin(yrot);
    cy = cos(yrot);
    sz = sin(zrot);
    cz = cos(zrot);
    NSInteger loop = 0;

    for (int points = 0; points < maxPoints ; points++){

        float y = [[dataArray objectAtIndex:loop+0]floatValue];
        float x = [[dataArray objectAtIndex:loop+1]floatValue];
        float z = [[dataArray objectAtIndex:loop+2]floatValue];
        
        //xrotation
        xy = cx * y - sx * z;
        xz = sx * y + cx * z;
        
        //yrotation
        yz = cy * xz - sy * x;
        yx = sy * xz + cy * x;
        
        //zrotation
        zx = cz * yx - sz * xy;
        zy = sz * yx + cz * xy;
        
        //perspective correction
        vectorTable[loop+0] = [NSNumber numberWithFloat:zy/(distance+yz)*20];
        vectorTable[loop+1] = [NSNumber numberWithFloat:zx/(distance+yz)*20];
        vectorTable[loop+2] = [NSNumber numberWithFloat:xz+zy];
        NSLog(@"%f",xz*zy);
        loop = loop + 3;
    }
}
- (void)drawVectors{
    loop = 0;
    [self enumerateChildNodesWithName:@"vectorPoint" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *vectorSprite = (SKSpriteNode *)node;
        CGFloat screenXCenter = 700;
        CGFloat screenYCenter = 386;

        float yVectorPos = [[vectorTable objectAtIndex:loop+0]floatValue];
        float xVectorPos = [[vectorTable objectAtIndex:loop+1]floatValue];
        float zVectorPos = [[vectorTable objectAtIndex:loop+2]floatValue];
        
        screenXCenter = screenXCenter + xVectorPos*32;
        screenYCenter = screenYCenter + yVectorPos*32;
        
        vectorSprite.position = CGPointMake(screenYCenter,screenXCenter);
        vectorSprite.zPosition = [[dataArray objectAtIndex:loop+2] floatValue];
        loop = loop + 3;
    }];
}
- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


-(void)update:(CFTimeInterval)currentTime {
    ang1 = ang1 + 0.01;
    ang2 = ang2 + 0.002;
    ang3 = ang3 + 0.02;

    //[self drawVectors];
   // [self rotateVector:ang1 yrotation:ang2 zrotation:ang3];

    [self moveStarLayer];
    [self moveScroller];

    vuA = [player averagePowerForChannel:0];
	vuB = [player averagePowerForChannel:1];
	[self makeVUMeters:vuA vuB:vuB];
	[player updateMeters];
  
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
	_lastUpdateTime = currentTime;
}
-(void)makeVUMeters:(float)a vuB:(float)b{
	vuMeterA.position = CGPointMake(200+a*60, 890);
	vuMeterB.position = CGPointMake(200+b*60, 920);
}
-(void)createTitle{
	vuMeterA = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"vuMeter"]];
	vuMeterA.anchorPoint = CGPointMake(0.0, 0.0);
	vuMeterA.position = CGPointMake(0,830);
	vuMeterA.name = @"title";
	vuMeterA.xScale = 1.0;
	vuMeterA.yScale = 1.0;
	vuMeterA.zPosition = 10;
	[self addChild:vuMeterA];

	vuMeterB = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"vuMeter"]];
	vuMeterB.anchorPoint = CGPointMake(0.0, 0.0);
	vuMeterB.position = CGPointMake(0,860);
	vuMeterB.name = @"title";
	vuMeterB.xScale = 1.0;
	vuMeterB.yScale = 1.0;
	vuMeterB.zPosition = 10;
	[self addChild:vuMeterB];

	SKSpriteNode *title;
	title = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"title"]];
	title.anchorPoint = CGPointMake(0.5, 0.5);
	title.position = CGPointMake(360,600);
	title.name = @"title";
	title.xScale = 1;
	title.yScale = 1;
	title.zPosition = 1;
	[self addChild:title];
	SKAction *hover = [SKAction sequence:@[
										   [SKAction moveByX:0.0 y:50.0 duration:0.1],
										   [SKAction moveByX:0.0 y:40.0 duration:0.1],
										   [SKAction moveByX:0.0 y:30.0 duration:0.1],
										   [SKAction moveByX:0.0 y:20.0 duration:0.1],
										   [SKAction moveByX:0.0 y:10.0 duration:0.1],
										   [SKAction moveByX:0.0 y:-10 duration:0.1],
										   [SKAction moveByX:0.0 y:-20 duration:0.1],
										   [SKAction moveByX:0.0 y:-30 duration:0.1],
										   [SKAction moveByX:0.0 y:-40 duration:0.1],
										   [SKAction moveByX:0.0 y:-50 duration:0.1]]];
	
    
    [title runAction: [SKAction repeatActionForever:hover]];
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
										 pathForResource:@"titleMusic"
										 ofType:@"mp3"]];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	player.numberOfLoops = -1;
	[player setMeteringEnabled:YES];
	[player play];
	
}
-(void)createCharForScroller:(NSString*)myChar{
    SKSpriteNode *scroller;
    scroller.anchorPoint = CGPointMake(0.5, 0.5);
    xPos = 900;
    if([myChar isEqualToString:@" "] 
	   || [myChar isEqualToString:@","] 
	   || [myChar isEqualToString:@":"] 
	   || [myChar isEqualToString:@";"] 
	   || [myChar isEqualToString:@"."]){
		if ([myChar isEqualToString:@" "]){
			scroller = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"empty"]];
		}
		if ([myChar isEqualToString:@","]){
			scroller = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"komma"]];
		}
		if ([myChar isEqualToString:@"."]){
			scroller = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"punkt"]];
		}
		if ([myChar isEqualToString:@":"]){
			scroller = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"doppelpunkt"]];
		}
		if ([myChar isEqualToString:@";"]){
			scroller = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"punktkomma"]];
		}
		}else{
			scroller = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:myChar]];
		}
    scroller.position = CGPointMake(xPos,yPos);
    scroller.zPosition = -10;
    scroller.name = @"scroller";
    scroller.xScale = 2.0;
    scroller.yScale = 2.0;
    [self addChild:scroller];
}
-(void)moveScroller{
    [self enumerateChildNodesWithName:@"scroller" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *myChar = (SKSpriteNode *)node;
            if (myChar.position.x < -64){
                [myChar removeFromParent];
            }
            if (myChar.position.x == 900-64){
                [self createCharForScroller:[textScrollerText substringWithRange:NSMakeRange(textPos, 1)]];
                textPos = textPos + 1;
                if(textScrollerText.length == textPos){
                    textPos = 0;
                }
            }
		sinYPos = yPos-20*(cos(myChar.position.x/100)*4);
        myChar.position = CGPointMake(myChar.position.x - 4 , sinYPos);
        }];
}
-(void)moveStarLayer{
    [self enumerateChildNodesWithName:@"//*" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *st = (SKSpriteNode *)node;
        if([node.name isEqual:@"starLayerA"]){
            if (st.position.x >768){
                st.position = CGPointMake(0,arc4random_uniform(1024));
            }
            st.position = CGPointMake(st.position.x + 1 , st.position.y);
        }
        if([node.name isEqual:@"starLayerB"]){
            if (st.position.x >768){
                st.position = CGPointMake(0,arc4random_uniform(1024));
            }
            st.position = CGPointMake(st.position.x + 2 , st.position.y);
        }
        if([node.name isEqual:@"starLayerC"]){
            if (st.position.x >768){
                st.position = CGPointMake(0,arc4random_uniform(1024));
            }
            st.position = CGPointMake(st.position.x + 3 , st.position.y);
        }
    }];
}
-(void)createStars{
	SKSpriteNode *starLayerA;
    SKSpriteNode *starLayerB;
    SKSpriteNode *starLayerC;
	for (NSInteger x=0 ; x <50; x++){
		starLayerA.anchorPoint = CGPointMake(0.5, 0.5);
		CGFloat yPos = arc4random_uniform(1024);
		CGFloat xPos = arc4random_uniform(768);
		starLayerA = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"star"]];
		starLayerA.position = CGPointMake(xPos,yPos);
		starLayerA.name = @"starLayerA";
        starLayerA.zPosition = 4;
		[self addChild:starLayerA];

        starLayerB.anchorPoint = CGPointMake(0.5, 0.5);
        yPos = arc4random_uniform(1024);
        xPos = arc4random_uniform(768);
        starLayerB = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"star"]];
        starLayerB.position = CGPointMake(xPos,yPos);
        starLayerB.name = @"starLayerB";
        starLayerB.zPosition = 4;
        [self addChild:starLayerB];

        starLayerC.anchorPoint = CGPointMake(0.5, 0.5);
        yPos = arc4random_uniform(1024);
        xPos = arc4random_uniform(768);
        starLayerC = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"star"]];
        starLayerC.position = CGPointMake(xPos,yPos);
        starLayerC.name = @"starLayerC";
        starLayerC.zPosition = 4;
        [self addChild:starLayerC];
    }
}
@end
