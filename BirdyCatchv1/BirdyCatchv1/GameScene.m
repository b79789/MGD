//
//  GameScene.m
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/2/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "GameScene.h"
@import AVFoundation;


@interface GameScene ()<SKPhysicsContactDelegate>
@property BOOL contentCreated;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

@implementation GameScene
{
    SKSpriteNode *birdy;    //1
    SKSpriteNode *birdy2;    //2
    SKSpriteNode *birdy3;    //3
    SKSpriteNode *hunter;    //4
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor cyanColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"backgroundMusic" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];

    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudyBG.jpg"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.physicsBody.dynamic=NO;
    [self addChild:background];
    SKSpriteNode* ground = [SKSpriteNode spriteNodeWithImageNamed:@"green_grass.jpg"];
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, ground.size.height);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, ground.size.height * 2)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    self->hunter = [SKSpriteNode spriteNodeWithImageNamed:@"hunter.png"];
    self->hunter.position = CGPointMake(100, 100);
    [self addChild:self->hunter];
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    
  /*
    birdy = [self newBirdy];
    birdy.name=@"birdy1";
    birdy.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame)-150);
    birdy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:birdy.size.height];
    birdy.physicsBody.dynamic = YES;
    birdy.physicsBody.allowsRotation = NO;
    
    [self addChild:birdy];
    birdy2 = [self newBirdy];
    birdy2.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame)-50);
    birdy2.color = [SKColor redColor];
    birdy2.colorBlendFactor = 0.5;
    [self addChild:birdy2];
    birdy3 = [self newBirdy];
    birdy3.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame)-250);
    birdy3.color = [SKColor blueColor];
    birdy3.colorBlendFactor = 0.5;
    [self addChild:birdy3];
    
   */
}

- (SKSpriteNode *)newBirdy
{
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed:@"birdy_green.png"];
    
    bird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bird.size];
    bird.physicsBody.dynamic = NO;
    
    return bird;
}

- (void)addBirdy {
    
    // Create sprite
    birdy = [SKSpriteNode spriteNodeWithImageNamed:@"birdy_green.png"];
    birdy.name=@"birdy1";
    birdy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:birdy.size]; // 1
    birdy.physicsBody.dynamic = YES; // 2
    birdy.physicsBody.categoryBitMask = monsterCategory; // 3
    birdy.physicsBody.contactTestBitMask = projectileCategory; // 4
    birdy.physicsBody.collisionBitMask = 0; // 5
    // Determine where to spawn the monster along the Y axis
    int minY = birdy.size.height / 2;
    int maxY = self.frame.size.height - birdy.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    birdy.position = CGPointMake(self.frame.size.width + birdy.size.width/2, actualY);
    [self addChild:birdy];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-birdy.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [birdy runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    [self runAction:[SKAction playSoundFileNamed:@"bulletSound.mp3" waitForCompletion:NO]];
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // 2 - Set up initial location of projectile
    SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"webbing.png"];
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = monsterCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    projectile.position = self->hunter.position;
    
    // 3- Determine offset of location to projectile
    CGPoint offset = rwSub(location, projectile.position);
    
    // 4 - Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // 5 - OK to add now - we've double checked position
    [self addChild:projectile];
    
    // 6 - Get the direction of where to shoot
    CGPoint direction = rwNormalize(offset);
    
    // 7 - Make it shoot far enough to be guaranteed off screen
    CGPoint shootAmount = rwMult(direction, 1000);
    
    // 8 - Add the shoot amount to the current position
    CGPoint realDest = rwAdd(shootAmount, projectile.position);
    
    // 9 - Create the actions
    float velocity = 480.0/1.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    /*
    SKNode *helloNode = [self childNodeWithName:@"birdy1"];
    if (helloNode != nil)
    {
        SKAction *moveNodeRight = [SKAction moveByX:1000 y:0.0 duration:15.0];
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, moveNodeRight]];
        [helloNode runAction: moveSequence completion:^{
            NSLog(@"done");
        }];
    }
     
     */
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)bird {
    NSLog(@"Hit");
    [self runAction:[SKAction playSoundFileNamed:@"contact.mp3" waitForCompletion:NO]];
    [projectile removeFromParent];
    [bird removeFromParent];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addBirdy];
    }
}


- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

@end