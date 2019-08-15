//
//  HiveHud.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/14.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class HiveHud: UIView {
    static var hud: MBProgressHUD?
    class func show(_ view: UIView, _ title: String, _ after: TimeInterval) {
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud!.mode = .text
        hud!.label.text = title
        hud!.hide(animated: true, afterDelay: after)
    }

    class func showMask(_ view: UIView, title: String, animated: Bool) {

        hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud!.label.text = ""
        hud!.bezelView.color = UIColor.clear
        hud!.backgroundView.backgroundColor = UIColor.clear
        UIActivityIndicatorView.appearance(whenContainedInInstancesOf:
            [MBProgressHUD.self]).color = ColorHex("#76d4f8")
    }

    class func hiddenMask() {
        hud!.hide(animated: true)
    }
}
