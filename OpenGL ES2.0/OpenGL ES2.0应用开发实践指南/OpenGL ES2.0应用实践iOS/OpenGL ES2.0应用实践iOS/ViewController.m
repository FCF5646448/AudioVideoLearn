//
//  ViewController.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/11/26.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLES_VC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    OpenGLES_VC * vc = [OpenGLES_VC new];
    
    [self presentViewController:vc animated:true completion:nil];
}

@end
