//
//  StartScene.m
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/2/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "StartScene.h"
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface StartScene ()
@property BOOL contentCreated;
@end

@implementation StartScene

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
    [self addChild: [self newHelloNode]];
}


// Start Scene that puts the start labelon scene
- (SKLabelNode *)newHelloNode
{
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"BackgroundBirdyCatchv1.png"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.physicsBody.dynamic=NO;
    [self addChild:background];
    


    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    label.name = @"helloNode";
    label.text = @"Start Game";
    label.fontSize = 42;
    label.fontColor=[SKColor blackColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    SKLabelNode *b = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    b.fontSize = 30;
    b.fontColor = [SKColor blackColor];
    b.text=@"Touch the spot you want to shoot and catch the birds";
    b.position=CGPointMake(label.position.x, label.position.y + 100);
    [self addChild:b];
    
    return label;
}


//Method that puts the action to the scene
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
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
            SKScene *gameScene  = [[GameScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
            [self.scene.view presentScene:gameScene transition:doors];
        }];
    }
}
@end
