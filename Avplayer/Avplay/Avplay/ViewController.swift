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
        
        let playview = FCFAVPlayerView(frame: CGRect(x: 0, y: 200, width: view.frame.size.width, height: view.frame.size.width/2.0))
        playview.url = URL(string: "https://cdn-5.haku99.com/hls/2019/04/11/qoJ7dGXJ/playlist.m3u8")
//        playview.url = URL(string:"https://gss3.baidu.com/6LZ0ej3k1Qd3ote6lo7D0j9wehsv/tieba-smallvideo/607272_bd5ec588760b7d8d2fc15183b95e628a.mp4")
        self.view.addSubview(playview)
        
    }


}

