#### 整体框架
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

#### 采集流程：
创建AVCaptureSession对象；
使用AVCaptureDevice获取设备；
利用获取到设备初始化AVCaptureDeviceInput对象；
初始化Output；
将Input和Output添加到Session中；
创建预览图层Layer；
Session调用StartRuning开始捕捉；
将捕捉到内容保存到指定文件中；

#### 实践：
AVCaptureSession从设备(camera、麦克风)接受输入数据，然后将数据送到适当的输出进行处理，最后生成视频或图片。AVCaptureSession默认使用后置摄像头，然后将摄像头捕获的数据流传输到视频预览上。

* 设置Input：
```swift
//设置Camera Input
guard let cameraDevice = AVCaptureDevice.default(self.perferredDeviceType, for: .video, position: self.position) else {
	print("video device init failed")
	return
}       
do{
	if cameraDeviceInput != nil {
		captureSession.removeInput(cameraDeviceInput!)
		cameraDeviceInput = nil
	}        
	let cameraInput = try AVCaptureDeviceInput(device: cameraDevice)
	if captureSession.canAddInput(cameraInput) {
		captureSession.addInput(cameraInput)
		cameraDeviceInput = cameraInput
	}        
}catch {
	print("video input init failed")
}

//设置microphone input
guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)  else {
	print("audio device init failed")
	return
}        
do{
	if audioDeviceInput != nil {
		captureSession.removeInput(audioDeviceInput!)
		audioDeviceInput = nil
	}
	let audioInput = try AVCaptureDeviceInput(device: audioDevice)
	if captureSession.canAddInput(audioInput) {
		captureSession.addInput(audioInput)
		audioDeviceInput = audioInput
	}
} catch {
	print("audio input init failed")
}
```

* 设置output
```swift
let captureQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
self.videoOutput = AVCaptureVideoDataOutput()
//设置代理
self.videoOutput?.setSampleBufferDelegate(self, queue: captureQueue)
//抛弃过期帧，保证实时性
self.videoOutput?.alwaysDiscardsLateVideoFrames = true
//设置输出格式
self.videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
if self.captureSession.canAddOutput(self.videoOutput!) {
	self.captureSession.addOutput(self.videoOutput!)
}

//音频输出
self.audioOutput = AVCaptureAudioDataOutput()
self.audioOutput?.setSampleBufferDelegate(self, queue: captureQueue)
if self.captureSession.canAddOutput(self.audioOutput!) {
	self.captureSession.addOutput(self.audioOutput!)
}
```
* 设置preview
```swift
//设置好预览
previewLayer.session = self.captureSession
preView.layer.insertSublayer(previewLayer, at: 0)
previewLayer.videoGravity = .resizeAspectFill
previewLayer.frame = view.bounds
```
* 启动
```swift
captureSession.startRunning()
```



#### 后话
AVFoundation对捕获过程中的各种设置和异常也都有做处理，后续将慢慢完善的事情有：
* 运行错误处理，比如掉帧、被第三方打断；
* 设备的聚焦模式、曝光模式、闪光灯模式、手电筒模式、白平衡、设备方向等；
* output的各种输出格式：file、video、audio、image、movieFile



#### 借鉴：

<https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app>

https://juejin.im/post/5cb1f987f265da039d3274c3


