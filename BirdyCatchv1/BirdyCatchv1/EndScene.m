//
//  EndScene.m
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/9/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//
#include "StartScene.h"
#import "EndScene.h"

@interface EndScene ()
@property BOOL contentCreated;
@end
@implementation EndScene



// create content when view is initialized
- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

// create the content
- (void)createSceneContents
{
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newEndNode]];
    [self addChild: [self newEndNode2]];
}


// Start Scene that puts the start labelon scene
- (SKLabelNode *)newEndNode
{
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"BackgroundBirdyCatchv1.png"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.physicsBody.dynamic=NO;
    [self addChild:background];
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    label.name = @"gameOverNode";
    label.text = @"Game Over";
    label.fontSize = 42;
    label.fontColor=[SKColor redColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    return label;
}


- (SKLabelNode *)newEndNode2
{

    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    label.name = @"startOverNode";
    label.text = @"Start Over";
    label.fontSize = 42;
    label.fontColor=[SKColor greenColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-80);
    return label;
}

//Method that puts the action to the scene
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"startOverNode"];
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [helloNode runAction: moveSequence completion:^{
            SKScene *gameScene  = [[StartScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:gameScene transition:doors];
        }];
    }
}
@end
