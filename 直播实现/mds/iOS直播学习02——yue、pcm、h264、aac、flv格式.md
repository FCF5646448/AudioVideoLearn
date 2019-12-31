#### 格式说明
本文解决一个问题：直播过程中，整个客户端使用什么格式，以及为什么使用这种格式？

#### 视频编码说明
视频编码又分为软编码和硬编码
* 软编码：
	* 利用CPU进行大批量的编码计算处理；
	* 兼容性好；
	* 耗电量大，手机发烫
* 硬编码：
	* 利用GPU进行编码处理；
	* 兼容性略差；
	* 手机不会很烫

##### CMSampleBuffer
在实例代码中，我们使用AVCapture捕获音视频数据。其Output代理函数中，有返回CMSampleBuffer格式数据。那么什么是CMSampleBuffer呢？
CMSampleBuffer是iOS中表示一帧音视频数据，它包含了这一帧数据的内容和格式；

##### YUV格式
YUV是图片存储格式，类似于RGB。因为视频是由一帧一帧的图片链接而成，所以从CMSampleBuffer拿到的数据可以提取出YUV图像数据。
那么为什么要用yuv格式呢？
yuv中，y表示亮度，u和v表示色差。单独只有y数据的图片是一张灰色的。
yuv格式使用广泛；其可以通过抛弃色差来进行宽带优化；在传输上也更灵活！
实例中，Output的videoSettings使用的视频输出格式是  kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange，它表示yuv中NV12格式，kCVPixelFormatType_420YpCbCr8Planar则表示yuv中I420格式；

一张yuv格式图片所占的字节为：width * height * 3 / 2; 一张RGB格式图片所占字节为：width * height * 3

* 从CMSampleBuffer数据中提取yuv数据
```swiift
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
```

##### PCM格式
PCM是一种声音数据格式。我们经常听说的wav格式，其实就是PCM格式数据上添加一段header数据而已。
而之所以要是有PCM格式数据，是因为所有的音频编码器，都支持PCM编码，而且录制的声音，默认也是PCM格式。所以当然CMSampleBuffer数据也含有PCM格式数据。
* 从CMSampleBuffer数据中提取pcm数据
```swiift
+ (NSData *)convertAudioSampleBufferToPCMData:(CMSampleBufferRef)audioSample {
    //
    NSInteger audioDataSize = CMSampleBufferGetTotalSampleSize(audioSample);
    
    int8_t *audio_data = aw_alloc((int32_t)audioDataSize);
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(audioSample);
    
    CMBlockBufferCopyDataBytes(dataBuffer, 0, audioDataSize, audio_data);
    
    return [NSData dataWithBytesNoCopy:audio_data
    length:audioDataSize];
}
```

##### H264
H264是一种视频压缩格式，也就是说通过算法，将图像序列进行压缩。
它将视频帧分为关键帧和非关键帧。相同的视频，如果都使用yuv格式，那么可能是100M，使用h264压缩后的视频可能只有2-3M，也就是说具有**高压缩比**。
视频硬编码可以使用系统的VideoToolBox；视频软编码可以使用FFmpeg或x264。

##### AAC
通h264一样，AAC是PCM格式的压缩格式。类似mp3格式，只是它更先进。

##### FLV 
h264是视频编码（压缩）格式，aac是音频编码（压缩）格式。FLV就是将音视频合成的格式。类似的格式还有mp4、AVI、rmvb等。
FLV也正好支持H264和AAC格式，另外RTMP协议所要求的格式也正好是FLV格式。





#### 后记
接下来的东西需要慢慢补充。

