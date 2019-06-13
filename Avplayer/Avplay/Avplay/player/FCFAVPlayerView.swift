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
    
    lazy var customLayer:VideoCustomLayer = {
        let v = VideoCustomLayer(frame: self.bounds)
        v.delegate = self
        return v
    }()
    
    var playing:Bool = false {
        didSet{
            self.customLayer.playing = playing
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        initUI()
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
    func closePlay() {
        self.avplayer.pause()
        self.customLayer.timeInvalidate()
    }
}

extension FCFAVPlayerView {
    
    func initUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(self.customLayer)
    }
    
    func updateUI() {
        if self.url != nil {
            self.avplaylayer.frame = bounds
            layer.insertSublayer(avplaylayer, at: 0)
            self.avplayer.play()
            self.customLayer.beginTime()
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

extension FCFAVPlayerView : VideoCustomLayerDelegate {
    //触摸
    func touchesBeganWithPoint(view:VideoCustomLayer,point:CGPoint?) {
        
    }
    func touchesEndedWithPoint(view:VideoCustomLayer,point:CGPoint?) {
        
    }
    func touchesMovedWithPoint(view:VideoCustomLayer,point:CGPoint?) {
        
    }
    //滑块
    func sliderTouchUpOut(view:VideoCustomLayer,value: Float) {
        let duration = value*Float(CMTimeGetSeconds(self.avplayer.currentItem!.duration))
        let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
        self.avplayer.seek(to: seekTime) {[weak self] (b) in
            guard let `self` = self else {return}
            self.customLayer.sliding = false
        }
    }
    
    func bottomToolPlayBtnAction(view:VideoCustomLayer,play:Bool) {
        if play {
            self.avplayer.play()
            self.playing = true
        }else{
            self.avplayer.pause()
            self.playing = false
        }
    }
    func bottomToolFullScreenBtnAction(view:VideoCustomLayer,fullScreen:Bool) {
        
    }
    func play(view:VideoCustomLayer)->(avplayTotleTime:TimeInterval,avplayCurrenttime:TimeInterval) {
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        //总时长
        let totalTime = TimeInterval(self.playerItem.duration.value )/TimeInterval(self.playerItem.duration.timescale )
        return (totalTime,currentTime)
    }
}





