//
//  main.cpp
//  OpenGL001
//
//  Created by 冯才凡 on 2021/8/15.
//

#include <iostream>
#include <glad/glad.h> //注意要优于glfw引入
#include <GLFW/glfw3.h>

// 回调函数声明
void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);

int main(int argc, char * argv[]) {
    glfwInit(); // 初始化glfw
    // glfwWindowHint glfw配置函数
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3); // MAJOR: 版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3); // MINOR: 次版本号
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); // PROFILE: OpenGL模式 ， CORE_PROFILE 核心模式
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); //Mac 系统的特殊配置
    
    // 创建窗口：宽、高、窗口名称
    GLFWwindow *window = glfwCreateWindow(800, 600, "绘制窗口", NULL, NULL);
    if (window == NULL) {
        printf("Failed to create GLFW window");
        glfwTerminate(); // 关闭所有资源
        return -1;
    }
    // 将窗口上下文设置成当前线程上下文
    glfwMakeContextCurrent(window);
    
    // 初始化GLAD，调用OpenGL函数之前需先进行GLAD的初始化
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        printf("failed to initialize GLAD");
        return -1;
    }
    
    // 注册窗口变化监听函数。
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    
    
    // 渲染循环
    // glfwWindowShouldClose 判断glfw是否将要关闭。如果将要关闭，就交换缓存区。
    while (!glfwWindowShouldClose(window)) {
        processInput(window);
        
        // 渲染指令
        // glClearColor 是一个状态设置函数，用来设置清空屏幕所用的颜色。
        // glClear 是一个状态使用函数，它所接受的参数是一个buffer。这里表示用glClearColor设置的颜色来清空当前window。
        // 这里需要额外理解清空的意思：因为clear并不是移除掉了window，而只是将window里的内容清除掉。假设不调用clearColor函数，直接调用clear，最终window是被设置成了默认的黑色。
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        
        // 交换缓冲 （双缓冲，类似iOS的屏幕缓冲机制）
        glfwSwapBuffers(window);
        // 检查是否触发什么事件
        glfwPollEvents();
    }
    
    // 关闭所有资源
    glfwTerminate();
    return 0;
}

void framebuffer_size_callback(GLFWwindow *window, int width, int height) {
    // 渲染窗口：前两个是左下角坐标
    glViewport(0, 0, width, height);
}

void processInput(GLFWwindow *window) {
    // 检查是否按下了esc键
    // glfwGetKey 会判断在当前窗口状态下，第二个参数（一个按键）是否被按下
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        // 将窗口 shouldClose设置为true
        glfwSetWindowShouldClose(window, true);
    }
}
