//
//  OpenGL_ES_VC04.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/12/5.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "OpenGL_ES_VC04.h"
#import <GLKit/GLKit.h>


typedef struct {
    GLKVector3 positionCoord;
    GLKVector2 textureCoord;
    
}SceneVertex04;

@interface OpenGL_ES_VC04 ()
{
    GLuint vertexBufferID;
}

@property (nonatomic, strong) GLKBaseEffect * baseEffect;

@property (nonatomic, strong) GLKTextureInfo * textureInfo0;
@property (nonatomic, strong) GLKTextureInfo * textureInfo1;

@end

@implementation OpenGL_ES_VC04

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGL];
}


- (void) initGL {
    
    GLKView * view = (GLKView *)self.view;
    
    //
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    [self.baseEffect setConstantColor:GLKVector4Make(1.0, 1.0, 1.0, 1.0)];
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    //这里定义了两个三角形数据，合起来正好是一个矩形
    SceneVertex04 vertices[] = {
        {{-1.0,  -0.67,   0.0}, {0.0, 0.0}},
        {{ 1.0,  -0.67,   0.0}, {1.0, 0.0}},
        {{-1.0,   0.67,   0.0}, {0.0, 1.0}},
        {{ 1.0,  -0.67,   0.0}, {1.0, 0.0}},
        {{-1.0,   0.67,   0.0}, {0.0, 1.0}},
        {{ 1.0,   0.67,   0.0}, {1.0, 1.0}},
    };
    
    //
    glGenBuffers(1, &vertexBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    //垂直翻转图像数据，可以抵消图像原点与OpenGL ES标准原点之间的差异
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithBool:YES],
    GLKTextureLoaderOriginBottomLeft, nil];
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    _textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:NULL];
    
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    _textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];

    
    //启用混合
    //不加上这两句的话，透明纹理的背景色会被渲染成其他颜色,就会挡住下层纹理，加上了就会正常透明
    glEnable(GL_BLEND);
    // 设置混合。第一个元素用于指定混合方式 ，第2个参数用于指定目标帧缓存内的颜色元素怎么影响混合。
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
}

//注：注意这个函数是在每次渲染时被调用，那么每次的都会重复“读取缓存数据、与片元颜色混合、重写”这个过程。这种方式叫“多通道渲染”。但是内存访问限制了性能，所以这不是最优的方式。
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex04),
                          NULL+offsetof(SceneVertex04, positionCoord));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex04),
                          NULL+offsetof(SceneVertex04, textureCoord));
    
    // 这里缓存数据会被绘制两次。第一次使用了一个纹理，第二次使用了另一个。绘制的顺序决定了哪个纹理会在另一个纹理之上。
    self.baseEffect.texture2d0.name = _textureInfo0.name;
    self.baseEffect.texture2d0.target = _textureInfo0.target;
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    self.baseEffect.texture2d0.name = _textureInfo1.name;
    self.baseEffect.texture2d0.target = _textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
}



@end
