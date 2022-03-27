//
//  ViewController.swift
//  Metal01图片绘制
//
//  Created by 冯才凡 on 2019/7/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    var mtkV:MTKView!
    var viewportSize:vector_uint2!
    override func loadView() {
        let mtkV = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        self.view = mtkV
//        mtkV.delegate = self
        let viewPortSize = vector_uint2.init(UInt32(self.mtkV.drawableSize.width), UInt32(self.mtkV.drawableSize.height))
        self.viewportSize = viewPortSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ViewController {
    func setupPipeline() {
        let defaultLibrary = self.mtkV.device?.makeDefaultLibrary()
        let vertexFunction = defaultLibrary?.makeFunction(name: "vertexShader")
        let fragmentFunction = defaultLibrary?.makeFunction(name: "samplingShader")
        
        
    }
}

