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
        self.placeholder = UIImage(cgImage: placeholder.cgImage!, scale: 1.0, orientation: placeholder.imageOrientation)
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
            if let image = image {
                self.setImagePosition(image)
            }
        }
    }
    
    private func setImagePosition(_ image: UIImage) {
        let size = imageSize(WithScreen: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView?.contentSize = size
        
        if let scrollView = scrollView, size.height < scrollView.bounds.size.height {
            let offsetY = (scrollView.bounds.size.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetY, 0)
        }
    }
    
    private func imageSize(WithScreen image: UIImage) -> CGSize {
        var size = UIScreen.main.bounds.size
        size.height = image.size.height * size.width / image.size.width
        return size
    }
    
    private func prepareUI() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView!)
        
        imageView.center = view.center
        scrollView!.addSubview(imageView)
    }
}
