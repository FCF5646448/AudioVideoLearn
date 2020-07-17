//
//  Mp3Encoder.c
//  LAMEMp3Encoder
//
//  Created by 冯才凡 on 2020/7/16.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#include <stdio.h>
#import "Mp3Encoder.h"
#include "mp3_encoder.hpp"

@interface Mp3EncoderOC(){
    Mp3Encoder * mp3encoder;
}
@end

@implementation Mp3EncoderOC

-(void)encoder {
    NSString * pcmPath = [[NSBundle mainBundle] pathForResource:@"hurt" ofType:@"pcm"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDictionary = [paths objectAtIndex:0];
    NSString * mp3Path = [documentDictionary stringByAppendingPathComponent:@"vocal.mp3"];
    
    mp3encoder->Init((const char *)pcmPath, (const char *)mp3Path, 1, 2, 441000);
//    [mp3encoder ]
    
}

@end
