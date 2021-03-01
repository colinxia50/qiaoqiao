# 说明

flutter/dart 本意是给家里小孩学算术题，但开发完后装机使用反应冷淡，毫无兴趣，没多久就给卸载了 。。。。。。所以没就兴趣完善下去了，代码写的有点随意，随意到现在本人也看不懂。。。
对flutter感兴趣的同学也许有参考意义

## 仿微信聊天页面-聊天机器人，

使用微信开放平台的接口，只是基本实现聊天功能，语音功能未开发完，没考虑渲染性能，没优化，问题待完善

![聊天机器人](https://github.com/colinxia50/qiaoqiao/blob/master/show/4.png "聊天机器人")



## 算术小能手

玩法：拖动数字组合等式使成立，笑脸确定，哭脸重置，如1*1+1-1=1也是可以的，支持无限运算。
开启计时所有颜色会随机变化。（花里胡哨的）

![算术小能手](https://github.com/colinxia50/qiaoqiao/blob/master/show/3.png "算术小能手")

## 拼图

点击拼图按钮会剪切成一个四宫格可拖动的组件，九宫格的话可以自行研究下下

![拼图](https://github.com/colinxia50/qiaoqiao/blob/master/show/2.png "拼图")

## 看故事

PageView组件，点击进入详情页，可无限翻页（也许）

![看故事](https://github.com/colinxia50/qiaoqiao/blob/master/show/1.png "看故事")


## 运行方式

- 查看一下版本号是否正确
```dart
  flutter --version
```
- 运行查看是否需要安装其它依赖项来完成安装
```dart
  flutter doctor
```
- 运行启动您的应用
```dart
  flutter packages get 
  flutter run
```




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
