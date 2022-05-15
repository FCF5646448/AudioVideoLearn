//
//  main.cpp
//  5绘制三角形(作业02:使用不同VAO和VBO)
//
//  Created by 冯才凡 on 2022/5/15.
//

#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

void observerWindowFrameChanged(GLFWwindow* window, int width, int height);

void observerInputAction(GLFWwindow* window);

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
    
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    GLFWwindow* window = glfwCreateWindow(800, 600, "使用不同的VAO和VBO绘制两个三角形", NULL, NULL);
    if (window == NULL) {
        std::cout << "窗口创建失败" << std::endl;
        glfwTerminate();
        return  -1;
    }
    // 窗口设置成线程上下文
    glfwMakeContextCurrent(window);
    
    // 初始化GLAD
    if (!gladLoadGLLoader((GLADloadproc) glfwGetProcAddress)) {
        std::cout << "GLAD初始化失败" << std::endl;
        glfwTerminate();
        return -1;
    }
    // 监听窗口大小
    glfwSetFramebufferSizeCallback(window, observerWindowFrameChanged);
    
    //-----------------------------------------------------
    unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    unsigned int shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    //-----------------------------------------------------
    
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
    
    unsigned int VBOS[2];
    glGenBuffers(2, VBOS); // 创建2个VBO
    
    unsigned int VAOS[2];
    glGenVertexArrays(2, VAOS); // 创建2个VAO
    
    glBindVertexArray(VAOS[0]);
    glBindBuffer(GL_ARRAY_BUFFER, VBOS[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    // 第二个
    glBindVertexArray(VAOS[1]);
    glBindBuffer(GL_ARRAY_BUFFER, VBOS[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)(9 * sizeof(float)));
    glEnableVertexAttribArray(0);
    
    while (!glfwWindowShouldClose(window)) {
        observerInputAction(window);
        
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        glUseProgram(shaderProgram);
        
        // 第1个三角形
        glBindVertexArray(VAOS[0]);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        // 第2个三角形
        glBindVertexArray(VAOS[1]);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        // 交换缓存
        glfwSwapBuffers(window);
        // 检测事件
        glfwPollEvents();
    }
    
    glDeleteVertexArrays(2, VAOS);
    glDeleteBuffers(2, VBOS);
    glDeleteProgram(shaderProgram);
    glfwTerminate();
    return 0;
}

void observerWindowFrameChanged(GLFWwindow* window, int width, int height) {
    glViewport(0, 0, width, height);
}

void observerInputAction(GLFWwindow* window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}
