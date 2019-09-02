//
//  FileViewController.swift
//  HyPort
//
//  Created by 李爱红 on 2019/9/2.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class FileViewController: BaseViewController {
    let maxLength = 1024 * 1024 * 1024 * 1024 * 1024 * 1024
    var scrollerView: UIScrollView!
    var stackView: UIStackView!
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        creatUI()
        createRiteItem(true)
        requestFile(driveType, path: path!)
    }

    //   MARK: - UI
    func createRiteItem(_ isEdite: Bool) {
        var name: String!
        if isEdite {
            name = "Edite"
        }
        else {
            name = "Submite"
        }
        let backitem = UIBarButtonItem(title: name, style: .done, target: self, action: #selector(edite(_:)))
        self.navigationItem.rightBarButtonItem = backitem
    }

    func creatUI() {

        textView = UITextView()
        textView.isEditable = false
        self.view.addSubview(textView)

        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    //  MARK: - Request
    func requestFile(_ type: DriveType, path: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        switch type {
        case .nativeStorage: break
        case .oneDrive:
            hiveClient = HiveClientHandle.sharedInstance(type: .oneDrive)
        case .hiveIPFS:
            hiveClient = HiveClientHandle.sharedInstance(type: .hiveIPFS)
        case .dropBox: break
        case .ownCloud: break
        }

        hiveClient.defaultDriveHandle().then{ drive -> HivePromise<HiveFileHandle> in
            return drive.fileHandle(atPath: path)
            }.then{ fileHandle -> HivePromise<Data> in
                self.fHandle = fileHandle
                return fileHandle.readData(self.maxLength)
            }
            .done{ data in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                DispatchQueue.main.async {
                    let str = data.base64EncodedString()
                    self.textView.text = str
                }
            }
            .catch { error in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(error)
        }
    }

    //    MARK: - Button Action
    @objc func edite(_ isEdite: Bool) {
        HiveHud.show(self.view, "Function is developing", 1.5)
        createRiteItem(isEdite)
        textView.isEditable = !isEdite
    }
}
