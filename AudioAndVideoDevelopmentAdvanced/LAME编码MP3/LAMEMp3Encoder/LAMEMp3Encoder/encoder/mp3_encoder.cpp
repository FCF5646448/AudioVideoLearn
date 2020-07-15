//
//  mp3_encoder.cpp
//  LAMEMp3Encoder
//
//  Created by 冯才凡 on 2020/7/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#include "mp3_encoder.hpp"

//初始化 返回成功失败吧
int Mp3Encoder::Init(const char *pcmFilePath, const char *mp3FilePath, int sampleRate, int channels, int bitRate) {
    int ret = -1;
    pcmFile = fopen(pcmFilePath, "rb");
    if (pcmFile) {
        mp3File = fopen(mp3FilePath, "wb");
        if (mp3File) {
            lameClient = lame_init();
            lame_set_in_samplerate(lameClient, sampleRate);
            lame_set_out_samplerate(lameClient, sampleRate);
            lame_set_num_channels(lameClient, channels);
            lame_set_brate(lameClient, bitRate/1000);
            lame_init_params(lameClient);
            ret = 0;
        }
    }
    return ret;
}

void Mp3Encoder::Destory() {
    if (pcmFile) {
        fclose(pcmFile);
    }
    if (mp3File) {
        fclose(mp3File);
        lame_close(lameClient);
    }
}

void Mp3Encoder::Encoder() {
    int bufferSize = 1024 * 256;
    
}
