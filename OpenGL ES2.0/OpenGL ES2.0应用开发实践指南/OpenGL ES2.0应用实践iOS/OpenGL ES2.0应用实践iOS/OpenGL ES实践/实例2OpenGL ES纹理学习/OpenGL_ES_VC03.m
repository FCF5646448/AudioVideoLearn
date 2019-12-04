//
//  OpenGL_ES_VC03.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/12/4.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "OpenGL_ES_VC03.h"
#import <GLKit/GLKit.h>

typedef struct{
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex03;


@interface OpenGL_ES_VC03 ()
{
    GLuint vertexBufferID;
}
@property (nonatomic, strong) GLKBaseEffect * baseEffect;

@end

@implementation OpenGL_ES_VC03

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


- (void)initUI {
    
    GLKView * view = (GLKView *)self.view;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    
    static const SceneVertex03 vertices[] = {
        {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},
        {{0.5f,-0.5f,0.0f}, {0.0f,1.0f}},
        {{-0.5f,0.5f,0.0f}, {1.0f,1.0f}},
    };
    
    glGenBuffers(1, &vertexBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
}


-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex03), NULL+offsetof(SceneVertex03, positionCoords));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}


@end
