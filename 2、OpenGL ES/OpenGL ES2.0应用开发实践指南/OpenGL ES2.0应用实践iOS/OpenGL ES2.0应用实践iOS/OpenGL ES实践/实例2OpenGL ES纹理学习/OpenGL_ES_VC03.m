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
@property (nonatomic, strong) GLKTextureInfo * textureInfo;

@property (nonatomic, assign) BOOL shouldUseLinearFilter; //是否使用线性滤镜
@property (nonatomic, assign) BOOL shouldAnimate; //是否使用动画
@property (nonatomic, assign) BOOL shouldRepeatTexture; //是否重复渲染
@property (nonatomic, assign) CGFloat sCoordinateOffset; //偏移值

@end

@implementation OpenGL_ES_VC03

static const SceneVertex03 defaultVertices[] = {
    {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},
    {{0.5f,-0.5f,0.0f}, {0.0f,1.0f}},
    {{-0.5f,0.5f,0.0f}, {1.0f,1.0f}},
};

static SceneVertex03 vertices[] = {
    {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},
    {{0.5f,-0.5f,0.0f}, {0.0f,1.0f}},
    {{-0.5f,0.5f,0.0f}, {1.0f,1.0f}},
};

static GLKVector3 movementVector3[3] = {
    {-0.02f, -0.01f, 0.0f},
    {0.01f, -0.005f, 0.0f},
    {-0.01f, 0.01f,  0.0f},
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initGLK];
}

- (void) initUI {
    UIView * bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, ScreneHeight - 200, ScreneWidth, 100)];
    [self.view addSubview:bottomV];
    
    UISwitch * sw1 = [[UISwitch alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
    [sw1 addTarget:self action:@selector(sw1Action:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:sw1];
    sw1.on = NO;
    
    UISwitch * sw2 = [[UISwitch alloc] initWithFrame:CGRectMake(80 + 30, 10, 60, 30)];
    [sw2 addTarget:self action:@selector(sw2Action:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:sw2];
    sw2.on = NO;
    
    
    UISwitch * sw3 = [[UISwitch alloc] initWithFrame:CGRectMake(160 + 30, 10, 60, 30)];
    [sw3 addTarget:self action:@selector(sw3Action:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:sw3];
    sw3.on = NO;
    
    
    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 60, ScreneWidth - 40, 20)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [bottomV addSubview:slider];
    
}


- (void)sw1Action:(UISwitch *)s {
    self.shouldRepeatTexture = s.isOn;
}

- (void)sw2Action:(UISwitch *)s {
    self.shouldAnimate = s.isOn;
}

- (void)sw3Action:(UISwitch *)s {
    self.shouldUseLinearFilter = s.isOn;
}

- (void)sliderAction:(UISlider *) s {
    self.sCoordinateOffset = s.value;
}


//
- (void)initGLK {
    
    GLKView * view = (GLKView *)self.view;
    //生成上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置上下文
    [EAGLContext setCurrentContext:view.context];
    
    //生成着色器
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    
   
    // 设置缓存标识符
    glGenBuffers(1, &vertexBufferID);
    // 绑定缓存
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    // 复制顶点数据到上下文 ， 注意这里第三个参数说明了 绘制模式是GL_DYNAMIC_DRAW 是动态绘制的过程
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    //
    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];
    //  设置纹理 GLKTextureLoader 会自动调用glTexParameries()设置取样和循环模式
    GLKTextureInfo * textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:nil];
    _textureInfo = textureInfo;
    
    //缓存名字、目标等配置信息
    _baseEffect.texture2d0.name = textureInfo.name;
    _baseEffect.texture2d0.target = textureInfo.target;
    
}


-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    //启用顶点渲染
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置指针
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex03),
                          NULL+offsetof(SceneVertex03, positionCoords));
    
    //启用纹理渲染
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //设置指针
    glVertexAttribPointer(GLKVertexAttribTexCoord0,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex03),
                          NULL+offsetof(SceneVertex03,textureCoords));
    
    //开始绘制
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}


/*
 这个函数是Controller 调用_updateAndDraw是会调用，调用频率应该是和drawInRect一样的
 
 */

- (void) update {
    
    [self updateAnimateVertexPositions];
    [self updateTextureParameters];
    
    [self glReset];
}

//更新纹理和位置
- (void) updateAnimateVertexPositions {
    // 这部分是位置动画相关, 跳转对应的x、y、z坐标以达到动画的效果
    // 注意因为positionCoords是GLKVector3类型，所以你可以使用x\y\z代表它的坐标，也可以取数组V的值来代表它对应的坐标
    if (_shouldAnimate) {
        int i;
        for (i = 0; i<3; i++) {
            vertices[i].positionCoords.v[0] += movementVector3[i].v[0] ;
            //判断是否碰到边界
            if (vertices[i].positionCoords.v[0]  >= 1.0f || vertices[i].positionCoords.v[0]  <= -1.0f) {
                movementVector3[i].x = -movementVector3[i].v[0] ;
            }
            vertices[i].positionCoords.y += movementVector3[i].y;
            if (vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f) {
                movementVector3[i].y = -movementVector3[i].y;
            }
            vertices[i].positionCoords.z += movementVector3[i].z;
            if (vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f) {
                movementVector3[i].z = -movementVector3[i].z;
            }
        }
    }else{
        int i;
        for (i = 0; i<3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    //这部分是纹理动画相关 调整2D纹理坐标的坐标 以滑动纹理并显示纹理重复
    //这里textureCoords是GLKVector2类型，所以可以使用s\t代表对应的纹理坐标，也可以用V数组取值代替对应的值
    int i;
    for (i = 0; i < 3; i++) {
        vertices[i].textureCoords.s = (defaultVertices[i].textureCoords.s + _sCoordinateOffset);
        vertices[i].textureCoords.v[0] = (defaultVertices[i].textureCoords.v[0] + _sCoordinateOffset);
    }
    
    
}

//更新
- (void) updateTextureParameters {
    //重复渲染
    [self glkSetProperty:self.baseEffect.texture2d0.target name:self.baseEffect.texture2d0.name parameter:GL_TEXTURE_WRAP_S value:(self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE )];
    
    //线性滤镜相关
    [self glkSetProperty:self.baseEffect.texture2d0.target name:self.baseEffect.texture2d0.name parameter:GL_TEXTURE_MAG_FILTER value:(self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)];
}

//重新设置绑定的数据。vertices对应着相关的位置和纹理数据
- (void) glReset {
    //绑定缓存
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //复制数据到上下文绑定的缓存中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}

// 更新纹理（注意：这里的target和name就是纹理GLKTextureInfo的相关数据，只是缓存在baseEffect中），
- (void) glkSetProperty:(GLKTextureTarget)target name:(GLuint) name parameter:(GLenum)parameterID value:(GLint)value {
    //绑定缓存
    glBindBuffer(target, name);
    //设置取样和循环样式
    glTexParameteri(target, parameterID, value);
}


@end
