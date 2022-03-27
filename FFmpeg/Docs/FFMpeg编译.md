---
title: 音视频系统入门
date: 2020-7-24 8:17:00
tags: Design Patterns
categories: 音视频
description:  音视频入门的所有重难点知识点集合
---

### Linux学习与FFmpeg编译
#### Linux学习
##### 基本命令
* ls：查看当前目录所有目录文件，如果要查看隐藏目录，$ ls -a ；
* cd：进入到某个文件夹下，当前文件夹是 . ,上一级文件夹是../。例如进入当前文件夹的某个xxx子文件夹，$  cd ./xxx  ；
* pwd：查看当前所在路径。$  pwd ;
* mkdir：创建文件夹，创建一个名为111的文件夹 $  mkdir 111，创建多级目录 $ mkdir -p 1/2/3，创建文件，touch，例如创建一个名为222.c的文件，​$  touch 222.c；
* cp：拷贝，例如，将222.c的文件拷贝到当前文件夹下，cp ./111/222.c . ;
* sudo：切换用户权限。
* echo：写命令，比如将123写进1.txt文件中，如果不存在1.txt，则会自动创建。 $ echo "12345" >> 1.txt ;
* cat：查看内容。比如查看1.txt文件内容。$ cat 1.txt ;
* pkg-config：
##### 安装命令
* brew：Mac下的软件安装工具。一般工具都会被放置到网上，然后使用brew搜索相应的工具包，搜索到了就进行安装。比如用 drew查找vim：
$ brew sraech vim ; 
可以看到不同的vim相关的软件包和版本。然后进行安装
$ brew install vim；
##### Vim基本操作
* :w 保存文件；
* :q 退出；
* :wq 既保持又退出；
* i 进入编辑模式；
* esc 退出编辑模式；
* h 光标左移；
* j 光标下移；
* k 光标上移；
* l 光标右移；
##### Linux环境变量
* 查看环境变量命令：$:  env | grep PATH

* PATH：当敲击命令的时候，会去path响应的路径查找是否按照命令，如果安装了就去执行，没有安装就会提示没找到。

* PKG_CONFIG_PATH：

* PKG_CONFIG_PATH与LIB_xx的区别？

* 在Mac下，环境变量是设置在~/.bash_profile文件里，设置完成后执行$ source ~/.bash_profile让环境变量生效。

#### Mac 安装编译FFmpeg
* 下载：可以使用brew install FFmpeg。也可以去[官网](http://ffmpeg.org/download.html)下载
* 编译ffmpeg:
下载好FFmpeg后，进入到含有configure文件的位置，执行：$ . / configure -- prefix=/usr/local/ffmpeg --enable-debug=3 --disable-static --enable-shared
这里--prefix是指定安装路径，--enable-debug是为了调试，--disable-static指编译成静态库。
结束完成后，执行​$ make -j 4   这样就开始编译了。
最后执行$ sudo make install 安装到指定目录下。
这样就安装完成了，进到/usr/local/ffmpeg 可以看到bin、include、lib、share等文件夹。
bin：存放ffmpeg命令的所有工具；主要是ffmpeg、ffplay、ffprobe；
include：存放ffmpeg的头文件；
lib：ffmpeg生成的动态库和静态库；
share：就是文档相关的内容和例子；
* 设置环境变量：
```
export FFmpegPath=/usr/local/ffmpeg/bin
export PATH=$PATH:$FFmpegPath
```
#### C语言回顾
* 编译执行：clang -g -o bin xxx.c #意思是把xxx.c编译成bin目标文件. 它会生成一个xxx.dSYM文件，它是一个符号文件。
* 常用基本类型：short、int、long；float、double；char；void；
* 高级类型：数组、结构体、枚举；
	* 数组：char c[2]、int arr[10];一块连续的村出纳空间。
	* 结构体：struct st{
        int a;
        int b;
		};
		结构体其实就是C++中类的概念。
	* 枚举： enum em{
        red_color=0,
        green_color,
        black_color
		};
* 指针：存放内存地址的变量。
* 堆内存分配与释放。
  * 分配：void * men = malloc(size); 
  * 释放：free( men ); 其实释放后依然会可以访问到指针地址，所以一般释放完，需要将指针置为null。
  ```
  char* p = (char *)malloc(10);
        *p = 'a';
        *(p+1) = 'b';
        printf("p:%s\n",p);
        free(p);
        // p = null;
        *p='d'; //如果p置null了。则会crash。
        printf("p:%s\n",p);
  ```
  * 内存空间：**栈空间**：函数栈（主要是参数和变量，无需手动释放）；**堆空间**：使用malloc分配的资源空间，需要自己手动管理内存，使用free释放不使用的内存；**内存映射**：动态库、文件都是通过内存映射。
  * Linux内存地址划分：从低到上：收保护空间——代码段——已初始化全局变量——未初始化全局变量——堆空间——栈空间——命令行参数——环境变量——内核。
  * 内存泄漏与野指针：不断地申请内存，没有释放，就会导致内存泄漏；野指针就是占用了别人的内存。

* 函数：void func(int a){}
	* 函数指针：返回值类型(*指针变量名)([形参列表]); 类似OC的block.
	```
	int func(int x); //声明一个函数
	int (*f) (int x);//声明一个函数指针
	f = func;		 //将func函数的首地址赋给指针f；
	```
* 文件操作
	* 文件类型 FILE* file;
	* 打开文件 FILE* fopen(path, mode);
	* 关闭文件 fclose(FILE*);
	```
	FILE* file = fopen(filename,"w");
	//第二个参数是指每一项的大小，第三个参数是表示有多少项
    size_t len = fwrite("aaaa",1,5,file);
	//读取data到buffer中
	char buffer[1024] = {0,};
    size_t len = fread(buffer, 1, 3, file);
	//关闭
    fclose(file);
	
	```

### 音频
#### 基础
直播"客户端"的处理流程：直播端：音视频采集——音视频编码；观看端：音视频解码——音视频渲染。
* 声音基本信息
	* 音调：声音的频率；
	* 音量：振动的浮动；
	* 音色：谐波；
* 模数转换：将音频模拟信号转成数字信号。然后将数字转成二进制数字，最后生成二进制方波。
* 量化基本概念：
	* 采样大小：一个采样通常用16bit存放；
	* 采样率：常见的是8k、16k、32k、44.1k、48k；
	* 声道数：单声道、双声道、多声道；
	* 码率：采样率*采样大小*声道数。比如一个44.1k采样率的双声道PCM数据码率：44.1K*16*2=1411.2Kb/s.所以这么大的数据肯定无法在网上传输的。

#### 音频数据流。
* PCM：音频原始格式。原始格式；
* WAV：也是音频的原始数据，是在PCM的基础上加了一个头，这个头包含了一些基本的信息；这个头包含了3个部分：大小、格式、采样率、声道数、字节对齐等；
* aac/mp3：编码器编译出相应的编码格式；
* mp4/flv：多媒体文件格式；

#### FFmpeg命令采集音频
$ffmpeg -f avfoundation -i :0 out.wav
解析：-f 指使用的库，后面跟着AVFoundation；-i 指采集目标 使用':'分割，':'前面是视频，后面是音频，这里就表示只采集音频。
#### Mac项目使用ffmpeg
将编译完成的include和libs导入项目中，设置路径，就可以使用了。
* FFmpeg音频采集流程
  打开输入设备——>数据包——>输出文件。

  从设备中读取数据包



#### 音频的处理流程