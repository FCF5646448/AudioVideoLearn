//
//  AGLKView.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/12/1.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "AGLKView.h"
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>


@interface AGLKView()
{
    GLuint      defaultFrameBuffer;
    GLuint      colorRenderBuffer;
    GLint       drawableWidth;
    GLint       drawableHeight;
}

@property (nonatomic, strong) EAGLContext * context;
@property (nonatomic, assign, readonly) NSInteger drawableWidth;
@property (nonatomic, assign, readonly) NSInteger drawableHeight;

@end

@implementation AGLKView

//这里是为了避免调用CALayer的layerClass方法
+ (Class)layerClass {
    return [AGLKView class];
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eagLayer = (CAEAGLLayer *)self.layer;
        eagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],
                                       kEAGLDrawablePropertyRetainedBacking,
                                       kEAGLColorFormatRGBA8,
                                       kEAGLDrawablePropertyColorFormat, nil];
        self.context = aContext;
    }
    return self;
}

//xib初始化
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CAEAGLLayer *eagLayer = (CAEAGLLayer *)self.layer;
    /*
     kEAGLDrawablePropertyRetainedBacking:NO,
     kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8
     这两个键值对是表示“不使用保留背景”，意思是不要保留任何以前绘制的图像。
        */
        eagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],
                                       kEAGLDrawablePropertyRetainedBacking,
                                       kEAGLColorFormatRGBA8,
                                       kEAGLDrawablePropertyColorFormat, nil];
    }
    return self;
}

- (void)setContext:(EAGLContext *)acontext {
    if (_context != acontext) {
        // 重置上下文
        [EAGLContext setCurrentContext:_context];
        
        if (0 != defaultFrameBuffer) {
            glDeleteFramebuffers(1, &defaultFrameBuffer);
            defaultFrameBuffer = 0;
        }
        
        if (0 != colorRenderBuffer) {
            glDeleteRenderbuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }
        
        _context = acontext;
        
        if (nil != _context) {
            _context = acontext;
            [EAGLContext setCurrentContext:_context];
            
            //创建一个帧缓存
            glGenBuffers(1, &defaultFrameBuffer);
            glBindBuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
            
            //创建一个渲染帧缓存
            glGenRenderbuffers(1, &colorRenderBuffer);
            glBindBuffer(GL_RENDERBUFFER, colorRenderBuffer);
            
            
            // 帧缓存和渲染缓存绑定
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
            
        }
        
    }
}

- (NSInteger)drawableWidth {
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,GL_RENDERBUFFER_WIDTH , &backingWidth);
    return (NSInteger)backingWidth;
}

- (NSInteger)drawableHeight {
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return (NSInteger)backingHeight;
}


- (void) display {
    [EAGLContext setCurrentContext:_context];
    //设置渲染范围
    glViewport(0, 0, drawableWidth, drawableHeight);
    //开始绘制
    [self drawRect:self.bounds];
    //
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)layoutSubviews {
    CAEAGLLayer * eaglLayer = (CAEAGLLayer *)self.layer;
    
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"fail");
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate glkView:self drawinRect:self.bounds];
    }
}


@end
