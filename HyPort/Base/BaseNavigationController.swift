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
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
