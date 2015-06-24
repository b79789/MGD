//
//  SplashScreen.m
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/24/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "SplashScreen.h"
#import "StartScene.h"


@interface SplashScreen ()
@property BOOL contentCreated;
@end

@implementation SplashScreen


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
    [self addChild: [self newHelloNode]];
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(onTick:)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
    [inv setTarget: self];
    [inv setSelector:@selector(onTick:)];
    
    NSTimer *t = [NSTimer timerWithTimeInterval: 2.0
                                     invocation:inv
                                        repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: t forMode: NSDefaultRunLoopMode];
    /*
    // Create and configure the  start scene.
    SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
     
     */
}

-(void)onTick:(NSTimer *)timer {
    //do smth
    SKScene *gameScene  = [[StartScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    [self.scene.view presentScene:gameScene transition:doors];
}


// Start Scene that puts the start labelon scene
- (SKLabelNode *)newHelloNode
{
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"Splash.png"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.physicsBody.dynamic=NO;
    [self addChild:background];
    
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    label.name = @"helloNode";
    label.text = @"";
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    return label;
}


@end
