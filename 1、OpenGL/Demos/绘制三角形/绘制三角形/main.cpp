//
//  main.cpp
//  绘制三角形
//
//  Created by 冯才凡 on 2022/3/31.
//

#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

void observerWindowFrameChanged(GLFWwindow* window, int width, int height);
void observerInput(GLFWwindow* window);

// settings
// 窗口初始化宽高
const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

// glsl 着色器源码: 顶点着色器
const char * vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "}\0";
// GLSL 片段着色器
const char *fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "void main()\n"
    "{\n"
    "   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\n";


int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
#ifdef  __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "绘制三角形", NULL, NULL);
    if (window == NULL) {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return  -1;
    }
    
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, observerWindowFrameChanged);
    
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "初始化glad失败";
        return -1;
    }
    
    
    // -------------------------------------------------------
    // 顶点着色器
    unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER); // 创建着色器程序
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL); // 将着色器源码附着在着色器对象上
    glCompileShader(vertexShader); // 编译
    
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success); // 获取编译结果
    if (!success) {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout << "error::SHADER::VERTEXT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    // 片段着色器
    unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    // 查看编译结果
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "error::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    
    // 连接着色器。
    // 着色器程序: 将着色器程序连接成着色器程序对象
    unsigned int shaderProgram = glCreateProgram();
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
    
    // 连接完成后就可以删除各个着色器了。
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    // 设置顶点数据（和缓冲区）并配置顶点属性
    // --------------------------------------------------------
    float vertices[] = {
        0.5f, 0.5f, 0.0f,   // 右上角
        0.5f, -0.5f, 0.0f,  // 右下角
        -0.5f, -0.5f, 0.0f, // 左下角
        -0.5f, 0.5f, 0.0f   // 左上角
    };

    // 索引数组
    unsigned int indices[] = { // 注意索引从0开始!
        0, 1, 3, // 第一个三角形
        1, 2, 3  // 第二个三角形
    };
    
    // 连接顶点属性
    // 0 生成顶点缓冲对象VBO，第二个参数就是缓存区独一无二的ID
    unsigned int VBO, VAO, EBO;
    glGenBuffers(1, &VBO);
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &EBO);
    // 绑定VAO对象
    glBindVertexArray(VAO);
    
    // 绑定到缓冲
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    // 将顶点数据复制到缓存内存中：第4个参数是表示如果管理给定的顶点数据。一共有3种类型：GL_STATIC_DRAW：不变，GL_DYNAMIC_DRAW:动态的；GL_STREAM_DRAW：每次绘制都会改变
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0); // 设置顶点属性指针
    glEnableVertexAttribArray(0); // 启用顶点属性
    
    // 解绑 VBO 和 VAO
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    // 设置绘制模式：线框——GL_LINE，填充——GL_FILL
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    
    while (!glfwWindowShouldClose(window)) {
        
        observerInput(window);
        
        glClearColor(0.2f, 0.3f, 0.3f, 0.3f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        // 激活 相当于将顶点数据发送给GPU了
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);
//        glDrawArrays(GL_TRIANGLES, 0, 6); //
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    
        glfwSwapBuffers(window); // 交换缓存
        glfwPollEvents(); // 事件检测
    }
    
    // 取消资源分配
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);
    glDeleteProgram(shaderProgram);
    
    glfwTerminate();
    return 0;
}

void observerWindowFrameChanged(GLFWwindow* window, int width, int height) {
    glViewport(0, 0, width, height);
}

void observerInput(GLFWwindow* window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE)) {
        glfwSetWindowShouldClose(window, true);
    }
}
