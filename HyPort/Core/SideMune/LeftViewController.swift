//
//  LeftViewController.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let showIpfsDrive = Notification.Name("showIpfsDrive")
    static let showOneDrive = Notification.Name("showOneDrive")
    static let showActiveHiveList = NSNotification.Name("showActiveHiveList")

}

class LeftViewController: UIViewController {

    var headerView: HeaderView!
    var ipfsDrive: NormalView!
    var oneDrive: NormalView!
    var localStore: NormalView!
    var icloudStore: NormalView!
    var reciveFile: SwitchView!
    var stackView: UIStackView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        creatUI()
    }

    func creatUI() {
        headerView = HeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 150)
        headerView.backgroundColor = ColorHex("#76d4f8")
        self.view.addSubview(headerView)

        ipfsDrive = NormalView()
//        ipfsDrive.icon.image = UIImage.init(named: "add")
        ipfsDrive.button.addTarget(self, action: #selector(ipfsDriveNotification), for: UIControl.Event.touchUpInside)
        ipfsDrive.title.text = "IpfsDrive"

        oneDrive = NormalView()
//        oneDrive.icon.image = UIImage.init(named: "list")
        oneDrive.button.addTarget(self, action: #selector(oneDriveNotification), for: UIControl.Event.touchUpInside)
        oneDrive.title.text = "OneDrive"

        stackView = UIStackView(arrangedSubviews: [ipfsDrive, oneDrive])
        stackView.frame = CGRect(x: 30, y: 200, width: 300, height: 50 * 2)
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.spacing = 5
        self.view.addSubview(stackView)
    }
    
    //MARK: - POST Notification
    @objc func ipfsDriveNotification() {
        NotificationCenter.default.post(name: .showIpfsDrive, object: nil)
    }

    @objc func oneDriveNotification() {
        NotificationCenter.default.post(name: .showOneDrive, object: nil)
    }

}
