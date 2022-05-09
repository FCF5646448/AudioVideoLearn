//
//  Triangle.cpp
//  绘制三角形
//
//  Created by 冯才凡 on 2022/4/1.
//

#include "Triangle.hpp"
#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

Triangle::Triangle(void) {
    std::cout << "构造函数";
}

Triangle::~Triangle(void) {
    std::cout << "析构函数";
}

void Triangle::drawTriangle(float* vertices) {
    // 0 生成顶点缓冲对象VBO，第二个参数就是缓存区独一无二的ID
//    unsigned int VBO, VAO;
    glGenBuffers(1, &VBO);
    glGenVertexArrays(1, &VAO);
    // 绑定VAO对象
    glBindVertexArray(VAO);
    
    // 绑定到缓冲
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    // 将顶点数据复制到缓存内存中：第4个参数是表示如果管理给定的顶点数据。一共有3种类型：GL_STATIC_DRAW：不变，GL_DYNAMIC_DRAW:动态的；GL_STREAM_DRAW：每次绘制都会改变
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // 1 设置顶点属性指针
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    
    // 解绑
    glBindVertexArray(0);
    
    
    // glsl 着色器源码: 顶点着色器
    const char* vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "}\0";
    
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
        std::cout << "error::SHADER::VERTEXT::COMPILEFAILED\n" << infoLog << std::endl;
    }
    
    // GLSL 片段着色器
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
    
    // 查看编译结果
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "error::SHADER::FRAGMENT::COMPILEFAILED\n" << infoLog << std::endl;
    }
    
    // 着色器程序: 将着色器程序连接成着色器程序对象
//    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    // 将着色器附加到程序对象上
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    // 连接
    glLinkProgram(shaderProgram);
    
    // 查看连接结果
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "error::SHADER::PROGRAM::LINK_FAILED\n" << infoLog << std::endl;
    }
    glUseProgram(shaderProgram);
    
    // 删除着色器。
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
}

void Triangle::draw() {
    // 激活 相当于将顶点数据发送给GPU了
    glUseProgram(shaderProgram);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glBindVertexArray(0);
}
