//
//  ViewController.m
//  LAMEMp3Encoder
//
//  Created by 冯才凡 on 2020/7/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "Mp3Encoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Mp3EncoderOC new].encoder;
}


@end
