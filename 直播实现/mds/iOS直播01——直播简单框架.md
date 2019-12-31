#### 直播的总体框架：
* 直播端：把录制的视频推流到服务器
* 服务器：服务器通过CDN服务器发送给观众
* 观看端：拉流

##### 直播端：
直播端可能的业务包括：
音视频采集 ——— 美颜(可选) ——— 音视频编辑码 ——— 推流到服务器

音视频采集，最主要的就是AVFoundation框架下的AVCaptureSession：

美颜：GPUImage

视频编码：VideoToolBox、FFmpeg

音频编码：AudioToolBox







##### 服务端：
服务端可做的业务比较多，但是基本都是可选型操作：
转码(可选) ——— 录制(可选) ——— 截图(可选) ——— 鉴黄(可选)



##### 播放端：
拉流 ——— 解码 ——— 渲染 ——— 互动(可选)



借鉴：
https://github.com/guoxiaopang/LiveExplanation
袁峥: https://www.jianshu.com/p/bd42bacbe4cc
hard_man: https://juejin.im/post/5a572730f265da3e2c3803ad