//
//  PhotoUrls.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/15.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import Foundation

class PhotoUrls {
    
    static func photos(count: Int) -> Array<String> {
        var pic_urls: Array<String> {
            return ["http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehvujq1j218g0p0qai.jpg",
                    "http://wx4.sinaimg.cn/mw690/6bea75f6gy1fgrjyberl7j20hu1zcu0x.jpg",
                    "http://ww2.sinaimg.cn/bmiddle/e67669aagw1f1v6w3ya5vj20hk0qfq86.jpg",
                    "http://ww3.sinaimg.cn/bmiddle/61e36371gw1f1v6zegnezg207p06fqv6.gif",
                    "http://ww4.sinaimg.cn/bmiddle/7f02d774gw1f1dxhgmh3mj20cs1tdaiv.jpg",
                    "http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehod8k8j218g0p0tge.jpg",
                    "http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehp1eufj218g0p0n7q.jpg",
                    "http://ww1.sinaimg.cn/bmiddle/72635b6agw1eyqehqasdtj218g0p0137.jpg",
                    "http://ww3.sinaimg.cn/bmiddle/72635b6agw1eyqehrq346j218g0p0wtu.jpg",
                    "http://ww1.sinaimg.cn/bmiddle/72635b6agw1eyqehsq3fej218g0p0k58.jpg",
                    "http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehtr8xqj218g0p07au.jpg",
                    "http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehui24lj218g0p0te5.jpg",
                    "http://ww3.sinaimg.cn/bmiddle/72635b6agw1eyqehvacmuj218g0p00wv.jpg"]
        }
        assert(count >= 0 && count < pic_urls.count, "out of range!")
        var photos = [String]()
        for i in 0..<count {
            photos.append(pic_urls[i])
        }
        return photos
    }
    
}
