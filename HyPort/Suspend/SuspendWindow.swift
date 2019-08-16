//
//  SuspendWindow.swift
//
//  Created by 李爱红 on 2018/9/28.
//  Copyright © 2018年 李爱红. All rights reserved.
//

import UIKit


///  KSuspendActionButton dependent on UIWindow.
class SuspendWindow: UIWindow {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindow.Level.normal
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let suspendViewController = rootViewController as? SuspendViewController
        if let suspend = suspendViewController?.suspend {
            if suspend.closed == false {
                return true
            }

            if suspend.frame.contains(point) == true {
                return true
            }

            for item in suspend.items {
                let itemFrame = self.convert(item.frame, from: suspend)
                if itemFrame.contains(point) == true {
                    return true
                }
            }
        }

        return false
    }
}
