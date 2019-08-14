//
//  HiveListViewController.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/9.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

/// The list page

class HiveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var pathView: FilePathView!
    var mainTableView: UITableView!
    var driveType: DriveType!
    var fullPath: String!
    var path: String?
    var hiveClient: HiveClientHandle!
    var dataSource: Array<HiveModel> = []
    var dHandle: HiveDirectoryHandle?
    var fHandle: HiveFileHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        creatUI()
        requestChaildren(driveType, path: fullPath)
    }

    func notificationAdded() {
        NotificationCenter.default.addObserver(self, selector: #selector(frientInfoDidChange(_ :)), name: .friendInfoChanged, object: nil)
    }

    func creatUI() {

        pathView = FilePathView()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        pathView.button.addTarget(self, action: #selector(creatDirectory), for: UIControl.Event.touchUpInside)
        self.view.addSubview(pathView)

        mainTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 55
        mainTableView.separatorStyle = .none
        mainTableView.register(HiveListCell.self, forCellReuseIdentifier: "HiveListCell")
        self.view.addSubview(mainTableView)

        pathView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(self.view)
        }

        mainTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(pathView.snp_bottom)

            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.bottom.equalToSuperview().offset(-49)
            }
        }
    }

    func requestChaildren(_ type: DriveType, path: String) {

        if path == "/" {
            requestRoot(type)
            return
        }
        switch type {
        case .nativeStorage: break
        case .oneDrive:
            hiveClient = HiveClientHandle.sharedInstance(type: .oneDrive)
        case .hiveIPFS:
            hiveClient = HiveClientHandle.sharedInstance(type: .hiveIPFS)
        case .dropBox: break
        case .ownCloud: break
        }

        hiveClient.defaultDriveHandle().then{ drive -> HivePromise<HiveDirectoryHandle> in
            return drive.directoryHandle(atPath: path)
            }.then{ directory -> HivePromise<HiveChildren> in
                self.dHandle = directory
                return directory.getChildren()
            }
            .done{ item in
                item.children.enumerated().forEach{ (idex, item) in
                    let hiveItem = HiveModel()
                    hiveItem.itemId = item.getValue("itemId")
                    hiveItem.name = item.getValue("name")
                    hiveItem.size = item.getValue("size")
                    hiveItem.type = item.getValue("type")
                    hiveItem.fullPath = self.dHandle?.pathName
                    self.dataSource.append(hiveItem)
                }
                self.refreshUI()
                self.mainTableView.reloadData()
                if type == DriveType.hiveIPFS {
                    self.getItemInfo(0)
                }
            }
            .catch { error in
                print(error)
        }
    }

    func requestRoot(_ type: DriveType) {
        switch type {
        case .nativeStorage: break
        case .oneDrive:
            hiveClient = HiveClientHandle.sharedInstance(type: .oneDrive)
        case .hiveIPFS:
            hiveClient = HiveClientHandle.sharedInstance(type: .hiveIPFS)
        case .dropBox: break
        case .ownCloud: break
        }

        hiveClient.defaultDriveHandle().then{ drive -> HivePromise<HiveDirectoryHandle> in
            return drive.rootDirectoryHandle()
            }.then{ rootDirectory -> HivePromise<HiveChildren> in
                self.dHandle = rootDirectory
                return rootDirectory.getChildren()
            }
            .done{ item in
                item.children.enumerated().forEach{ (idex, item) in
                    let hiveItem = HiveModel()
                    hiveItem.itemId = item.getValue("itemId")
                    hiveItem.name = item.getValue("name")
                    hiveItem.size = item.getValue("size")
                    hiveItem.type = item.getValue("type")
                    hiveItem.fullPath = self.dHandle?.pathName
                    self.dataSource.append(hiveItem)
                }
                self.refreshUI()
                self.mainTableView.reloadData()
                if type == DriveType.hiveIPFS {
                    self.getItemInfo(0)
                }
            }
            .catch { error in
                print(error)
        }
    }

    func getItemInfo(_ index: Int) {
        if index >= self.dataSource.count{
            return
        }
        let item = dataSource[index]
        let path = item.fullPath! + item.name
        hiveClient.defaultDriveHandle().then{ drive -> HivePromise<HiveItemInfo> in
            return drive.getItemInfo(path)
            }.done{ itemInfo in
                let newItem = HiveModel()
                newItem.name = itemInfo.getValue("name")
                newItem.size = itemInfo.getValue("size")
                newItem.type = itemInfo.getValue("type")
                newItem.itemId = itemInfo.getValue("itemId")
                self.dataSource[index] = newItem
                let indexPath = IndexPath.init(row: index, section: 0)
                UIView.performWithoutAnimation {
                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                }
                self.getItemInfo(index + 1)
            }.catch{ error in
                print(error)
                if index == self.dataSource.count - 1{
                    return
                }
                self.getItemInfo(index)
        }
    }
    // MARK: refresh
    func refreshUI() {
        self.navigationItem.title = path
        self.pathView.containLable.text = fullPath
    }

    func computingFullPath(_ handle: HiveDirectoryHandle, _ selfName: String) -> String {

        let parentPath: String = handle.parentPathName()
        let pathName: String = handle.pathName
        var fullPath = "\(pathName)/\(selfName)"
        if parentPath == "/" {
            fullPath = "\(pathName)/\(selfName)"
        }
        if pathName == "/" {
            fullPath = "/\(selfName)"
        }
        return fullPath
    }

    //    MARK: tableviewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: HiveListCell = tableView.dequeueReusableCell(withIdentifier: "HiveListCell") as! HiveListCell
        cell.longPress.addTarget(self, action: #selector(longPressGestureAction(_:)))
        cell.model = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource[indexPath.row].type == "directory" else {
            // TODO view for file
            HiveHud.show(self.view, "此功能还在开发中", 1.5)
            return
        }

        let selfName: String = dataSource[indexPath.row].name
        let fullPath = computingFullPath(self.dHandle!, selfName)
        let newListVC = HiveListViewController()
        newListVC.path = selfName
        newListVC.fullPath = fullPath
        newListVC.driveType = driveType

        self.navigationController?.pushViewController(newListVC, animated: true)
    }

    // MARK --- action
    @objc func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {

        guard sender.state == .ended else {
            return
        }
        let point: CGPoint = sender.location(in: mainTableView)
        let indexPath = mainTableView.indexPathForRow(at: point)
        let name = dataSource[(indexPath?.row)!].name!
        let type = dataSource[(indexPath?.row)!].type

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: "删除", style: UIAlertAction.Style.default) { (action) in

            if type == "folder" {
                self.dHandle?.directoryHandle(atName: name).done{ deleteDHandle in
                    deleteDHandle.deleteItem().done{ success in
                        self.dataSource.remove(at: indexPath!.row)
                        self.mainTableView.reloadData()
                        }.catch{ error in
                            print(error)
                            HiveHud.show(self.view, "删除失败", 1.5)
                    }
                    }.catch{ error in
                        print(error)
                        HiveHud.show(self.view, "删除失败", 1.5)
                }
            }
            else {
                self.dHandle?.fileHandle(atName: name).done{ deleteFile in
                    deleteFile.deleteItem().done{ success in
                        self.dataSource.remove(at: indexPath!.row)
                        self.mainTableView.reloadData()
                        }.catch{ error in
                            HiveHud.show(self.view, "删除失败", 1.5)
                    }
                    }.catch{ error in
                        HiveHud.show(self.view, "删除失败", 1.5)
                }
            }
        }
        let renameAction: UIAlertAction = UIAlertAction(title: "重命名", style: UIAlertAction.Style.default) { (action) in
            HiveHud.show(self.view, "此功能还在开发中", 1.5)
        }
        let shareAction: UIAlertAction = UIAlertAction(title: "分享", style: UIAlertAction.Style.default) { (action) in
            HiveHud.show(self.view, "此功能还在开发中", 1.5)
        }
        let uploadAction: UIAlertAction = UIAlertAction(title: "上传", style: UIAlertAction.Style.default) { (action) in
             HiveHud.show(self.view, "此功能还在开发中", 1.5)
        }
        let cancleAction: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (action) in
        }
        sheet.addAction(deleteAction)
        sheet.addAction(renameAction)
        sheet.addAction(cancleAction)
        if type == "folder" {
            sheet.addAction(shareAction)
            sheet.addAction(uploadAction)
        }
        sheet.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(sheet, animated: true, completion: nil)
    }

    @objc func creatDirectory() {

        dHandle?.createDirectory(withName: "测试添加Directory-1").done{ directory in
            self.requestChaildren(self.driveType, path: self.fullPath)
            }.catch{ error in
                print(error)
        }
    }
    //    MARK: notification
    @objc func frientInfoDidChange(_ sender: Notification) {

    }


}
