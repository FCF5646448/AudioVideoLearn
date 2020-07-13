---
title: iOS-AVFoundation学习笔记之整体框架
date: 2020-7-12 11:00:00
tags: avfoundation
categories: iOS音视频专题
description:  主要学习iOS AVFoundation的整体架构。
---

### 音频
* 格式：
	* PCM：对声音采样、量化的过程叫做脉冲编码调制，简称PCM。所以它也是一种音频最原始的数据格式，体量大、音质优秀。所以也就随之产生了很多其他压缩格式。主要分为有损压缩格式和无损压缩格式；
	* MP3：是一种有损压缩格式，它舍弃了PCM数据中人类听觉不敏感的部分。
	* AAC：
* Audio Session：
AVAudioSession用来管理APP里的音频会话。当APP启动时，会自动激活一个Audio session的单例对象。不过也可以手动激活。
Audio Session category代表音频的行为。

#### 音频采集
https://juejin.im/post/5d29d884f265da1b971aa220#heading-12


#### 音频播放
https://juejin.im/user/5d4ecf016fb9a06af372a85e/posts


#### 音频处理


### 视频
#### 


