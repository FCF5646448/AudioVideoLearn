//
//  PixelBufferTool.m
//  直播客户端实现
//
//  Created by 冯才凡 on 2019/12/29.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "PixelBufferTool.h"
#include "aw_all.h"

@implementation PixelBufferTool

+ (NSData *)convertVideoSampleBufferToYuvData:(CMSampleBufferRef)videoSample {
    
    
    //先获取CVImageBufferRef数据
    //这里包含了yuv420数据的指针
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoSample);
    
    //开始操作
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    //图像宽度
    size_t pixelW = CVPixelBufferGetWidth(pixelBuffer);
    //图像高度
    size_t pixelH = CVPixelBufferGetHeight(pixelBuffer);
    //yuv中y所占字节
    size_t y_size = pixelH * pixelW;
    //yuv中uv所占字节
    size_t uv_size = y_size/2;
    
    uint8_t *yuv_frame = aw_alloc(uv_size + y_size);
    
    //
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    memcpy(yuv_frame, y_frame, y_size);
    
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    memcpy(yuv_frame + y_size, uv_frame, uv_size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return [NSData dataWithBytesNoCopy:yuv_frame
                                length:y_size + uv_size];
}

+ (NSData *)convertAudioSampleBufferToPCMData:(CMSampleBufferRef)audioSample {
    //
    NSInteger audioDataSize = CMSampleBufferGetTotalSampleSize(audioSample);
    
    int8_t *audio_data = aw_alloc((int32_t)audioDataSize);
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(audioSample);
    
    CMBlockBufferCopyDataBytes(dataBuffer, 0, audioDataSize, audio_data);
    
    return [NSData dataWithBytesNoCopy:audio_data
    length:audioDataSize];
}
@end
