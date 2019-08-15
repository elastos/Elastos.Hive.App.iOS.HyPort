//
//  HiveListViewController.swift
//  HyPort
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

    //    Mark: - Notification addObserver
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

    //  MARK: - Request
    func requestChaildren(_ type: DriveType, path: String) {
        HiveHud.showMask(self.view, title: "Please wait", animated: true)
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
                HiveHud.hiddenMask()
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
                    self.getItemInfo()
                }
            }
            .catch { error in
                HiveHud.hiddenMask()
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
                HiveHud.hiddenMask()
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
                    self.getItemInfo()
                }
            }
            .catch { error in
                HiveHud.hiddenMask()
                print(error)
        }
    }

    //    MARK: - refresh UI
    func getItemInfo() {
        dataSource.enumerated().forEach { (index, item) in
            refreshItem(index, item: item)
        }
    }

    func refreshItem(_ index: Int, item: HiveModel) {
        let item = dataSource[index]
        let path = item.fullPath! + "/" + item.name
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
            }.catch{ error in
                self.refreshItem(index, item: item)
        }
    }

    func refreshUI() {
        self.navigationItem.title = path
        self.pathView.containLable.text = fullPath
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
            HiveHud.show(self.view, "Function is developing", 1.5)
            return
        }

        let item = dataSource[indexPath.row]
        let currentName = item.name!
        let newListVC = HiveListViewController()
        newListVC.path = currentName
        newListVC.fullPath = self.dHandle!.pathName + "/" + currentName
        if self.dHandle!.pathName == "/" {
            newListVC.fullPath = self.dHandle!.pathName + currentName
        }
        newListVC.driveType = driveType

        self.navigationController?.pushViewController(newListVC, animated: true)
    }

    // MARK --- UILongPressGestureRecognizer action
    @objc func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {

        guard sender.state == .ended else {
            return
        }
        let point: CGPoint = sender.location(in: mainTableView)
        let indexPath = mainTableView.indexPathForRow(at: point)
        let name = dataSource[(indexPath?.row)!].name!
        let type = dataSource[(indexPath?.row)!].type

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (action) in
            HiveHud.showMask(self.view, title: "Please wait", animated: true)
            if type == "directory" {
                self.dHandle?.directoryHandle(atName: name).done{ deleteDHandle in
                    deleteDHandle.deleteItem().done{ success in
                        HiveHud.hiddenMask()
                        HiveHud.show(self.view, "Delete success", 1.5)
                        self.dataSource.remove(at: indexPath!.row)
                        self.mainTableView.reloadData()
                        }.catch{ error in
                            HiveHud.hiddenMask()
                            HiveHud.show(self.view, "Delete failed", 1.5)
                    }
                    }.catch{ error in
                        HiveHud.hiddenMask()
                        HiveHud.show(self.view, "Delete failed", 1.5)
                }
            }
            else {
                self.dHandle?.fileHandle(atName: name).done{ deleteFile in
                    deleteFile.deleteItem().done{ success in
                        HiveHud.hiddenMask()
                        HiveHud.show(self.view, "Delete success", 1.5)
                        self.dataSource.remove(at: indexPath!.row)
                        self.mainTableView.reloadData()
                        }.catch{ error in
                            HiveHud.hiddenMask()
                            HiveHud.show(self.view, "Delete failed", 1.5)
                    }
                    }.catch{ error in
                        HiveHud.hiddenMask()
                        HiveHud.show(self.view, "Delete failed.", 1.5)
                }
            }
        }
        let renameAction: UIAlertAction = UIAlertAction(title: "Rename", style: UIAlertAction.Style.default) { (action) in
            HiveHud.show(self.view, "Function is developing", 1.5)
        }
        let shareAction: UIAlertAction = UIAlertAction(title: "Share", style: UIAlertAction.Style.default) { (action) in
            HiveHud.show(self.view, "Function is developing", 1.5)
        }
        let uploadAction: UIAlertAction = UIAlertAction(title: "Upload", style: UIAlertAction.Style.default) { (action) in
             HiveHud.show(self.view, "Function is developing", 1.5)
        }
        let cancleAction: UIAlertAction = UIAlertAction(title: "Cancle", style: UIAlertAction.Style.cancel) { (action) in
        }
        sheet.addAction(deleteAction)
        sheet.addAction(renameAction)
        sheet.addAction(cancleAction)
        if type == "directory" {
            sheet.addAction(shareAction)
            sheet.addAction(uploadAction)
        }
        sheet.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(sheet, animated: true, completion: nil)
    }

    //  MARK: - Button action
    @objc func creatDirectory() {
        var inpuText: UITextField = UITextField()
        let msgAlert = UIAlertController(title: nil, message: "Please input the name", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Sure", style: .default) { action in
            if inpuText.text == "" {
                HiveHud.show(self.view, "Name not nil", 1.5)
            }else {
                HiveHud.showMask(self.view, title: "Please wait", animated: true)
                self.dHandle?.createDirectory(withName: inpuText.text!).done{ directory in
                    HiveHud.hiddenMask()
                    HiveHud.show(self.view, "Create success", 1.5)
                    let item = HiveModel()
                    item.name = inpuText.text!
                    item.type = "directory"
                    item.itemId = directory.directoryId
                    item.size = "0"
                    self.dataSource.insert(item, at: 0)
                    self.mainTableView.reloadData()
                    }.catch{ error in
                        HiveHud.hiddenMask()
                        HiveHud.show(self.view, "The same name directory alreadly exists", 1.5)
                }
            }
        }
        let cancle = UIAlertAction(title: "Cancle", style: .cancel) { action in
        }

        msgAlert.addTextField { textFiled in
            inpuText = textFiled
            inpuText.placeholder = "Please input the name"
        }
        msgAlert.addAction(ok)
        msgAlert.addAction(cancle)
        msgAlert.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(msgAlert, animated: true, completion: nil)
    }

    //    MARK: Notification action
    @objc func frientInfoDidChange(_ sender: Notification) {

    }


}
