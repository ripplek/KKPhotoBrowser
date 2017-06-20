//
//  MainViewController.swift
//  PhotoBrowser
//
//  Created by 张坤 on 2017/6/15.
//  Copyright © 2017年 zhangkun. All rights reserved.
//

import UIKit

let reuseIdentifier = "reuseIdentifier"
class MainViewController: UITableViewController, PhotoCellDelegate {
    
    var dataPhotos = Array<[String]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PhotoCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        self.modalPresentationCapturesStatusBarAppearance = true
        loadData()
    }
    
    private func loadData() {
        for i in 1...9 {
            dataPhotos.append(PhotoUrls.photos(count: i))
        }
    }
    
     //MARK: - PhotoCellDelegate
    func didSelectedImageIndex(cell: PhotoCell, index: Int) {
        let indexPath = tableView.indexPath(for: cell)
        guard indexPath != nil else {
            return
        }
        
        let browserVC = KKPhotoBrowserController(selectedIndex: index, urls: dataPhotos[indexPath!.row], parentImageViews: cell.visibaleImageViews())
        
        present(browserVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPhotos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.photos_urls = dataPhotos[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}

extension UINavigationController {
    //    open override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    //
    //    open override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
