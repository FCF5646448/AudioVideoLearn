//
//  main.cpp
//  8着色器（uniform）
//
//  Created by 冯才凡 on 2022/5/18.
//

#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <cmath>

void observerWindowFrameChanged(GLFWwindow* window, int width, int height);
void observerInput(GLFWwindow* window);

const char* vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "out vec4 vertexColor;\n" // 输出一个vec4类型的颜色
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos, 1.0);\n" // 把一个vec3作为vec4的构造器
    "   vertexColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);\n"
    "}\n";

const char* fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "uniform vec4 ourColor;\n" // 声明一个uniform变量
    "void main()\n"
    "{\n"
    "   FragColor = ourColor;\n"
    "}\n";

int main(int argc, const char * argv[]) {
    
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    GLFWwindow* window = glfwCreateWindow(800, 600, "着色器 uniform", NULL, NULL);
    glfwMakeContextCurrent(window);
    gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
    glfwSetFramebufferSizeCallback(window, observerWindowFrameChanged);
    
    // ----------------------------------------
    unsigned int vertexShader, fragmentShader, shaderProgram;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    // ----------------------------------------
    unsigned int VBO, VAO;
    glGenBuffers(1, &VBO);
    glGenVertexArrays(1, &VAO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    float vertices[] = {
        // 第一个三角形
        0.0f, 0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    while (!glfwWindowShouldClose(window)) {
        observerInput(window);
        
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        glUseProgram(shaderProgram);
        
        // 更新uniform颜色
            float timeValue = glfwGetTime();
            float greenValue = sin(timeValue) / 2.0f + 0.5f;
            int vertexColorLocation = glGetUniformLocation(shaderProgram, "ourColor");
            glUniform4f(vertexColorLocation, 0.0f, greenValue, 0.0f, 1.0f);
        
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    
    glfwTerminate();
    return 0;
}

void observerWindowFrameChanged(GLFWwindow* window, int width, int height) {
    glViewport(0, 0, width, height);
}

void observerInput(GLFWwindow* window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}
