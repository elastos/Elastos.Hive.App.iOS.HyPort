//
//  BaseViewController.swift
//  HyPort
//
//  Created by 李爱红 on 2019/9/2.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var driveType: DriveType!
    var path: String?
    var hiveClient: HiveClientHandle!
    var dHandle: HiveDirectoryHandle?
    var fHandle: HiveFileHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        createItem()
    }
    
    //   MARK: - UI
    func createItem() {
        let backimg = UIImage(named: "back")
        let backitem = UIBarButtonItem(image: backimg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backitem
        self.navigationItem.hidesBackButton = true

        let listimg = UIImage(named: "list")
        let listitem = UIBarButtonItem(image: listimg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftList))
        let titleitem = UIBarButtonItem(title: driveType.map { $0.rawValue }, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [backitem, titleitem, listitem]
    }

    //    MARK: - Button Action
    @objc func leftList() {
        HiveManager.shareInstance.configSideMune()
    }

    @objc func back() {
        guard self.path != "/" else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }


}
