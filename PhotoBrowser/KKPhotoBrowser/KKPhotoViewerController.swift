//
//  KKPhotoViewerController.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/16.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

class KKPhotoViewerController: UIViewController {
    
    let url: URL?
    let photoIndex: Int
    let placeholder: UIImage
    
    var scrollView: UIScrollView?
    let imageView: UIImageView
    
    init(urlString: String, photoIndex: Int, placeholder: UIImage) {
        let urlString = urlString.replacingOccurrences(of: "/bmiddle/", with: "/large/")
        url = URL(string: urlString)
        self.photoIndex = photoIndex
        self.placeholder = placeholder
        self.imageView = UIImageView(image: placeholder)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        prepareUI()
        loadImage()
    }
    
    private func loadImage() {
        imageView.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: { (receivedSize, expectedSize) in
            
        }) { (image, error, cache, url) in
            
        }
    }
    
    private func prepareUI() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView!)
        
        imageView.center = view.center
        view.addSubview(imageView)
    }
}
