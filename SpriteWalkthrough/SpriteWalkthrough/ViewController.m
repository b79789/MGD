//
//  ViewController.m
//  SpriteWalkthrough
//
//  Created by Brian Stacks on 6/1/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HelloScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    HelloScene* hello = [[HelloScene alloc] initWithSize:CGSizeMake(768,1024)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: hello];
}

@end
