//
//  ViewController.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

/// The home 
class HomeViewController: UIViewController {

    var leftVC: LeftViewController = LeftViewController()
    var draw: Drawer!
    var driveType: DriveType?
    var mainTable: UITableView!
    var ipfsDrive: DriveView!
    var oneDrive: DriveView!
    var driveStackView: UIStackView!
    var line: UIView!

    var myCard: DriveView!
    var addFriend: DriveView!
    var myFriend: DriveView!
    var funStackView: UIStackView!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Hive"
        self.view.backgroundColor = ColorHex("#f7f3f3")
        draw = Drawer(self.navigationController!, leftVC)
        createLeftItem()
        creatUI()
        addNotification()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAddFriendNotification(sender:)), name: .showAddFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFriendListNotification(sender:)), name: .showFriendList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showActiveHiveListNotification(_ :)), name: .showActiveHiveList, object: nil)
    }

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

        myCard = DriveView()
        myCard.button.addTarget(self, action: #selector(qrcode), for: UIControl.Event.touchUpInside)
        myCard.nameLable.text = "my card"

        addFriend = DriveView()
        addFriend.button.addTarget(self, action: #selector(addFriendAction), for: UIControl.Event.touchUpInside)
        addFriend.nameLable.text = "add Friend"

        myFriend = DriveView()
        myFriend.button.addTarget(self, action: #selector(friendList), for: UIControl.Event.touchUpInside)
        myFriend.nameLable.text = "my Friend"

        funStackView = UIStackView(arrangedSubviews: [myCard, addFriend, myFriend])
        funStackView.axis = NSLayoutConstraint.Axis.horizontal
        funStackView.alignment = UIStackView.Alignment.fill
        funStackView.distribution = UIStackView.Distribution.fillEqually
        funStackView.spacing = 20
        self.view.addSubview(funStackView)

        funStackView.snp.makeConstraints { make in
            make.top.equalTo(line.snp_bottom).offset(40)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(66)
        }
    }

    func skipList(_ type: DriveType, _ animated: Bool) {
        let hiveListVC = HiveListViewController()
        var storeValue = ""
        switch type {

        case .nativeStorage: break
        case .oneDrive:
            storeValue = "oneDrive"
            hiveListVC.driveType = .oneDrive
        case .hiveIPFS:
            storeValue = "hiveIPFS"
            hiveListVC.driveType = .hiveIPFS
        case .dropBox: break
        case .ownCloud: break
        }
        UserDefaults.standard.set(storeValue, forKey: "DriveType")

        HiveManager.shareInstance.login(hiveListVC.driveType).done { succeed in
            hiveListVC.fullPath = "/"
            self.navigationController?.pushViewController(hiveListVC, animated: animated)
            }
            .catch { error in
                print(error)
        }
    }
    //    MARK: Button action
    @objc func listAction(_ sendr: UIButton) {
        let typeView = sendr.superview
        if (typeView?.isEqual(ipfsDrive))! {
            skipList(.hiveIPFS, true)
        }
        else if (typeView?.isEqual(oneDrive))! {
            skipList(.oneDrive, true)
        }
    }

    @objc func leftList() {
        draw.show()
    }

    @objc func addFriendAction() {
        let scanVC = ScanViewController()
        self.navigationController!.show(scanVC, sender: nil)
    }

    @objc func qrcode() {
        let myCardVC = MyCardViewController()
        self.navigationController?.pushViewController(myCardVC, animated: true)
    }

    @objc func friendList() {
        draw.close()
        let myFriendVC = FriendViewController()
        self.navigationController?.pushViewController(myFriendVC, animated: true)
    }

    //    MARK: Notification Action
    @objc func showAddFriendNotification(sender: Notification) {
        draw.close()
        let scanVC = ScanViewController()
        self.navigationController?.pushViewController(scanVC, animated: false)
    }

    @objc func showFriendListNotification(sender: Notification) {
        draw.close()
        let myFriendVC = FriendViewController()
        self.navigationController?.pushViewController(myFriendVC, animated: false)
    }

    @objc func showActiveHiveListNotification(_ sender: Notification) {
        draw.close()
        let typeString = sender.object as! String
        var type: DriveType = .hiveIPFS
        if typeString == "oneDrive" {
            type = .oneDrive
        }else if typeString == "hiveIPFS" {
            type = .hiveIPFS
        }
        skipList(type, false)
    }

}

