//
//  ViewController.m
//  BirdyCatchv1
//
//  Created by Brian Stacks on 6/1/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "StartScene.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
        // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the  start scene.
        SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
