#### AudioToolBox
AudioToolBox是苹果用于音频硬编码的API。

主要的实现步骤是：
* 设置AAC编码器的输入输出格式；
* 创建AAC编码器；
* 转码；
* 得到AAC编码数据后，添加ADTS头。ADTS头用于区分每个AAC数据帧；



