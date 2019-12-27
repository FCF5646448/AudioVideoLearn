//
//  VideoCustomLayer.swift
//  Avplay
//
//  Created by 冯才凡 on 2019/6/6.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoCustomLayerDelegate:NSObjectProtocol {
    //触摸
    func touchesBeganWithPoint(view:VideoCustomLayer,point:CGPoint?)
    func touchesEndedWithPoint(view:VideoCustomLayer,point:CGPoint?)
    func touchesMovedWithPoint(view:VideoCustomLayer,point:CGPoint?)
    
    //
    func bottomToolPlayBtnAction(view:VideoCustomLayer,play:Bool)
    func bottomToolFullScreenBtnAction(view:VideoCustomLayer,fullScreen:Bool)
    //滑块
    func sliderTouchUpOut(view:VideoCustomLayer,value: Float)
    
    //get time
    func play(view:VideoCustomLayer)->(avplayTotleTime:TimeInterval,avplayCurrenttime:TimeInterval)
}

class VideoCustomLayer: UIView {
    
    //毛玻璃
    lazy var ev:UIVisualEffectView = {
        let ef:UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let ev:UIVisualEffectView = UIVisualEffectView(effect: ef)
        ev.frame = self.bounds
        return ev
    }()
    
    //中间部分
    var fontView:UIView! //最前方view 比如封面图什么的。
    
    //顶部view
    lazy var topView:UIView = { //顶部view
        let v = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: kNavBarHeight))
        return v
    }()
    
    //底部工具view
    let bottomToolsH:CGFloat = 34
    lazy var bottomToolsView:UIView = { //底部工具view
        let v = UIView(frame: CGRect(x: 0, y: self.frame.height-bottomToolsH, width: self.frame.width, height: bottomToolsH))
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    }()
    
    //播放按钮
    lazy var playBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: bottomToolsH, height: bottomToolsH)
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(playBtnAction), for: .touchUpInside)
        return btn
    }()
    
    //滑块
    lazy var slide:UISlider = {
        let slider:UISlider = UISlider(frame:CGRect(x:50, y:(bottomToolsH-5)/2.0, width:self.frame.size.width - 50 - 151, height:5))
        slider.minimumValue = 0  //最小值
        slider.maximumValue = 1  //最大值
        slider.value = 0.0  //当前默认值
        slider.setThumbImage(UIImage(named: "sliderPoint"), for: .normal)
        slider.minimumTrackTintColor = UIColor.gray //左边槽的颜色
        slider.maximumTrackTintColor = UIColor.lightGray //右边槽的颜色
        
        //按下
        slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        //抬起
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchCancel)
        
        return slider
    }()
    
    //时间
    lazy var timeLabel:UILabel = {
        let timeL = UILabel(frame: CGRect(x: self.frame.size.width - bottomToolsH - 1 - 101, y: 0, width: 100, height: bottomToolsH))
        timeL.textColor = UIColor.white
        timeL.textAlignment = .center
        timeL.font = UIFont.systemFont(ofSize: 12)
        timeL.text = "_:_ / _:_"
        return timeL
    }()
    
    //全屏
    lazy var fullSccreenBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: self.frame.size.width - bottomToolsH - 1, y: 0, width: bottomToolsH, height: bottomToolsH))
        btn.setImage(UIImage(named: "fullScreen"), for: .normal)
        btn.addTarget(self, action: #selector(fullSccreenBtnAction), for: .touchUpInside)
        return btn
    }()
   
    var link:CADisplayLink! //定时器
    var sliding = false //滑块是否在滑动
    weak var delegate:VideoCustomLayerDelegate?
    
    
    var playing = false {
        didSet{
            if playing {
                //不在播放，点击后进行播放
                self.playBtn.setImage(UIImage(named: "pause"), for: .normal)
            }else{
                self.playBtn.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timeInvalidate()
        print("VideoCustomLayer deinit ☠️☠️")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// UI && tool
extension VideoCustomLayer {
    
    func initUI() {
        self.addSubview(self.ev)
        //
        self.addSubview(self.topView)
        //
        self.addSubview(self.bottomToolsView)
        
        //
        self.bottomToolsView.addSubview(self.playBtn)
        self.bottomToolsView.addSubview(self.slide)
        self.bottomToolsView.addSubview(self.timeLabel)
        self.bottomToolsView.addSubview(self.fullSccreenBtn)
        
        
    }
    
    func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60.0)
        let Sec = Int(secounds) % 60
        return String(format: "%02d:%02d", Min, Sec)
    }
}

// inteface
extension VideoCustomLayer {
    func beginTime() {
        self.ev.isHidden = true
        self.link = CADisplayLink(target: self, selector: #selector(updateTime))
        self.link.add( to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    func timeInvalidate() {
        link.invalidate()
        link = nil
    }
}

//Action
extension VideoCustomLayer {
    @objc func playBtnAction() {
        self.delegate?.bottomToolPlayBtnAction(view: self, play: !playing)
    }
    
    @objc func fullSccreenBtnAction() {
        self.delegate?.bottomToolFullScreenBtnAction(view: self, fullScreen: true)
    }
    
    @objc func sliderTouchDown(_ slider:UISlider) {
        if self.playing {
            self.sliding = true
        }
    }
    
    @objc func sliderTouchUpOut(_ slider:UISlider) {
        if self.playing {
            self.delegate?.sliderTouchUpOut(view: self, value: slider.value)
        }
    }
    
    @objc func updateTime(){
        if !self.playing {
            return
        }
        
        if let times = self.delegate?.play(view: self) {
            let timeStr = "\(formatPlayTime(secounds: times.avplayCurrenttime)) / \(formatPlayTime(secounds: times.avplayTotleTime))"
            self.timeLabel.text = timeStr // 赋值
            if !self.sliding {
                self.slide.value = Float(times.avplayCurrenttime/times.avplayTotleTime)
            }
        }
    }
    
}

// delegate
extension VideoCustomLayer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first?.location(in: self)
        self.delegate?.touchesBeganWithPoint(view: self, point: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first?.location(in: self)
        self.delegate?.touchesEndedWithPoint(view: self, point: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first?.location(in: self)
        self.delegate?.touchesMovedWithPoint(view: self, point: touch)
    }
}


