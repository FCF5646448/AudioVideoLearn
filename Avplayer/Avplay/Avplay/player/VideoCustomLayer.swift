//
//  VideoCustomLayer.swift
//  Avplay
//
//  Created by 冯才凡 on 2019/6/6.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit


protocol VideoCustomLayerDelegate:NSObjectProtocol {
    
    //触摸
    func touchesBeganWithPoint(view:VideoCustomLayer,point:CGPoint?)
    func touchesEndedWithPoint(view:VideoCustomLayer,point:CGPoint?)
    func touchesMovedWithPoint(view:VideoCustomLayer,point:CGPoint?)
}

class VideoCustomLayer: UIView {
    
    var topView:UIView! //顶部view
    lazy var bottomToolsView:UIView = { //底部工具view
        let v = UIView(frame: CGRect(x: 0, y: self.frame.height-44, width: self.frame.width, height: 44))
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return v
    }()
    
    var fontView:UIView! //最前方view 比如封面图什么的。
    
    weak var delegate:VideoCustomLayerDelegate?
    
    
    var playing = false {
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
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

extension VideoCustomLayer {
    
    func initUI() {
        self.addSubview(self.bottomToolsView)
        //
        
        
        
    }
    
}
