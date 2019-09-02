//
//  BaseNavigationController.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/14.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = ColorHex("#76d4f8")
        self.navigationBar.isTranslucent = false;
    }

}
