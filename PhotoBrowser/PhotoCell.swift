//
//  PhotoCell.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/15.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

/// 图像 Cell 布局
struct PhotoCellLayout {
    var viewWidth: Float {
        return Float(UIScreen.main.bounds.size.width) - Float((count-1)) * margin
    }
    
    var itemSize: CGSize {
        let itemWidth: CGFloat = CGFloat((viewWidth - Float((count-1)) * itemMargin) / Float(count))
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    let margin: Float
    let itemMargin: Float
    let count: Int
}

protocol PhotoCellDelegate {
    func didSelectedImageIndex(cell: PhotoCell, index: Int)
}

class PhotoCell: UITableViewCell {
    
    var delegate: PhotoCellDelegate?
    
    var photos_urls: Array<String>! {
        didSet {
            updateCell()
        }
    }
    
    func visibaleImageViews() -> [UIImageView] {
        var arrayM = Array<UIImageView>()
        for iv in pictureView.subviews {
            if !iv.isHidden {
                arrayM.append(iv as! UIImageView)
            }
        }
        return arrayM
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCell() {
        let pictureViewSize = pictureViewSizeWith(count: photos_urls.count)
        pictureView.snp.updateConstraints { (make) in
            make.height.equalTo(pictureViewSize.height)
        }
        
        for iv in pictureView.subviews {
            iv.isHidden = true
        }
        
        var index = 0
        
        for urlString in photos_urls {
            let imageV = pictureView.subviews[index] as! UIImageView
            let url = URL(string: urlString)
            imageV.kf.setImage(with: url, completionHandler: { (image, error, cache, url) in
                
                // 单图等比例缩放
                if index == 0 && self.photos_urls.count == 1 && image != nil {
                    let height = pictureViewSize.height
                    let width = image!.size.width * height / image!.size.height
                    imageV.frame = CGRect(x: 0, y: 0, width: width, height: height)
                } else if index == 0 {
                    imageV.frame = CGRect(x: 0, y: 0, width: self.layout.itemSize.width, height: self.layout.itemSize.width)
                }
            })
            
            imageV.isHidden = false
            index+=1
            if index == 2 && photos_urls.count == 4 {
                index+=1
            }
        }
    }
    
    @objc private func tapImageView(recognizer: UITapGestureRecognizer) {
        var index = recognizer.view!.tag
        if photos_urls.count == 4 && index > 2 {
            index-=1
        }
        self.delegate?.didSelectedImageIndex(cell: self, index: index)
    }
    
    private func pictureViewSizeWith(count: Int) -> CGSize {
        if count == 0 {
            return CGSize.zero
        }
        
        let row = Int((count-1) / layout.count) + 1
        let height = CGFloat(row-1) * CGFloat(layout.itemMargin) + CGFloat(row) * layout.itemSize.width
        return CGSize(width: layout.itemSize.width, height: height)
    }
    
    /// 设置界面
    private func prepareUI() {
        backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        contentView.addSubview(pictureView)
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(layout.margin)
            make.leading.equalTo(layout.margin)
            make.width.equalTo(layout.viewWidth)
            make.height.equalTo(layout.viewWidth)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pictureView).offset(layout.margin)
        }
        
        pictureView.backgroundColor = backgroundColor
        
        prepareImageViews()
    }
    
    private func prepareImageViews() {
        pictureView.clipsToBounds = true
        
        let count = layout.count * layout.count
        let rect = CGRect(x: 0, y: 0, width: layout.itemSize.width, height: layout.itemSize.height)
        let step = layout.itemSize.width + CGFloat(layout.itemMargin)
        
        for i in 0..<count {
            // 添加图像视图
            let imageV = UIImageView()
            imageV.frame = rect
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            pictureView.addSubview(imageV)
            
            // 计算图像位置
            let col = Int(i % layout.count)
            let row = Int(i / layout.count)
            
            imageV.frame = rect.offsetBy(dx: CGFloat(col)*step, dy: CGFloat(row)*step)
            
            imageV.backgroundColor = UIColor.lightGray
            
            // 添加手势
            imageV.tag = i
            imageV.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(recognizer:)))
            imageV.addGestureRecognizer(tap)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private let pictureView: UIView = UIView()
    private let layout: PhotoCellLayout = PhotoCellLayout(margin: 12, itemMargin: 2, count: 3)
}
