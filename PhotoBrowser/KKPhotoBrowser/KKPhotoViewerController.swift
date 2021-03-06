//
//  KKPhotoViewerController.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/16.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit
import Kingfisher

class KKPhotoViewerController: UIViewController {
    
    let url: URL?
    let photoIndex: Int
    let placeholder: UIImage
    
    var scrollView: UIScrollView!
    var imageView: UIImageView
    
    let progressView = KKPhotoProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
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
            self.progressView.progress = Float(receivedSize) / Float(expectedSize)
        }) { (result) in
            switch result {
            case .success(let res):
                self.setImagePosition(res.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setImagePosition(_ image: UIImage) {
        let size = imageSize(WithScreen: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView?.contentSize = size
        
        if let scrollView = scrollView, size.height < scrollView.bounds.size.height {
            let offsetY = (scrollView.bounds.size.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
        }
    }
    
    private func imageSize(WithScreen image: UIImage) -> CGSize {
        var size = UIScreen.main.bounds.size
        size.height = image.size.height * size.width / image.size.width
        return size
    }
    
    private func prepareUI() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        imageView.center = view.center
        scrollView.addSubview(imageView)
        
        progressView.center = view.center
        view.addSubview(progressView)
        
        progressView.progress = 1.0
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
    }
    
    override var description: String {
        return "\(self.photoIndex)"
    }
}

extension KKPhotoViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


