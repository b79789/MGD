//
//  GameData.h
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/8/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject<NSCoding>

@property (assign, nonatomic) long score;

@property (assign, nonatomic) long highScore;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;
@end
