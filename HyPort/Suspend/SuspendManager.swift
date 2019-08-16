//
//  SuspendManager.swift
//
//  Created by 李爱红 on 2018/9/28.
//  Copyright © 2018年 李爱红. All rights reserved.
//

import UIKit


///  KSuspendActionButton dependent on UIWindow.
public class SuspendManager: NSObject {

    private static var __once: () = {
        StaticInstance.instance = SuspendManager()
    }()
    struct StaticInstance {
        static var dispatchToken: Int = 0
        static var instance: SuspendManager?
    }

    class func defaultInstance() -> SuspendManager {
        _ = SuspendManager.__once
        return StaticInstance.instance!
    }

    var _suspendWindow: SuspendWindow? = nil
    var suspendWindow: SuspendWindow {
        get {
            if _suspendWindow == nil {
                _suspendWindow = SuspendWindow(frame: UIScreen.main.bounds)
                _suspendWindow?.rootViewController = suspendController
            }
            return _suspendWindow!
        }
    }

    var _suspendController: SuspendViewController? = nil
    var suspendController: SuspendViewController {
        get {
            if _suspendController == nil {
                _suspendController = SuspendViewController()
            }
            return _suspendController!
        }
    }


    open var button: Suspend {
        get {
            return suspendController.suspend
        }
    }

    private let fontDescriptor: UIFontDescriptor
    private var _font: UIFont

    public override init() {
        fontDescriptor = UIFont.systemFont(ofSize: 20.0).fontDescriptor
        _font = UIFont(descriptor: fontDescriptor, size: 20)
    }

    open var font: UIFont {
        get {
            return _font
        }
        set {
            _font = newValue
        }
    }

    private var _rtlMode = false
    open var rtlMode: Bool {
        get {
            return _rtlMode
        }
        set{
            _rtlMode = newValue
        }
    }

    open func show(_ animated: Bool = true) {
        if animated == true {
            suspendWindow.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.suspendWindow.alpha = 1
            })
        } else {
            suspendWindow.isHidden = false
        }
    }

    open func hide(_ animated: Bool = true) {
        if animated == true {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.suspendWindow.alpha = 0
            }, completion: { finished in
                self.suspendWindow.isHidden = true
            })
        } else {
            suspendWindow.isHidden = true
        }
    }

    open func toggle(_ animated: Bool = true) {
        if suspendWindow.isHidden == false {
            self.hide(animated)
        } else {
            self.show(animated)
        }
    }

    open var hidden: Bool {
        get {
            return suspendWindow.isHidden
        }
    }
}
