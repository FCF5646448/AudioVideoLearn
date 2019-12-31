//
//  VideoToolBoxManager.m
//  直播客户端实现
//
//  Created by 冯才凡 on 2019/12/30.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "VideoToolBoxManager.h"
#import <VideoToolbox/VideoToolbox.h>

static NSString *const H264FilePath = @"test.h264";

@interface VideoToolBoxManager()
{
    int frameNO;//帧号
    dispatch_queue_t encodeQueue;
    VTCompressionSessionRef encodingSession;
}
@property (strong , nonatomic) NSFileHandle *h264FileHandle;
@end

@implementation VideoToolBoxManager

static VideoToolBoxManager * instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VideoToolBoxManager new];
        instance->encodeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        [instance configFilehandle];
        [instance createVideoToolBox];
        
    });
    return instance;
}

//文件
- (void)configFilehandle {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:H264FilePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    self.h264FileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    if (!self.h264FileHandle
        ) {
        NSLog(@"创建h264文件句柄失败");
    }
}

- (void)closeFileHandle {
    if (self.h264FileHandle) {
        [self.h264FileHandle closeFile];
        self.h264FileHandle = nil;
    }
}

//编码完成 c语言函数回调
void didCompressH264(void * outputCallbackRefCon,void * sourceFrameRefCon,OSStatus status,VTEncodeInfoFlags infoFlags,CMSampleBufferRef sampleBuffer) {
    NSLog(@"didCompressH264 called with status:%d infoFlags %d",status,infoFlags);
    
    if (status != 0) {
        return;
    }
    
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@" data not ready");
        return;
    }
    
    VideoToolBoxManager * instance = (__bridge VideoToolBoxManager *)outputCallbackRefCon;
    
    bool keyframe = !CFDictionaryContainsKey((CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    
    //判断当前帧是否为关键帧
    //获取sps & pps数据
    if (keyframe) {
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize,sparameterSetCount;
        const uint8_t * sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,0,&sparameterSet,&sparameterSetSize,&sparameterSetCount, 0);
        if (statusCode == noErr) {
            //获得了sps，再获取pps
            size_t pparameterSetSize,pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,1,&pparameterSet,&pparameterSetSize,&pparameterSetCount, 0);
            if (statusCode == noErr) {
                //获取SPS和PPS data
                NSData * sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                NSData * pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                
                if (instance) {
                    [instance gotSpsPps:sps pps:pps];
                }
            }
        }
    }
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length,totalLength;
    char * dataPointer;
    
    //这里获取了数据指针，和NALU的帧总长度，前4个字节里面保存
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    if (statusCodeRet == noErr) {
        size_t bufferOffset = 0;
        static const int AVCCHeaderLenght = 4;
        
        while (bufferOffset < totalLength - AVCCHeaderLenght) {
            uint32_t NALUniLenght = 0;
            //获取NALU长度
            memcpy(&NALUniLenght, dataPointer + bufferOffset, AVCCHeaderLenght);
            
            //
            NALUniLenght = CFSwapInt32BigToHost(NALUniLenght);
            
            NSData * data = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + AVCCHeaderLenght) length:NALUniLenght];
            
            [instance gotEncodedData:data];
            
            //
            bufferOffset += AVCCHeaderLenght + NALUniLenght;
        }
    }
}

//创建
- (void)createVideoToolBox {
    dispatch_sync(encodeQueue, ^{
        frameNO = 0;
        OSStatus status = VTCompressionSessionCreate(NULL,
                                                     480,
                                                     640,
                                                     kCMVideoCodecType_H264,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     didCompressH264,
                                                     (__bridge void *)(self),
                                                     &encodingSession);
        if (status == noErr) {
            //设置实时编码输出
            VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
            // ProfileLevel，h264的协议等级，不同的清晰度使用不同的ProfileLevel。
            VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel); //kVTProfileLevel_H264_Main_AutoLevel
            
            //设置关键帧间隔
            int framwInterval = 24;
            CFNumberRef frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &framwInterval);
            VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
            
            //设置期望帧率
            int fps = 24;
            CFNumberRef fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
            VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
            
            //设置码率，均值
            int bitRate = 480*640 * 3 * 4 * 8;
            CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
            VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
            
            //设置码率，上限
            int bitRateLimit = 480*640 * 3 * 4;
            CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
            VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
            
            //开始编码
            VTCompressionSessionPrepareToEncodeFrames(encodingSession);
            
        }else{
            NSLog(@"H264 session create failed");
        }
    });
}



//开始编码
- (void)encode:(CMSampleBufferRef)sampleBuffer {
    //先获取CVImageBufferRef数据
    //这里包含了yuv420数据的指针
    CVImageBufferRef pixelBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CMTime presentationTimesStamp = CMTimeMake(frameNO++, 1000);
    
    VTEncodeInfoFlags flags;
    OSStatus status = VTCompressionSessionEncodeFrame(encodingSession,
                                                      pixelBuffer,
                                                      presentationTimesStamp,
                                                      kCMTimeInvalid,
                                                      NULL,
                                                      NULL,
                                                      &flags);
    
    if (status != noErr) {
        NSLog(@"failed code:%d",status);
        //报错 failed code:-12902 这个是指level层不匹配导致的
        VTCompressionSessionInvalidate(encodingSession);
        CFRelease(encodingSession);
        encodingSession = NULL;
        return;
    }
    
     NSLog(@"EncodeFrame Success");
}

//填充sps和pps数据
- (void)gotSpsPps:(NSData *)sps pps:(NSData *)pps {
    NSLog(@"");
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;//
    NSData *byteheader = [NSData dataWithBytes:bytes length:length];
    
    //写入startCode
    [self.h264FileHandle writeData:byteheader];
    [self.h264FileHandle writeData:sps];
    
    //写入startCode
    [self.h264FileHandle writeData:byteheader];
    [self.h264FileHandle writeData:pps];
    
}

//填充nalu数据
- (void)gotEncodedData:(NSData *)data {
    if (self.h264FileHandle != nil) {
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = (sizeof bytes) - 1;//
        NSData *byteheader = [NSData dataWithBytes:bytes length:length];
        
        [self.h264FileHandle writeData:byteheader];
        [self.h264FileHandle writeData:data];
    }
}

//编码结束
- (void)endVIdeoToolBox {
    VTCompressionSessionCompleteFrames(encodingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(encodingSession);
    CFRelease(encodingSession);
    encodingSession = NULL;
}

@end
