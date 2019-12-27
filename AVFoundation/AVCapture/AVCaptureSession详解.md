##### 整体框架
AVFoundation框架下的AVCaptureSession是用于采集音视频的核心类。
整个流程使用以下几个类依次进行处理
* AVCaptureDevice：数据源输入设备(摄像头、麦克风)，可以设置一些采集效果，比如曝光、白平衡、聚焦等；
* AVCaptureInput：输入数据的管理对象，有三种Input子类：AVCaptureDeviceInput、AVCaptureScreenInput、AVCaptureMetadataInput；
* AVCaptureSession：核心类，管理输入输出音视频；
* AVCaptureOutput：输出数据的管理对象，有多种方式的输出子类：
	* 文件：AVCaptureFileOutput；
	* photo：AVCapturePhotoOutput；	
	* Image：AVCaptureStillImageOutput；
	* video：AVCaptureVideoDataOutput；
	* audio：AVCaptureAudioDataOutPut；
	* AudioPreview：AVCaptureAudioPreviewOutput；
	* DepthData：AVCaptureDepthDataOutput；
	* metaData：AVCaptureMetaDataOutput;
* AVCaptureVideoPreviewLayer：预览；

##### 采集流程：
创建AVCaptureSession对象；
使用AVCaptureDevice获取设备；
利用获取到设备初始化AVCaptureDeviceInput对象；
初始化Output；











借鉴：
https://juejin.im/post/5cb1f987f265da039d3274c3


