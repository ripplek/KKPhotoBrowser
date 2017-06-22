# KKPhotoBrowser
纯Swift轻量级的图片浏览器

![](https://img.shields.io/badge/releases-v0.0.2-green.svg) ![](https://img.shields.io/badge/pod-v0.0.2-brightgreen.svg) [![apm](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/ripplek/KKPhotoBrowser/blob/master/LICENSE) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

## Features
##### 单击浏览
![](https://github.com/ripplek/KKPhotoBrowser/blob/master/GIF/singleTap.gif)

##### 双击放大
![doubleTap](https://github.com/ripplek/KKPhotoBrowser/blob/master/GIF/doubleTap.gif)

##### 长按保存到相册
![longPress](https://github.com/ripplek/KKPhotoBrowser/blob/master/GIF/longPress.gif)

##### 捏合放大
![pinch](https://github.com/ripplek/KKPhotoBrowser/blob/master/GIF/pinch.gif)

##### 旋转捏合取消浏览
![rotateAndPinch](https://github.com/ripplek/KKPhotoBrowser/blob/master/GIF/rotateAndPinch.gif)

## Requirements
* iOS9.0+
* Xcode8.0+
* Swift3.0+

## Installation with CocoaPods
通过cocoaPods将KKPhotoBrowser集成到你的项目中，首先要确保你已经安装了cocoaPods，然后执行
`$pod init`
配置`podfile`文件
```
target 'TargetName' do
pod 'KKPhotoBrowser'
end
```
配置完成后执行
`$pod install`
## usage
```
let browserVC = KKPhotoBrowserController(selectedIndex: currentIndex, urls: photoUrls, parentImageViews: cell.visibaleImageViews())
        
present(browserVC, animated: true, completion: nil)
```
