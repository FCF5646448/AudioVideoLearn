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



static int rec_status = 0;
void set_status(int status) {
    rec_status = status;
}

//采集音频
void capAudio(void) {
    
    av_log_set_level(AV_LOG_DEBUG);
    
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
    
    //创建文件 "wb"表示写入二进制数据，“+”表示文件不存在就创建
    const char *out_path = "/Users/fan/Downloads/audio.pcm";
    FILE *out_file = fopen(out_path, "wb+");
    
    
    rec_status = 1;
    //读取数据
    AVPacket pkt;
    av_init_packet(&pkt);
    while ((ret = av_read_frame(fmt_ctx, &pkt)) == 0  && rec_status == 1 ) {
        av_log(NULL, AV_LOG_DEBUG,
               "pkt size is %d(%p)\n",
               pkt.size,pkt.data);
        
        //将数据写入文件中
        fwrite(pkt.data, pkt.size, 1, out_file);
        //因为写文件是先写入缓存区，但是如果断电等异常出现，则会丢失。使用fflush及时更新文件
        fflush(out_file);
        
        av_packet_unref(&pkt);
    }
    
    //关闭文件
    fclose(out_file);
    
    //释放上下文
    avformat_close_input(&fmt_ctx);
    av_log(NULL, AV_LOG_DEBUG,"finished!\n");
}

