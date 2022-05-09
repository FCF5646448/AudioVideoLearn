//
//  main.cpp
//  绘制三角形
//
//  Created by 冯才凡 on 2022/3/31.
//

#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include "Triangle.hpp"

void observerWindowFrameChanged(GLFWwindow* window, int width, int height);
void observerInput(GLFWwindow* window);
void drawTriangle();

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
    GLFWwindow* window = glfwCreateWindow(800, 600, "绘制三角形", NULL, NULL);
    if (window == NULL) {
        glfwTerminate();
        return  -1;
    }
    
    glfwMakeContextCurrent(window);
    
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "初始化glad失败";
        return -1;
    }
    
    glfwSetFramebufferSizeCallback(window, observerWindowFrameChanged);
    
    float test[] = {
       -0.5f, -0.5f, 0.0f,
       0.5f, -0.5f, 0.0f,
       0.0f, 0.5f, 0.0f
    };
    Triangle triangle;
    triangle.drawTriangle(test);
    
    while (!glfwWindowShouldClose(window)) {
        
        observerInput(window);
        
        glClearColor(0.2f, 0.3f, 0.3f, 0.3f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        triangle.draw();
    
        glfwSwapBuffers(window); // 交换缓存
        glfwPollEvents(); // 事件检测
    }
    
    
    
    glfwTerminate();
    return 0;
}

void observerWindowFrameChanged(GLFWwindow* window, int width, int height) {
    glViewport(0, 0, width, height);
}

void observerInput(GLFWwindow* window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE)) {
//        glfwSetWindowShouldClose(window, true);
    }
}

void drawTriangle() {
    
}
