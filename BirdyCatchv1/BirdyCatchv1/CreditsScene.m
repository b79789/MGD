//
//  CreditsScene.m
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/24/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "CreditsScene.h"
#import "EndScene.h"

@interface CreditsScene ()
@property BOOL contentCreated;
@end
@implementation CreditsScene


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
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(onTick:)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
    [inv setTarget: self];
    [inv setSelector:@selector(onTick:)];
    
    NSTimer *t = [NSTimer timerWithTimeInterval: 2.0
                                     invocation:inv
                                        repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: t forMode: NSDefaultRunLoopMode];
    
    
}

-(void)onTick:(NSTimer *)timer {
    //do smth
    SKScene *gameScene  = [[EndScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    [self.scene.view presentScene:gameScene transition:doors];
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
    label.text = @"Credits: Developed by Brian Stacks";
    label.fontSize = 42;
    label.fontColor=[SKColor redColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    return label;
}

-(void)goToEndScene{
    SKScene * gameOverScene = [[EndScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:gameOverScene transition:doors];
}
@end
