//
//  MyCardViewController.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/9.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit
import QRCode

class MyCardViewController: UIViewController {

    var nameLabel: UILabel?
    var qrCodeImageView: UIImageView?
    var messageLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        createUI()
        loadMyInfo()
    }

    func createUI() {
        self.view.backgroundColor = UIColor.white
        qrCodeImageView = UIImageView()
        self.view.addSubview(qrCodeImageView!)
        qrCodeImageView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        })
    }

    func loadMyInfo() {
        navigationItem.title = "Hive"
        if let carrierInst = DeviceManager.sharedInstance.carrierInst {
            if (try? carrierInst.getSelfUserInfo()) != nil {
                let address = carrierInst.getAddress()
                let qrCode = QRCode(address)
                qrCodeImageView!.image = qrCode?.image
                return
            }
        }
    }

}
