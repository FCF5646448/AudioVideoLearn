//
//  DefaultHeader.swift
//  Avplay
//
//  Created by 冯才凡 on 2019/6/13.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import UIKit

let ScreenWidth:CGFloat      = UIScreen.main.bounds.size.width
let ScreenHeight:CGFloat     = UIScreen.main.bounds.size.height
let ScreenSize:CGSize        = UIScreen.main.bounds.size
let IS_IPHONE_X_XR_MAX_Swift:Bool   = (UIScreen.main.nativeBounds.height == 1792 || UIScreen.main.nativeBounds.height == 2436 || UIScreen.main.nativeBounds.height == 2688)
let kNavBarHeight:CGFloat    = IS_IPHONE_X_XR_MAX_Swift ? 88.0 : 64.0
let kTabBarHeight:CGFloat    = IS_IPHONE_X_XR_MAX_Swift ? 83.0 : 49.0
let kStatusBarHeight:CGFloat = IS_IPHONE_X_XR_MAX_Swift ? 44.0 : 20.0

let kIsIPad:Bool             = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
let AppDelegate_swift = UIApplication.shared.delegate as? AppDelegate


