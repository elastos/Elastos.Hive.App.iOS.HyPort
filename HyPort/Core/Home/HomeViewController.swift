//
//  ViewController.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

/// The home 
class HomeViewController: UIViewController {

    var leftVC: LeftViewController = LeftViewController()
    var driveType: DriveType?
    var mainTable: UITableView!
    var ipfsDrive: DriveView!
    var oneDrive: DriveView!
    var driveStackView: UIStackView!
    var line: UIView!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Hive"
        self.view.backgroundColor = ColorHex("#f7f3f3")
        createLeftItem()
        creatUI()
        addNotification()
    }

    //    Mark: - Notification addObserver
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showIpfsDriveNotification(_ :)), name: .showIpfsDrive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showOneDriveNotification(_ :)), name: .showOneDrive, object: nil)
    }
    
    //   MARK: - UI
    func createLeftItem() {
        let img = UIImage(named: "user")
        let item = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftList))
        self.navigationItem.leftBarButtonItem = item
    }

    func creatUI() {
        ipfsDrive = DriveView()
        ipfsDrive.button.addTarget(self, action: #selector(listAction(_:)), for: UIControl.Event.touchUpInside)
        ipfsDrive.nameLable.text = "ipfsDrive"

        oneDrive = DriveView()
        oneDrive.button.addTarget(self, action: #selector(listAction(_:)), for: UIControl.Event.touchUpInside)
        oneDrive.nameLable.text = "OneDrive"
        driveStackView = UIStackView(arrangedSubviews: [ipfsDrive, oneDrive])
        driveStackView.frame = CGRect(x: 20, y: 40, width: SCREEN_WIDTH - 40, height: 88)
        driveStackView.axis = NSLayoutConstraint.Axis.horizontal
        driveStackView.alignment = UIStackView.Alignment.fill
        driveStackView.distribution = UIStackView.Distribution.fillEqually
        driveStackView.spacing = 20
        self.view.addSubview(driveStackView)

        line = UIView()
        line.backgroundColor = ColorHex("#eae7e7")
        self.view.addSubview(line)

        line.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(2)
            make.top.equalTo(driveStackView.snp_bottom).offset(40)
        }
    }
    
    //    MARK: Button action
    @objc func listAction(_ sendr: UIButton) {
        let typeView = sendr.superview
        var type: DriveType = DriveType.hiveIPFS
        if (typeView?.isEqual(ipfsDrive))! {
            type = DriveType.hiveIPFS
        }
        else if (typeView?.isEqual(oneDrive))! {
            type = DriveType.oneDrive
        }
        skipToHiveListVC(type, true)
    }

    func skipToHiveListVC(_ type: DriveType, _ animated: Bool) {
        let hiveListVC = HiveListViewController()
        hiveListVC.path = "/"
        hiveListVC.driveType = type
        self.navigationController?.pushViewController(hiveListVC, animated: animated)
    }

    @objc func leftList() {
        HiveManager.shareInstance.configSideMune()
    }

    //    MARK: Notification Action
    @objc func showIpfsDriveNotification(_ sender: Notification) {
        self.dismiss(animated: true, completion: nil)
        skipToHiveListVC(.hiveIPFS, false)
    }
    @objc func showOneDriveNotification(_ sender: Notification) {
        self.dismiss(animated: true, completion: nil)
        skipToHiveListVC(.oneDrive, false)
    }

}

