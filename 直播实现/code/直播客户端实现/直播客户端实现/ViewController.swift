//
//  ViewController.swift
//  直播客户端实现
//
//  Created by 冯才凡 on 2019/12/29.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var preView: UIView!
    
    @IBOutlet weak var positionBtn: UIButton!
    
    @IBOutlet weak var capBtn: UIButton!
    
    // 创建Session对象
    private let captureSession = AVCaptureSession()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    // 设置Input
    var position:AVCaptureDevice.Position = .back //默认后置摄像头
    var perferredDeviceType:AVCaptureDevice.DeviceType = .builtInWideAngleCamera //一开始默认使用builtInDualCamera会初始化失败
    var cameraDeviceInput:AVCaptureDeviceInput?
    var audioDeviceInput:AVCaptureDeviceInput?
    
    // 设置Output
    var videoOutput:AVCaptureVideoDataOutput?
    var audioOutput:AVCaptureAudioDataOutput?
    let captureQueue =  DispatchQueue.global(qos: .default) //DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPreViewLayer()
        getAuthrized(for: [.video, .audio])
    }
    
    
    
    
    
    @IBAction func positionBtnAction(_ sender: Any) {
        switch self.position {
        case .back:
            position = .front
            perferredDeviceType = .builtInWideAngleCamera
            break
        case .front:
            position = .back
            perferredDeviceType = .builtInWideAngleCamera
            break
        case .unspecified:
            position = .back
            perferredDeviceType = .builtInWideAngleCamera
            break
        @unknown default:
            position = .back
            perferredDeviceType = .builtInWideAngleCamera
        }
        
        
        //重置vidoe输入：
        setCameraInput()
    }
    
    @IBAction func capBtnAction(_ sender: Any) {
        capBtn.isSelected = !capBtn.isSelected
        if capBtn.isSelected {
            self.captureSession.stopRunning()
        }else{
            self.captureSession.startRunning()
        }
    }
    
    

}

extension ViewController {
    //查询权限
    func getAuthrized(for mediaTypes: [AVMediaType]) {
        mediaTypes.forEach { (mediaType) in
            switch AVCaptureDevice.authorizationStatus(for: mediaType) {
            case .authorized:
                sessionConfig()
                //允许
                return
            case .denied:
                //不允许
                return
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: mediaType) {[weak self] ( granted) in
                    if granted {
                        //同意
                        self?.sessionConfig()
                    }
                }
                return
            case .restricted:
                //受限
                return
            @unknown default:
                return
            }
        }
    }
    
    //配置基础设置
    func sessionConfig() {
        
        //设置分辨率
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        //
        setCameraInput()
//        setAudioInput()
        
        //
        setOutput()
        
        //启动
        captureSession.startRunning()
        
    }
    
    //摄像头Input
    func setCameraInput() {
        guard let cameraDevice = AVCaptureDevice.default(self.perferredDeviceType, for: .video, position: self.position) else {
            print("video device init failed")
            return
        }
        
        //设置好Input
        do{
            if cameraDeviceInput != nil {
                captureSession.removeInput(cameraDeviceInput!)
                cameraDeviceInput = nil
            }
            
            let cameraInput = try AVCaptureDeviceInput(device: cameraDevice)
            if captureSession.canAddInput(cameraInput) {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChanged), name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
                
                captureSession.addInput(cameraInput)
                cameraDeviceInput = cameraInput
            }
            
        }catch {
            print("video input init failed")
        }
    }
    
    // 设置音频Input
    func setAudioInput() {
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)  else {
            print("audio device init failed")
            return
        }
        
        do{
            //
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
            //
            print("audio input init failed")
        }
        
    }
    
    //设置输出
    func setOutput() {
        
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
        let connection = self.videoOutput?.connection(with: AVMediaType.video)
        connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        //音频输出
        self.audioOutput = AVCaptureAudioDataOutput()
        self.audioOutput?.setSampleBufferDelegate(self, queue: captureQueue)
        if self.captureSession.canAddOutput(self.audioOutput!) {
            self.captureSession.addOutput(self.audioOutput!)
        }
        
        
    }
    
    //设置好预览
    func setPreViewLayer() {
        previewLayer.session = self.captureSession
        preView.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
//        previewLayer.masksToBounds = true
    }
    
    
    //监听主要通知
    func notification() {
        //中断了
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted(_:)), name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: self.captureSession)
        //中断结束了
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionEnded(_:)), name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: self.captureSession)
        
        //监听运行时发送的错误
        NotificationCenter.default.addObserver(self, selector: #selector(sessionRuntimeError(_:)), name: NSNotification.Name.AVCaptureSessionRuntimeError, object: self.captureSession)
    }
}

extension ViewController {
    @objc func subjectAreaDidChanged() {
//        isSubjectAreaChangeMonitoringEnabled
    }
    
    //被中断了
    @objc func sessionWasInterrupted(_ notify:Notification) {
        if let reason:AVCaptureSession.InterruptionReason  = notify.userInfo?[AVCaptureSessionInterruptionReasonKey] as? AVCaptureSession.InterruptionReason {
            switch reason {
            case .audioDeviceInUseByAnotherClient,.videoDeviceInUseByAnotherClient:
                print("被其他应用打断了")
                break
            case .videoDeviceNotAvailableWithMultipleForegroundApps:
                //相机不可用，可以添加蒙版
                
                break
            default:
                break
            }
        }
        
    }
    
    //中断结束
    @objc func sessionInterruptionEnded(_ notify:Notification) {
        //恢复运行
        self.captureSession.startRunning()
    }
    
    //运行错误，注意这个错误类型
    @objc func sessionRuntimeError(_ notify:Notification) {
        if let error:AVError = notify.userInfo?[AVCaptureSessionErrorKey] as? AVError {
            if error.code == .mediaServicesWereReset {
                //重启会话
                self.captureSession.startRunning()
            }
        }
    }
    
}



extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}


extension ViewController : AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        captureQueue.sync {
            VideoToolBoxManager.shareInstance().encode(sampleBuffer)
        }
    }
}


extension ViewController {
    //将 CMSampleBuffer 转成 YUV 数据
//    func convertVideoSmapleBufferToYUVData(videoBuffer:CMSampleBuffer)->Data? {
//        
//        //获取CVImageBufferRef数据，它里面包含了yuv420(NV12)数据
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoBuffer) else {
//            return nil
//        }
//        
//        //开始操作数据
//        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//        
//        //图像宽度
//        let pixelW = CVPixelBufferGetWidth(pixelBuffer)
//        //图像高度
//        let pixelH = CVPixelBufferGetHeight(pixelBuffer)
//        
//        //获取y所占字节
//        let y_size = pixelW * pixelH
//        //获取uv所占字节
//        let uv_size = y_size/2
//        
//        let yuv_frame = aw_alloc
//        
//        return nil
//    }
}



