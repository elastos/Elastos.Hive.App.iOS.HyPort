//
//  MyFriendViewController.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/9.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var mainTableView: UITableView!
    var friendList: Array<CarrierFriendInfo> = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        creatUI()
        getFriendList()
    }

    func creatUI() {
        mainTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 55
        mainTableView.separatorStyle = .none
        mainTableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()

            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().offset(-49)
            }
        }
    }

    func getFriendList() {
        if (Carrier.sharedInstance()?.isReady())! {
            do {
                friendList = try (Carrier.sharedInstance()?.getFriends())!
                mainTableView.reloadData()
            }
            catch {
                print(error)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: FriendCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
        cell.model = friendList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(tableView)
    }

}
