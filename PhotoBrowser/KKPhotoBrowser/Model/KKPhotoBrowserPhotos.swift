//
//  KKPhotoBrowserPhotos.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/16.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

class KKPhotoBrowserPhotos {
    
    /// 选中照片索引
    var selectedIndex: Int
    
    /// 照片 url 字符串数组
    let urls: Array<String>
    
    /// 父视图图像视图数组，便于交互转场
    let parentImageViews: Array<UIImageView>
    
    init(selectedIndex: Int, urls: Array<String>, parentImageViews: Array<UIImageView>) {
        self.selectedIndex = selectedIndex
        self.urls = urls
        self.parentImageViews = parentImageViews
    }
}
