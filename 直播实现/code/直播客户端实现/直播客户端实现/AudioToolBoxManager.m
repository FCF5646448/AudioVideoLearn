//
//  AudioToolBoxManager.m
//  直播客户端实现
//
//  Created by 冯才凡 on 2020/1/2.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "AudioToolBoxManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioToolBoxManager(){
    AudioComponentInstance encodingSession;
}

@property (nonatomic, assign) AudioConverterRef audioConverter;

@end

@implementation AudioToolBoxManager

//设置编码格式
- (void)setEncoderConfig:(CMSampleBufferRef)sampleBuffer {
    //输入格式设置，它是通过音频h格式的数据包来获取的。
    AudioStreamBasicDescription inAudioStreamBasicDescription = * CMAudioFormatDescriptionGetStreamBasicDescription((CMAudioFormatDescriptionRef)CMSampleBufferGetFormatDescription(sampleBuffer));
    
    //将输出描述符清0
    AudioStreamBasicDescription outAudioStreamBasicDescription = {0};
    
    //设置采样率,也是正常播放下的帧率。
    outAudioStreamBasicDescription.mSampleRate = inAudioStreamBasicDescription.mSampleRate;
    
    //设置编码格式，有kAudioFormatMEPG4AAC_HE、kAudioFormatMEPG4AAC_HE_V2、kAudioFormatMEPG4AAC
    outAudioStreamBasicDescription.mFormatID = kAudioFormatMPEG4AAC;
    //说明格式细节，无损编码，0表示没有
    outAudioStreamBasicDescription.mFormatFlags = kMPEG4Object_AAC_LC;
    
    //每个音频包帧的数量，对于未压缩的数据设置为1；动态帧率格式，这个值是比较大的固定数字，比如AAC的1024。如果是动态大小帧数设置为0；
    outAudioStreamBasicDescription.mFramesPerPacket = 1024;
   
    //每个音频包的字节数，设为0，表明包里字节数是变化的。
    outAudioStreamBasicDescription.mBytesPerPacket = 0;
    
    //每个帧的字节数。对于压缩数据，设置为0
    outAudioStreamBasicDescription.mBytesPerFrame = 0;
    
    //音频声道数
    outAudioStreamBasicDescription.mChannelsPerFrame = 1;
    
    //压缩数据，该值设置为0
    outAudioStreamBasicDescription.mBitsPerChannel = 0;
    
    //用于字节对齐，必须是0
    outAudioStreamBasicDescription.mReserved = 0;
    
    
    AudioClassDescription *description = [self getAudioClassDescriptionWithType:kAudioFormatMPEG4AAC fromManufacturee:kAppleSoftwareAudioCodecManufacturer];
    
    OSStatus status = AudioConverterNewSpecific(&inAudioStreamBasicDescription, &outAudioStreamBasicDescription, 1, description, &_audioConverter);
    
    if (status == noErr) {
        NSLog(@"EncoderConfig seccuss");
    }
    
}


//获取编码器
// type ： 编码格式
// manufacturee : 软/硬编码
- (AudioClassDescription *)getAudioClassDescriptionWithType:(UInt32)type fromManufacturee:(UInt32)manufacturee {
    static AudioClassDescription desc;
    UInt32 encoderSpecifier = type;
    OSStatus st;
    
    UInt32 size;
    st = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size);
    
    if (st == noErr) {
        
        //根据编码格式 获取描述符个数
        unsigned int count = size/sizeof(AudioClassDescription);
        //所有描述符
        AudioClassDescription descriptions[count];
        st = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, descriptions);
        
        if (st == noErr) {
            for (int i = 0; i<count; i++) {
                if (type == descriptions[i].mSubType && (manufacturee == descriptions[i].mManufacturer)) {
                    memcpy(&desc, &(descriptions[i]), sizeof(desc));
                    return &desc;
                }
            }
        }
    }
    
    return nil;
}


//




@end
