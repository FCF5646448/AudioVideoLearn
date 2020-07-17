//
//  mp3_encoder.hpp
//  LAMEMp3Encoder
//
//  Created by 冯才凡 on 2020/7/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#ifndef mp3_encoder_hpp
#define mp3_encoder_hpp


#include <stdio.h>
#include "lame.h"

class Mp3Encoder {
private:
    FILE * pcmFile;
    FILE * mp3File;
    lame_t lameClient;
    
public:
    Mp3Encoder();
    ~Mp3Encoder();
    int Init(const char * pcmFilePath, const char * mp3FilePath, int sampleRate, int channels, int bitRate);
    void Encoder();
    void Destory();
};



#endif /* mp3_encoder_hpp */
