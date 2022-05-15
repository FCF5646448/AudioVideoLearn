//
//  main.cpp
//  4绘制两个三角形(作业01)
//
//  Created by 冯才凡 on 2022/5/15.
//

#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

const unsigned int SCREEN_WIDTH = 800;
const unsigned int SCREEN_HEIGHT = 600;

void framebuffer_size_callback(GLFWwindow *window, int width, int height);
void processInput(GLFWwindow *window);

// glsl 着色器源码: 顶点着色器
const char * vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "   gl_PointSize = 20.0f;\n" // 设置顶点大小
    "}\0";
// glsl 着色器源码: 片段着色器
const char *fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "void main()\n"
    "{\n"
    "   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\n";

int main(int argc, const char * argv[]) {
    
    // 初始化glfw
    glfwInit();
    // major 版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    // minor 次版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    // 核心模式
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    // 窗口窗口
    GLFWwindow* window = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "绘制两个三角形(作业01)", NULL, NULL);
    if (window == NULL) {
        std::cout << "初始化窗口失败" << std::endl;
        glfwTerminate();
        return -1;
    }
    
    // 将窗口上下文设置成当前线程上下文
    glfwMakeContextCurrent(window);
    
    // 初始化glad
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "初始化glad失败" << std::endl;
        glfwTerminate();
        return  -1;
    }
    
    // 监听窗口大小
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    
    // -------------------------------------
    // 顶点着色器
    unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    //
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    //
    glCompileShader(vertexShader);
    
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout << "error::SHADER::VERTEXT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "error::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    unsigned int shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    glGetShaderiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        std::cout << "error::SHADER::PROGRAM::LINK_FAILED\n" << infoLog << std::endl;
    }
    
    // -------------------------------------
    float vertices[] = {
        // 第一个三角形
        -0.5f, 0.5f, 0.0f,
        -0.75f, -0.5f, 0.0f,
        -0.25f, -0.5f, 0.0f,
        
        // 第2个三角形
        0.5f, 0.5f, 0.0f,
        0.75f, -0.5f, 0.0f,
        0.25f, -0.5f, 0.0f,
    };
    
    unsigned int VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    unsigned int VAO;
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    
    glEnable(GL_PROGRAM_POINT_SIZE); // 启用顶点, 大小与着色器源码的pointsize是一样的
    
    // 设置绘制模式：线框——GL_LINE，填充——GL_FILL
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    while (!glfwWindowShouldClose(window)) {
        processInput(window);
        // 渲染指令
        // glClearColor 是一个状态设置函数，用来设置清空屏幕所用的颜色。
        // glClear 是一个状态使用函数，它所接受的参数是一个buffer。这里表示用glClearColor设置的颜色来清空当前window。
        // 这里需要额外理解清空的意思：因为clear并不是移除掉了window，而只是将window里的内容清除掉。假设不调用clearColor函数，直接调用clear，最终window是被设置成了默认的黑色。
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);
        glDrawArrays(GL_POINTS, 0, 6);
        glDrawArrays(GL_LINE_LOOP, 0, 6); // 绘制闭合的线
//        glDrawArrays(GL_TRIANGLES, 0, 6);
        
        // 交换缓冲
        glfwSwapBuffers(window);
        // 检测事件
        glfwPollEvents();
    }
    
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &VAO);
    
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
