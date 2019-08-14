//
//  HiveManager.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/11.
//  Copyright © 2019 elastos. All rights reserved.
//

import Foundation

let addrs = [
    "http://52.83.119.110:9095",
    "http://52.83.159.189:9095",
    "http://3.16.202.140:9095",
    "http://18.217.147.205:9095",
    "http://18.219.53.133:9095"]
class HiveManager: Authenticator {

    var authWebViewController : AuthWebViewController?
    func requestAuthentication(_ requestURL: String) -> Bool {
//        let authViewController: AuthWebViewController = AuthWebViewController()
//        DispatchQueue.main.sync {
//            let rootViewController: UINavigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
//            authViewController.definesPresentationContext = true;
//            authViewController.modalPresentationStyle = .overCurrentContext
//            rootViewController.topViewController!.present(authViewController, animated: true, completion: nil)
//            authViewController.loadRequest(requestURL)
//            self.authWebViewController = authViewController;
//        }
        return true
    }

    let rpcAddrs: IPFSEntry = IPFSEntry("uid-283744b9-57e7-4af7-b5b0-7957f80c6349", addrs)
    let outhEnty: OAuthEntry = OAuthEntry("afd3d647-a8b7-4723-bf9d-1b832f43b881", "User.Read Files.ReadWrite.All offline_access", "http://localhost:12345")
    let store: String = "\(NSHomeDirectory())/Library/Caches/ipfs"
    var hiveParams: DriveParameter!
    var hiveClient: HiveClientHandle!
   static let shareInstance = HiveManager()

    func login(_ type: DriveType) -> Promise<Void>{
        switch type {

        case .hiveIPFS:
            hiveParams = IPFSParameter(rpcAddrs,store)
            HiveClientHandle.createInstance(hiveParams!)
            hiveClient = HiveClientHandle.sharedInstance(type: .hiveIPFS)
        case .oneDrive:
            hiveParams = OneDriveParameter(outhEnty, store)
            HiveClientHandle.createInstance(hiveParams!)
            hiveClient = HiveClientHandle.sharedInstance(type: .oneDrive)
        case .nativeStorage:
            break
        case .dropBox:
            break
        case .ownCloud:
            break
        }

        let promise = Promise<Void> { resolver in
            let globalQueue = DispatchQueue.global()
            globalQueue.async {
                do {
                    _ = try self.hiveClient.login(self as Authenticator)
                    self.authWebViewController?.dismiss(animated: true, completion: nil)
                    resolver.fulfill(Void())
                }catch {
                    resolver.reject(error)
                }
            }
        }
        return promise
    }
}
