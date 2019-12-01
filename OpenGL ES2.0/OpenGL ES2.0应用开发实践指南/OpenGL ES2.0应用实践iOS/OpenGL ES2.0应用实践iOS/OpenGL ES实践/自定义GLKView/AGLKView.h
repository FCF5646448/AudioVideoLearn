//
//  AGLKView.h
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/12/1.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AGLKView;

@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawinRect:(CGRect)rect;

@end

@interface AGLKView : UIView
@property (nonatomic, weak) IBOutlet id<AGLKViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
