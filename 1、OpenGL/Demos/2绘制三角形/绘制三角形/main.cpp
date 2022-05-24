//
//  main.cpp
//  绘制三角形01（VBO）
//
//  Created by 冯才凡 on 2022/5/14.
//

#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

void observerWindowFrameChanged(GLFWwindow* window, int width, int height);
void observerInput(GLFWwindow* window);

const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

// glsl 着色器源码: 顶点着色器
const char * vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n" // vec3 是一种类型，表示3个参数的向量。location应该是表示从哪个点开始绘制
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "}\n";
// GLSL 片段着色器
const char *fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "void main()\n"
    "{\n"
    "   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\n";

int main(int argc, const char * argv[]) {
    // 初始化glfw
    glfwInit();
    // MAJOR: 版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    // MINOR: 次版本号
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    // 核心模式
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#ifdef __APPLE__
    // Mac特殊配置
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    // 窗口窗口
    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "单纯VBO绘制三角形", NULL, NULL);
    if (window == NULL) {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, observerWindowFrameChanged);
    
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "初始化glad失败" << std::endl;
        glfwTerminate();
        return -1;
    }
    
    //------------------------------------------
    // 创建顶点着色器
    unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    // 将着色器源码附着在着色器对象上
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    // 编译
    glCompileShader(vertexShader);
    
    int success;
    char infoLog[512];
    // 获取编译结果
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        std::cout << "顶点着色器编译失败" << std::endl;
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
    }
    
    // 片段着色器
    unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    // 将源码附着到着色器对象上
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    // 编译
    glCompileShader(fragmentShader);
    
    //获取编译结果
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        std::cout << "片段着色器编译失败" << std::endl;
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
    }
    
    // 着色器程序
    unsigned int shaderProgram = glCreateProgram();
    // 将着色器附加到程序上
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    // 连接
    glLinkProgram(shaderProgram);
    
    //获取连接结果
    glGetShaderiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        std::cout << "着色器程序连接失败" << std::endl;
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
    }
    
    //
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    // --------------------------------------------------------
    
    float vertices[] = {
        -0.5f, -0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
         0.0f,  0.5f, 0.0f
    };
    
    // 生成顶点缓冲对象VBO，第二个参数就是缓存区独一无二的ID
    unsigned int VBO;
    // 生成顶点缓冲对象
    glGenBuffers(1, &VBO);
    
    // 顶点数据对象
    unsigned int VAO;
    glGenVertexArrays(1, &VAO);
    // 绑定VAO对象，后续绘制就不需使用VBO了
    glBindVertexArray(VAO);
    
    
    // 将顶点缓冲对象VBO绑定到缓冲GL_ARRAY_BUFFER目标上
    // GL_ARRAY_BUFFER 缓冲对象类型：这里是指顶点缓冲对象类型
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    // glBufferData将顶点数据复制到缓存内存GL_ARRAY_BUFFER中：
    // 第4个参数是表示如果管理给定的顶点数据。一共有3种类型：GL_STATIC_DRAW：不变，GL_DYNAMIC_DRAW:动态的；GL_STREAM_DRAW：每次绘制都会改变
    // 注意这个动作需在GL_ARRAY_BUFFER被绑定之后（如果将代码移到glBindBuffer前会导致崩溃）
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // --------------------------------------------------------
    // glVertexAttribPointer：告诉OpenGL应该如何解析顶点数据
    // 参数0：指定顶点属性，与着色器源码的layout (location = 0)是对应的
    // 3表示每个顶点是有3个值组成的。与 vec3 类型的大小一一对应
    // GL_FLOAT 表示每个vec3顶点的数据类型
    // GL_FALSE 是否需要被标准化
    // 步长：连续的顶点之间的间隔
    // 偏移量
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
    // 启用顶点属性 1 与 glVertexAttribPointer 函数的第一个参数一致
    glEnableVertexAttribArray(0);
    
    // 解绑 VBO 和 VAO
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    
    // 设置绘制模式：线框——GL_LINE，填充——GL_FILL
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    
    while (!glfwWindowShouldClose(window)) {
        observerInput(window);
        glClearColor(0.2f, 0.3f, 0.3f, 0.3f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &VAO);
    
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
