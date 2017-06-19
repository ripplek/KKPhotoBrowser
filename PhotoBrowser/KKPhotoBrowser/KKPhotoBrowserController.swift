//
//  KKPhotoBrowserController.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/16.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

class KKPhotoBrowserController: UIViewController {
    
    let photos: KKPhotoBrowserPhotos
    
    var statusBarHidden: Bool = false
    
    let animator: KKPhotoBrowserAnimator
    
    var currentViewer: KKPhotoViewerController?
    
    init(selectedIndex: Int, urls: Array<String>, parentImageViews: Array<UIImageView>) {
        photos = KKPhotoBrowserPhotos(selectoedIndex: selectedIndex, urls: urls, parentImageViews: parentImageViews)
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

        prepareUI()
    }
    
     //MARK: - 监听方法
    @objc private func tapGesture() {
        animator.fromImageView = currentViewer?.imageView
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func interactionGesture(recognizer: UIGestureRecognizer) {
        
    }
    
    @objc private func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        
    }
    
    private func viewerWithIndex(_ index: Int) -> KKPhotoViewerController {
        return KKPhotoViewerController(urlString: photos.urls[index], photoIndex: index, placeholder: photos.parentImageViews[index].image!)
    }
    //MARK: - 设置UI
    private func prepareUI() {
        view.backgroundColor = .black
        
        // 分页控制器
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey:20])
        pageController.dataSource = self
        pageController.delegate = self
        
        let viewer = viewerWithIndex(photos.selectoedIndex)
        pageController.setViewControllers([viewer], direction: .forward, animated: true, completion: nil)
        
        view.addSubview(pageController.view)
        addChildViewController(pageController)
        pageController.didMove(toParentViewController: self)
        
        currentViewer = viewer
        
        // 手势
        view.gestureRecognizers = pageController.gestureRecognizers
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        view.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(interactionGesture(recognizer:)))
        view.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(interactionGesture(recognizer:)))
        view.addGestureRecognizer(rotate)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
        view.addGestureRecognizer(longPress)
    }

}

extension KKPhotoBrowserController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! KKPhotoViewerController).photoIndex
        index-=1
        if index <= 0 {
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
    
    
}

extension KKPhotoBrowserController: UIGestureRecognizerDelegate {
    @available(iOS 3.2, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
