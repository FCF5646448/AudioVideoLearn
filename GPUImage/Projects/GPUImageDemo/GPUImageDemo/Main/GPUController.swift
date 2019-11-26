//
//  GPUController.swift
//  GPUImageDemo
//
//  Created by 冯才凡 on 2019/9/28.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import GPUImage
import AVFoundation

class GPUController: UIViewController {

    var camera: Camera!
    var basicOperation:BasicOperation!
    var renderView:RenderView!
    
    //创建一个BrightnessAdjustment颜色处理滤镜
    var brightnessAdjustment:BrightnessAdjustment {
        get{
            let brightnessAdjustment = BrightnessAdjustment()
            brightnessAdjustment.brightness = 0.2
            return brightnessAdjustment
        }
    }
    
    //创建一个ExposureAdjustment颜色处理滤镜
    var exposureAdjestment:ExposureAdjustment {
        get{
            let exposureAdjestment = ExposureAdjustment()
            exposureAdjestment.exposure = 0.5
            return exposureAdjestment
        }
    }
    
    lazy var originImgV:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH/3.0))
        imgView.backgroundColor = .white
        imgView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "001", ofType: "jpeg")!)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var filter01ImgV:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: ScreenH/3.0, width: ScreenW, height: ScreenH/3.0))
        imgView.backgroundColor = .red
        imgView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "001", ofType: "jpeg")!)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var filter02ImgV:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: ScreenH/3.0*2, width: ScreenW, height: ScreenH/3.0))
        imgView.backgroundColor = .red
        imgView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "001", ofType: "jpeg")!)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var filter03ImgV:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: ScreenH/3.0))
        imgView.backgroundColor = .red
        imgView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "001", ofType: "jpeg")!)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override func loadView() {
        super.loadView()
        let v = UIScrollView()
        v.backgroundColor = UIColor.white
        v.addSubview(self.originImgV)
        v.contentSize = CGSize(width: ScreenW, height: ScreenH*2.0)
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filter01()
        filter02()
        operationGroup()
        
    }

}

// 静态处理
extension GPUController {
    //1、使用GPUImage对UIImage的扩展方法进行便利滤镜处理（这个方法如果进行多次滤镜处理时，会产生更多开销，建议用下面这种）
    func filter01() {
        self.view.addSubview(self.filter01ImgV)
        
        var filteredImg:UIImage
        // 单一滤镜
        filteredImg = self.filter01ImgV.image!.filterWithOperation(brightnessAdjustment)
        
        //多个滤镜叠加
        filteredImg = self.filter01ImgV.image!.filterWithPipeline({ (input, output) in
            input --> brightnessAdjustment --> exposureAdjestment --> output
        })
        
        self.filter01ImgV.image = filteredImg
    }
    
    //2、使用管道处理
    func filter02() {
        self.view.addSubview(self.filter02ImgV)
        //创建图片输入
        let pictureInput = PictureInput(image: self.filter02ImgV.image!)
        //创建图片输出
        let pictureOutput = PictureOutput()
        weak var weakself = self
        //设置好回调
        pictureOutput.imageAvailableCallback = { image in
            weakself?.filter02ImgV.image = image
        }
        
        // 绑定处理链
        pictureInput --> brightnessAdjustment --> exposureAdjestment --> pictureOutput
        //开始处理 synchronously：true同步执行，false异步执行，处理完后会回调 imageAvailableCallback
        pictureInput.processImage(synchronously: true)
    }
    
}

//操作组
extension GPUController {
    func operationGroup() {
        self.view.addSubview(self.filter03ImgV)
        let operation = OperationGroup()
        operation.configureGroup { (input, output) in
            input --> brightnessAdjustment --> exposureAdjestment --> output
        }
        self.filter03ImgV.image = self.filter03ImgV.image?.filterWithOperation(operation)
    }
}
