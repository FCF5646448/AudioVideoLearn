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
    
    glGenBuffers(1, &vertexBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithBool:YES],
    GLKTextureLoaderOriginBottomLeft, nil];
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    _textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:NULL];
    
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    _textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];

    //
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
}

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
