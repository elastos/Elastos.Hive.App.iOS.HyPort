//
//  SuspendViewController.swift
//
//  Created by 李爱红 on 2018/9/28.
//  Copyright © 2018年 李爱红. All rights reserved.
//

import UIKit

/**
 KSuspendActionButton dependent on UIWindow.
 */
open class SuspendViewController: UIViewController {
  public let suspend = Suspend()
  var statusBarStyle: UIStatusBarStyle = .default
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(suspend)
  }
  
  override open var preferredStatusBarStyle: UIStatusBarStyle {
    get {
      return statusBarStyle
    }
  }
}
