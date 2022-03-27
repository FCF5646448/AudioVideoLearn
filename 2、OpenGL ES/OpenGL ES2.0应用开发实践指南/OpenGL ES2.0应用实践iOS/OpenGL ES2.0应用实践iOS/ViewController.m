//
//  ViewController.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/11/26.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLES_VC.h"
#import "OpenGL_ES_VC02.h"
#import "OpenGL_ES_VC03.h"
#import "OpenGL_ES_VC04.h"
#import "OpenGL_ES_VC05.h"
#import "OpenGL_ES_VC06.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    OpenGL_ES_VC06 * vc = [OpenGL_ES_VC06 new];
    
    [self presentViewController:vc animated:true completion:nil];
}

@end
