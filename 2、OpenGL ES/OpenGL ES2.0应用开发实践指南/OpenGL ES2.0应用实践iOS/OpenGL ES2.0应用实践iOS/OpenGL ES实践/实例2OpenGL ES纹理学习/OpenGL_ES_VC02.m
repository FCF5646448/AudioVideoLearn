//
//  OpenGL_ES_VC02.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/12/4.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "OpenGL_ES_VC02.h"
#import <GLKit/GLKit.h>


typedef struct {
    GLKVector3 positionCoords; //顶点坐标
    GLKVector2 textureCoords; //纹理坐标
}SceneVertex2;

@interface OpenGL_ES_VC02 ()
{
    GLuint vertexBufferID;
}
@property (nonatomic, strong) GLKBaseEffect * baseEffect;
@end

@implementation OpenGL_ES_VC02

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

- (void)initUI {
    
    GLKView * view = (GLKView *)self.view;
    
    //创建上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //设置上下文
    [EAGLContext setCurrentContext:view.context];
    
    //创建顶点着色器
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0);
    
    glClearColor(0.0, 0.0, 1.0, 1.0);
    
    
    //准备顶点数据
    static const SceneVertex2 vertices[] = {
        {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},
        {{0.5f,-0.5f,0.0f}, {1.0f,0.0f}},
        {{-0.5f,0.5f,0.0f}, {0.0f,1.0f}},
    };
    
    //生成缓存标识符
    glGenBuffers(1, &vertexBufferID);
    //绑定上下文
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //复制顶点到上下文的缓存中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    //纹理准备
    CGImageRef imageRef = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    //GLKTextureLoader 会自动调用glTexParameteri()方法设置OpenGL ES取样和循环模式。它里面使用glGenTexture()和glBndTexture()等与顶点缓存相似的函数
    GLKTextureInfo * textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    //
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
        
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //开始绘制
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    //渲染顶点坐标
    //启用顶点渲染
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置指针
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, positionCoords));
    
//    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    
    //渲染纹理坐标
    //启用纹理渲染
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    // 设置指针
    glVertexAttribPointer(GLKVertexAttribTexCoord0,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex2),
                          NULL + offsetof(SceneVertex2, textureCoords));
    
    //开始绘制
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}



@end
