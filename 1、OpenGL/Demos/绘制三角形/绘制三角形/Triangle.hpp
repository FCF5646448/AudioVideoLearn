//
//  Triangle.hpp
//  绘制三角形
//
//  Created by 冯才凡 on 2022/4/1.
//

#ifndef Triangle_hpp
#define Triangle_hpp

#include <stdio.h>

class Triangle {
public:
    unsigned int VBO, VAO;
    unsigned int shaderProgram;
    
    Triangle(void);
    ~Triangle(void);
    void drawTriangle(float vertices[]); // 配置
    void draw();
};

#endif /* Triangle_hpp */
