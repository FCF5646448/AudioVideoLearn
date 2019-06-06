//
//  FCFAVPlayerView.swift
//  Avplay
//
//  Created by 冯才凡 on 2019/6/6.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer //主要是为了获取当前音量

//承载播放器的view
@objc class FCFAVPlayerView: UIView {
    
    @objc var url:URL? {
        didSet{
            updateUI()
        }
    }
    
    lazy var playerItem:AVPlayerItem = {
        let pitem = AVPlayerItem(url: self.url!)
        
        //监听缓冲进度
        pitem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        //监听状态改变
        pitem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        return pitem
    }()
    
    lazy var avplayer:AVPlayer = {
        let play = AVPlayer(playerItem: self.playerItem)
        return play
    }()
    
    lazy var avplaylayer:AVPlayerLayer = {
        let layer = AVPlayerLayer(player: self.avplayer)
        layer.videoGravity = AVLayerVideoGravity.resizeAspect //定义视频的显示方式 保留宽高比
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    
    
    var playing:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem.removeObserver(self, forKeyPath: "status")
        print("FCFAVPlayerView deinit")
    }
}

extension FCFAVPlayerView {
    func updateUI() {
        if self.url != nil {
            self.avplaylayer.frame = bounds
            layer.insertSublayer(avplaylayer, at: 0)
            self.avplayer.play()
            
            //
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges" {
            //缓冲进度
        }else if keyPath == "status" {
            //状态
            if playItem.status == .readyToPlay {
                //真正播放时
                self.playing = true
                //
                
            }else{
                print("播放异常")
            }
        }
    }
}






