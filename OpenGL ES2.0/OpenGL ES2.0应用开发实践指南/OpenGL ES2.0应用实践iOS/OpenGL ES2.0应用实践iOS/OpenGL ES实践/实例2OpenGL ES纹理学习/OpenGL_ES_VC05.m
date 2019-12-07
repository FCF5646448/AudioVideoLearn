//
//  OpenGL_ES_VC05.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/12/6.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "OpenGL_ES_VC05.h"
#import <GLKit/GLKit.h>

typedef  struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneTexture05;

SceneTexture05 verturies[] = {
    {{-1.0,  -0.67,   0.0}, {0.0, 0.0}},
    {{ 1.0,  -0.67,   0.0}, {1.0, 0.0}},
    {{-1.0,   0.67,   0.0}, {0.0, 1.0}},
    {{ 1.0,  -0.67,   0.0}, {1.0, 0.0}},
    {{-1.0,   0.67,   0.0}, {0.0, 1.0}},
    {{ 1.0,   0.67,   0.0}, {1.0, 1.0}},
};

@interface OpenGL_ES_VC05 ()
{
    GLuint vertextureBufferID;
}

@property (nonatomic , strong) GLKBaseEffect * baseEffect;


@end

@implementation OpenGL_ES_VC05

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGL];
}

- (void) initGL {
    
    GLKView * view = (GLKView *)self.view;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    //纹理颜色 01
    [self.baseEffect setConstantColor:GLKVector4Make(1.0, 1.0, 1.0, 1.0)];
    
    //背景色 02
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    
    glGenBuffers(1, &vertextureBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertextureBufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(verturies), verturies, GL_STATIC_DRAW);
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSNumber numberWithBool:YES],
       GLKTextureLoaderOriginBottomLeft, nil];
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    GLKTextureInfo * texture0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:NULL];
    
    self.baseEffect.texture2d0.name = texture0.name;
    self.baseEffect.texture2d0.target = texture0.target;
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    GLKTextureInfo * texture1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];
    
    
    
    self.baseEffect.texture2d1.name = texture1.name;
    self.baseEffect.texture2d1.target = texture1.target;
    // 加了这句就不需要启用混合。它能达到与glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)一样的效果
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
}


// 这里表面两个纹理使用了同一个坐标。
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneTexture05),
                          NULL+offsetof(SceneTexture05, positionCoords));
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneTexture05),
                          NULL+offsetof(SceneTexture05, textureCoords));
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    glVertexAttribPointer(GLKVertexAttribTexCoord1,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneTexture05),
                          NULL+offsetof(SceneTexture05, textureCoords));
    
    
    
     [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    
}









@end
