//
//  PixelBufferTool.h
//  直播客户端实现
//
//  Created by 冯才凡 on 2019/12/29.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PixelBufferTool : NSObject

+ (NSData *)convertVideoSampleBufferToYuvData:(CMSampleBufferRef)videoSample;

+ (NSData *)convertAudioSampleBufferToPCMData:(CMSampleBufferRef)audioSample;

@end

NS_ASSUME_NONNULL_END
