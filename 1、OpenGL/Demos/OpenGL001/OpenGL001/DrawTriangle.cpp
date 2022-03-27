//
//  DrawTriangle.cpp
//  OpenGL001
//
//  Created by 冯才凡 on 2021/8/17.
//

#include <iostream>
#include "DrawTriangle.hpp"
#include <glad/glad.h>
#include <GLFW/glfw3.h>

float vertices[] = {
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0f,
    0.0f, 0.5f, 0.0f
};

void drawTriangle() {
    // 创建一个顶点缓冲对象，第二个参数就是缓存区独一无二的ID
    unsigned int VBO;
    glGenBuffers(1, &VBO);
    // 给缓冲对象绑定缓冲类型，GL_ARRAY_BUFFER是顶点缓冲类型，之后操作任何GL_ARRAY_BUFFER都是操作当前VBO缓冲对象
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    // 将顶点数据复制到缓冲的内存中：第4个参数是表示如果管理给定的顶点数据。一共有3种类型：GL_STATIC_DRAW：不变，GL_DYNAMIC_DRAW:动态的；GL_STREAM_DRAW：每次绘制都会改变
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // glsl 着色器源码: 顶点
    const char* vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "void main()\n"
    "{\n"
    "   gl_position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "}\n";
    
    // 创建一个着色器对象
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    // 将着色器源码附着在着色器对象上
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    // 查看编译结果
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        printf("error %s", &infoLog);
    }
    
    // GLSL 片段
    const char *fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "void main()\n"
    "{\n"
    "   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\n";
    
    // 片段着色器
    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    // 着色器程序: 将着色器程序连接成着色器程序对象
    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    // 连接后就可以删除了。
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    // 激活 相当于将顶点数据发送给GPU了
    glUseProgram(shaderProgram);
    
    
    
}
