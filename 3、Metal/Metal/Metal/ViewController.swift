//
//  ViewController.swift
//  Metal
//
//  Created by 冯才凡 on 2019/7/2.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import MetalKit
import MetalPerformanceShaders

class ViewController: UIViewController {

    
    var device:MTLDevice = nil
//    var metalLayer:CAmetalLayer = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        super.loadView()
        let mtkView = MTKView(frame: self.view.bounds)
        let devices = MTLCreateSystemDefaultDevice()
        
//        mtkView.device =
        
        
    }


}

