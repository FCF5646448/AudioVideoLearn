#### 格式说明
本文解决一个问题：直播过程中，整个客户端使用什么格式，以及为什么使用这种格式？

##### CMSampleBuffer
在实例代码中，我们使用AVCapture捕获音视频数据。其Output代理函数中，有返回CMSampleBuffer格式数据。那么什么是CMSampleBuffer呢？
CMSampleBuffer是iOS中表示一帧音视频数据，它包含了这一帧数据的内容和格式；

##### YUV格式
YUV是图片存储格式，类似于RGB。因为视频是由一帧一帧的图片链接而成，所以从CMSampleBuffer拿到的数据可以提取出YUV图像数据。
那么为什么要用yuv格式呢？
yuv中，y表示亮度，u和v表示色差。单独只有y数据的图片是一张灰色的。
yuv格式使用广泛；其可以通过抛弃色差来进行宽带优化；在传输上也更灵活！
实例中，Output的videoSettings使用的视频输出格式是  kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange，它表示yuv中NV12格式，kCVPixelFormatType_420YpCbCr8Planar则表示yuv中I420格式；
* 从CMSampleBuffer数据中提取yuv数据
```swiift

```

##### PCM格式
PCM是一种声音数据格式。我们经常听说的wav格式，其实就是PCM格式数据上添加一段header数据而已。
而之所以要是有PCM格式数据，是因为所有的音频编码器，都支持PCM编码，而且录制的声音，默认也是PCM格式。所以当然CMSampleBuffer数据也含有PCM格式数据。
* 从CMSampleBuffer数据中提取pcm数据
```swiift

```




