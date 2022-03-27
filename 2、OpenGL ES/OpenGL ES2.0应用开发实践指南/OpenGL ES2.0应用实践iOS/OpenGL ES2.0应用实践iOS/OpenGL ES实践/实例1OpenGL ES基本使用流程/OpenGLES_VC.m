//
//  OpenGLES_VC.m
//  OpenGL ES2.0应用实践iOS
//
//  Created by 冯才凡 on 2019/11/30.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "OpenGLES_VC.h"


typedef struct {
    GLKVector3 positionCoords; //三角顶点坐标
}SceneVertex;

@interface OpenGLES_VC ()
{
    //用于缓存OpenGL ES标识符
    GLuint vertexBufferID;
}

//着色器
@property (strong, nonatomic) GLKBaseEffect * baseEffect;

@end

@implementation OpenGLES_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    GLKView * view = (GLKView *)self.view;
    
    //1、创建OpenGL ES 2.0 上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //将上下文设置为当期。（在OpenGL ES配置或渲染发生之前，必须先设置这一步，因为一个应用可以使用多个上下文。）
    [EAGLContext setCurrentContext:view.context];
    
    //2、创建着色器。（它会在需要的时候自动构建GPU程序）
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //着色器是否使用恒定不变的颜色（则整个绘制范围都是同一个颜色）
    self.baseEffect.useConstantColor = GL_TRUE;
    //设置着色器颜色
    self.baseEffect.constantColor = GLKVector4Make(0.0, 1.0, 0.0, 1.0);//RGBA
    //设置上下文背景色。（之所以叫做clear，是因为是在帧缓存被清除时初始化的每个像素颜色值）
    glClearColor(1.0, 0.0, 0.0, 1.0);
    
    //3、 以下步骤就是：在CPU内存中创建顶点数据。然后OpenGL ES创建一个缓存，以供GPU单独使用。
    // 3.0、先准备好数据：三个顶点坐标分别对应（x,y,z）
    // 适当修改坐标可以发现 OpenGL ES的原点是在屏幕的正中央,整个坐标系是从(-1，1)的范围
    static const SceneVertex vertices[] = {
        {{0.0f,0.0f,0.0}},
        {{-0.5f,-0.5f,0.0}},
        {{-0.5f,0.5f,0.0}}
    };
    
    // 3.1、 生成标识符 参数1是标识符数量。（这里就是一个标识符被生成，并保存在vertexBufferID地址中）
    glGenBuffers(1, &vertexBufferID);
    // 3.2、 绑定缓存 (个人理解应该是用标识符标识一段空间)
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    // 3。3、 复制顶点数据到当前上下文所绑定的缓存中。（前三个参数是copy左右，最后一个参数则是告诉上下文，这段缓存未来会被怎么使用，GL_STATIC_DRAW则说明缓存内的数据不会被频繁改变，促使OpenGL ES以适当的方式来处理缓存的存储）
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}

/*
 实现GLKViewDelegate所需的方法。当不子类化GLKView时，应该使用这个draw方法变量。
 如果GLKView对象已经被子类化并实现了-(void)drawRect:(CGRect)rect，则不会调用此方法。
 
 打断点可以看到，第一次被调用的路径是[CALayer display]——>[GLKView display]-> [opengles_vc glkView: drawInRect:]
 可以看到这个流程和CALayer的绘制流程是一样的：
 [CALayer setNeedDisplay]——>
 [CALayer display]——>
 [layer.delegate respondsToSelector:@selector(displayer)](是否实现异步绘制)—no—>
 layer.delegate(UIView) -yes->
 [layer.delegate draw:inContext:](这一步可在VC上拦截实现，像当前函数一样) --->
 [UIView drawRect]
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //准备绘制 （不调用，不会进行绘制）
    [self.baseEffect prepareToDraw];
    
    //设置glClearColor颜色生效（不执行这句，上面设置的glClearColor背景色不生效）
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 3.4、启动顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // 3.5、设置指针（参数1：表示当前指针包含每个顶点位置信息，参数2：每个位置有3个部分，参数3：每个部分为浮点数值，参数4：告诉OpenGL ES小数点固定数据是否可以被改变，参数5：每个顶点的保存需要的字节数，参数6：NULL表示可以从当前绑定的顶点缓存的开始位置访问顶点数据）
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL);
    // 3.6、执行绘画（参数1：表示是一个三角形，参数二表示需要渲染的第一个顶点的位置，参数3表示需要渲染的顶点数量）
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}


@end
