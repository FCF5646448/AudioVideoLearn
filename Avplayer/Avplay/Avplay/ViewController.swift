//
//  ViewController.swift
//  Avplay
//
//  Created by 冯才凡 on 2019/6/6.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let playview = FCFAVPlayerView(frame: CGRect(0,200,view.frame.size.width,200,view.frame.size.width/2.0))
//        playview.url = 
        self.view.addSubview(playview)
        
    }


}

