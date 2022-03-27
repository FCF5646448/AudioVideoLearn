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
    GLFWwindow *window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
    if (window == NULL) {
        printf("Failed to create GLFW window");
        glfwTerminate();
        return -1;
    }
    // 将窗口上下文设置成当前线程上下文
    glfwMakeContextCurrent(window);
    
    // 设置视口调整大小时的回调
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    
    // 初始化GLAD
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        printf("failed to initialize GLAD");
        return -1;
    }
    
    // 循环不退出
    while (!glfwWindowShouldClose(window)) {
        processInput(window);
        
        // 渲染指令
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
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}
