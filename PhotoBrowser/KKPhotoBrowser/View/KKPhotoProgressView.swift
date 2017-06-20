//
//  KKPhotoProgressView.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/20.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

class KKPhotoProgressView: UIView {
    
    /// 进度
    var progress: Float? {
        didSet {
            print("progress--\(progress!)")
            setNeedsDisplay()
        }
    }
    
    /// 进度颜色
    var progressTintColor: UIColor {
        return UIColor(white: 0.8, alpha: 0.8)
    }
    
    /// 底色
    var trackTintColor: UIColor {
        return UIColor(white: 0.0, alpha: 0.6)
    }
    
    /// 边框颜色
    var borderTintColor: UIColor {
        return UIColor(white: 0.8, alpha: 0.8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard rect.size.width != 0 || rect.size.height != 0 else {
            return
        }
        
        // 如果完成 隐藏
        guard progress! <  1.0 else {
            return
        }
        
        var radius = min(rect.size.width, rect.size.height) * 0.5
        let center = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
        
        // 绘制边框
        borderTintColor.setStroke()
        
        let lineWidth: CGFloat = 2.0
        let borderPath = UIBezierPath(arcCenter: center, radius: radius - lineWidth * 0.5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        borderPath.lineWidth = lineWidth
        
        borderPath.stroke()
        
        // 绘制内圆
        trackTintColor.setStroke()
        radius -= lineWidth * 2
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        trackPath.stroke()
        
        // 绘制进度
        progressTintColor.setStroke()
        
        let start = -Float.pi
        let end = start + progress! * Float.pi * 2
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
        
        progressPath.addLine(to: center)
        progressPath.stroke()
        progressPath.fill()
        
    }
}
