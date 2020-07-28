//
//  ViewController.swift
//  MyApp
//
//  Created by 冯才凡 on 2020/7/27.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var btn: NSButton!
    
    var btnSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func capAudioBtnAcion(_ sender: Any) {
        btnSelected = !btnSelected
        if btnSelected {
            btn.title = "停止录制"
            DispatchQueue.global().async {
                capAudio()
            }
            
        }else{
            set_status(0);
            btn.title = "开始录制"
        }
        
    }
    
}

