//
//  GameScene.h
//  myGame
//
//  Created by Sven Bayer on 13.06.18.
//  Copyright © 2018 Sven Bayer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;


@end
