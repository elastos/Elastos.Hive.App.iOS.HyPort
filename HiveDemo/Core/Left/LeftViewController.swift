//
//  LeftViewController.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let showAddFriend = Notification.Name("ShowAddFriend")
    static let showFriendList = Notification.Name("ShowFriendList")

}

class LeftViewController: UIViewController {

    var headerView: HeaderView!
    var addFriend: NormalView!
    var listFriend: NormalView!
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

        addFriend = NormalView()
        addFriend.icon.image = UIImage.init(named: "add")
        addFriend.button.addTarget(self, action: #selector(postNotification), for: UIControl.Event.touchUpInside)
        addFriend.title.text = "添加好友"

        listFriend = NormalView()
        listFriend.icon.image = UIImage.init(named: "list")
        listFriend.button.addTarget(self, action: #selector(friendList), for: UIControl.Event.touchUpInside)
        listFriend.title.text = "好友列表"

//        localStore = NormalView()
//        localStore.icon.image = UIImage.init(named: "file")
//        localStore.title.text = "本地存储"

        icloudStore = NormalView()
        icloudStore.icon.image = UIImage.init(named: "icloud")
        icloudStore.title.text = "云端存储"

        reciveFile = SwitchView()
        reciveFile.icon.image = UIImage.init(named: "file")
        reciveFile.title.text = "接收文件"

        stackView = UIStackView(arrangedSubviews: [addFriend, listFriend, icloudStore, reciveFile])
        stackView.frame = CGRect(x: 30, y: 200, width: 300, height: 50 * 4)
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.spacing = 5
        self.view.addSubview(stackView)

    }

    @objc func postNotification() {
        NotificationCenter.default.post(name: .showAddFriend, object: nil)
    }

    @objc func friendList() {
        NotificationCenter.default.post(name: .showFriendList, object: nil)
    }
}
