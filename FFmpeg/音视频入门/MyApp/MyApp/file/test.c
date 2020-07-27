//
//  test.c
//  MyApp
//
//  Created by 冯才凡 on 2020/7/27.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#include "test.h"
//工具
#include "libavutil/avutil.h"
//设备
#include "libavdevice/avdevice.h"
//格式
#include "libavformat/avformat.h"




void test(void) {
    
    av_log_set_level(AV_LOG_DEBUG);
    av_log(NULL, AV_LOG_DEBUG, "hello ffmpeg！\n");
    
    printf("hello world!\n");
}

//采集音频
void capAudio(void) {
    //1、注册设备
    avdevice_register_all();
    
    //2、设计采集方式，mac下使用AVFoundation，window使用dshow，linux使用alsa
    AVInputFormat * fmt = av_find_input_format("avfoundation");
    
    //3、打开音频设备
    /*
     AVFormatContext **ps 上下文
     const char *url : 输入地址，可以是硬件设备。 [[video device]:[audio devece]] : [] 表示可选，0表示设备下标。
     AVDictionary **options : 打开解码的参数。
     */
    AVFormatContext *fmt_ctx = NULL;
    char *deviceName = ":0";
    AVDictionary *options = NULL;
    int ret = avformat_open_input(&fmt_ctx, deviceName, fmt, &options);
    char errbuf[1024];
    if (ret < 0) {
        av_strerror(ret, errbuf, 1024);
        printf("Failt to open device : [%d:%s]\n",ret,errbuf);
        return;
    }
    
    printf("file:%s, size:%d",fmt_ctx->url,fmt_ctx->packet_size);
    
    
    //
    
}
