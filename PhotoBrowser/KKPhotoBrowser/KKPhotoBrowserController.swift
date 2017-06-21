//
//  KKPhotoBrowserController.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/16.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

class KKPhotoBrowserController: UIViewController {
    
    var photos: KKPhotoBrowserPhotos
    var statusBarHidden: Bool = false
    
    let animator: KKPhotoBrowserAnimator
    
    var currentViewer: KKPhotoViewerController?
    
    var zoomOut_In: Bool = true
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 60))
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.transform = CGAffineTransform(scaleX: 0, y: 0)
        return label
    }()
    
    init(selectedIndex: Int, urls: Array<String>, parentImageViews: Array<UIImageView>) {
        photos = KKPhotoBrowserPhotos(selectedIndex: selectedIndex, urls: urls, parentImageViews: parentImageViews)
        animator = KKPhotoBrowserAnimator(photos: photos)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = animator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setNeedsSztatusBarAppearanceUpdate()
        prepareUI()
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
     //MARK: - 监听方法
    @objc private func singleTapGesture() {
        animator.fromImageView = currentViewer?.imageView
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doubleTapGesture(recognizer: UIGestureRecognizer) {
        var scale: Float
        if zoomOut_In {
            scale = 2.0
            zoomOut_In = false
        } else {
            scale = 1.0
            zoomOut_In = true
        }
        
        func zoomRectFor(scale: CGFloat, center: CGPoint) -> CGRect {
            var zoomRect = CGRect()
            zoomRect.size.height = currentViewer!.scrollView.frame.size.height / scale
            zoomRect.size.width = currentViewer!.scrollView.frame.size.width / scale
            zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
            zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
            return zoomRect
        }
        
        let zoomRect = zoomRectFor(scale: CGFloat(scale), center: recognizer.location(in: recognizer.view))
        currentViewer?.scrollView.zoom(to: zoomRect, animated: true)
    }
    
    @objc private func interactionGesture(recognizer: UIGestureRecognizer) {
        
        statusBarHidden = (currentViewer!.scrollView.zoomScale > 1.0)
        
        if statusBarHidden {
            view.backgroundColor = .black
            view.transform = CGAffineTransform.identity
            view.alpha = 1.0
            
            return
        }
        
        var transform = view.transform
        
        if recognizer.isKind(of: UIPinchGestureRecognizer.self) {
            let pinch = recognizer as! UIPinchGestureRecognizer
            let scale = pinch.scale
            
            transform = transform.scaledBy(x: scale, y: scale)
            pinch.scale = 1.0
        } else if recognizer.isKind(of: UIRotationGestureRecognizer.self) {
            let rotate = recognizer as! UIRotationGestureRecognizer
            
            let rotation = rotate.rotation
            transform = transform.rotated(by: rotation)
            rotate.rotation = 0
        }
        
        switch recognizer.state {
        case .began,.changed:
            view.backgroundColor = .clear
            view.transform = transform
            view.alpha = transform.a
        case .cancelled,.failed,.ended:
            singleTapGesture()
        default:
            break
        }
    }
    
    @objc private func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state != .began else {
            return
        }
        
        guard currentViewer?.imageView.image != nil else {
            return
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "保存至相册", style: .destructive, handler: { (action) in
            UIImageWriteToSavedPhotosAlbum(self.currentViewer!.imageView.image!, self, #selector(self.image(image:DidFinishSavingWithError:contextInfo:)), nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func image(image: UIImage, DidFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        messageLabel.text = (error == nil) ? "保存成功" : "保存失败"
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.messageLabel.transform = CGAffineTransform.identity
        }) { (completion) in
            UIView.animate(withDuration: 0.5, animations: {
                self.messageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            })
        }
    }
    
    fileprivate func viewerWithIndex(_ index: Int) -> KKPhotoViewerController {
        return KKPhotoViewerController(urlString: photos.urls[index], photoIndex: index, placeholder: photos.parentImageViews[index].image!)
    }
    
    //MARK: - 设置UI
    private func prepareUI() {
        view.backgroundColor = .black
        
        // 分页控制器
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey:20])
        pageController.dataSource = self
        pageController.delegate = self
        
        let viewer = viewerWithIndex(photos.selectedIndex)
        pageController.setViewControllers([viewer], direction: .forward, animated: true, completion: nil)
        
        view.addSubview(pageController.view)
        addChildViewController(pageController)
        pageController.didMove(toParentViewController: self)
        
        currentViewer = viewer
        
        // 手势
        view.gestureRecognizers = pageController.gestureRecognizers
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(interactionGesture(recognizer:)))
        view.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(interactionGesture(recognizer:)))
        view.addGestureRecognizer(rotate)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
        view.addGestureRecognizer(longPress)
        
        pinch.delegate = self
        rotate.delegate = self
        //提示标签
        view.addSubview(messageLabel)
        messageLabel.center = view.center
    }

}

extension KKPhotoBrowserController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! KKPhotoViewerController).photoIndex
        index-=1
        
        if index < 0 {
            return nil
        }
        
        return viewerWithIndex(index)
    }
    
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! KKPhotoViewerController).photoIndex
        index+=1
        
        if index >= photos.urls.count {
            return nil
        }
        
        return viewerWithIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            
            if let viewer = pageViewController.viewControllers?[0] as? KKPhotoViewerController {
                photos.selectedIndex = viewer.photoIndex
                currentViewer = viewer
            }
        }
    }
}

extension KKPhotoBrowserController: UIGestureRecognizerDelegate {
    @available(iOS 3.2, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


