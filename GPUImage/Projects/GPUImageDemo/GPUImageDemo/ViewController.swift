//
//  ViewController.swift
//  GPUImageDemo
//
//  Created by 冯才凡 on 2019/9/26.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addAction(_ sender: Any) {
        self.present(GPUController(), animated: true) {
            
        }
    }
    
}

