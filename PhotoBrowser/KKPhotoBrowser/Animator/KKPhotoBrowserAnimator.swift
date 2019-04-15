//
//  KKPhotoBrowserAnimator.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/16.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

class KKPhotoBrowserAnimator: NSObject {
    
    /// 接触转场当前显示的图像视图
    var fromImageView: UIImageView?
    
    init(photos: KKPhotoBrowserPhotos) {
        self.photos = photos
    }
    
    private let photos: KKPhotoBrowserPhotos
    
    fileprivate var isPresenting: Bool = false
    
    /// 生成 dummy 图像视图
    fileprivate var dummyImageView: UIImageView {
        let iv = UIImageView(image: dummyImage)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }
    
    /// 生成 dummy 图像
    private var dummyImage: UIImage {
        return photos.parentImageViews[photos.selectedIndex].image!
    }
    
    /// 父视图参考图像视图
    fileprivate var parentImageView: UIImageView {
        return photos.parentImageViews[photos.selectedIndex]
    }
    
    /// 根据图像计算展现目标尺寸
    fileprivate func presentRectWithImageView(_ imageView: UIImageView) -> CGRect {
        let image = imageView.image
        guard image != nil else { return imageView.frame }
        
        let screenSize = UIScreen.main.bounds.size
        var imageSize = screenSize
        
        imageSize.height = image!.size.height * imageSize.width / image!.size.width
        
        var rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        if imageSize.height < screenSize.height {
            rect.origin.y = (screenSize.height - imageSize.height) * 0.5
        }
        
        return rect
    }
}

extension KKPhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresenting ? presentTransition(using: transitionContext) : dismissTransition(using: transitionContext)
    }
    
    func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.black
        let dummyIV = dummyImageView
        let parentIV = parentImageView
        
        dummyIV.frame = containerView.convert(parentIV.frame, from: parentIV.superview)
        containerView.addSubview(dummyIV)
        
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        containerView.addSubview(toView)
        toView.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dummyIV.frame = self.presentRectWithImageView(dummyIV)
        }) { (finished) in
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                toView.alpha = 1.0
            }) { (finished) in
                dummyIV.removeFromSuperview()
                
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        let dummyIV = dummyImageView
        if let fromIV = fromImageView {
            dummyIV.frame = containerView.convert(fromIV.frame, from: fromIV.superview)
        }
        
        dummyIV.alpha = fromView.alpha
        
        containerView.addSubview(dummyIV)
        fromView.removeFromSuperview()
        
        let parentIV = parentImageView
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dummyIV.frame = containerView.convert(parentIV.frame, from: parentIV.superview)
            dummyIV.alpha = 1.0
        }) { (finished) in
            dummyIV.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

extension KKPhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    @available(iOS 2.0, *)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    
    @available(iOS 2.0, *)
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
