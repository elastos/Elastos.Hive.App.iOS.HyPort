//
//  Drawer.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

enum DrawerDirection {
    case Left
    case Right
}

class Drawer: NSObject {

    /// The main viewController
    var main: UIViewController?

    /// The drawer viewController
    var drawer: UIViewController?

    /// Drawer on the left or right, default left, not the rigth
    /// you have to go to the animator on the rigth to add judgment
    var whichDirection = DrawerDirection.Left

    /// The mainViewcontroller drag gesture
    var dragMain: UIPanGestureRecognizer?

    /// The drawerViewController drag gesture
    var dragDrawer: UIPanGestureRecognizer?

    /// The width of the mainViewController when displayed in the drawer
    var baseWidth: CGFloat {
        get {
            return self.animator!.baseWidth
        }
        set {
            self.animator?.baseWidth = newValue
        }
    }

    /// Respond gestures ture or false
    var isResponseRecognizer = false

    /// animation
    var animator: Animator?


    init(_ main: UIViewController, _ drawer: UIViewController) {
        super.init()
        self.main = main
        self.drawer = drawer
        animator = Animator(self.main!, self.drawer!)
        self.dragMain = UIPanGestureRecognizer(target: self, action: #selector(dragMainAction(_:)))
        main.view.addGestureRecognizer(self.dragMain!)
        self.dragDrawer = UIPanGestureRecognizer(target: self, action: #selector(dragDrawerAction(_:)))
        drawer.view.addGestureRecognizer(self.dragDrawer!)
        self.drawer?.transitioningDelegate = self.animator
    }

    deinit {
        if self.dragMain != nil {
            self.main?.view.removeGestureRecognizer(self.dragMain!)
            self.dragMain = nil
        }
        if self.dragDrawer != nil {
            self.drawer?.view.removeGestureRecognizer(self.dragDrawer!)
            self.dragDrawer = nil
        }
    }

}

extension Drawer {


    /// Show drawer
    func show() {
        if (self.main?.view.frame.origin.x)! > SCREEN_WIDTH/2 {
            return
        }
        self.animator?.isInterative = false
        self.main?.present(self.drawer!, animated: true, completion: nil)
    }

    /// close drawer
    func close() {
        self.animator?.isInterative = false
        self.drawer?.dismiss(animated: true, completion: nil)
    }

}

extension Drawer {

    @objc func dragMainAction(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: self.drawer?.view)
        let percentage = CGFloat(transition.x/SCREEN_WIDTH)
        let velocity = CGFloat(abs(sender.velocity(in: self.drawer?.view).x))
        switch sender.state {
        case .began:
            if transition.x < 0 {
                isResponseRecognizer = false
            }else {
                isResponseRecognizer = true
            }
            if isResponseRecognizer {
                self.beginAnimator(showDrawer: true)
            }
        case .changed:
            if isResponseRecognizer {
                self.updateAnimator(percentage)
            }
        default:
            if isResponseRecognizer {
                self.cancelAnimator(percentage, velocity: velocity)
            }
        }
    }

    @objc func dragDrawerAction(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: self.drawer?.view)
        let percentage = CGFloat(-transition.x/SCREEN_WIDTH)
        let velocity = CGFloat(abs(sender.velocity(in: self.drawer?.view).x))
        switch sender.state {
        case .began:
            if transition.x > 0 {
                isResponseRecognizer = false
            }else {
                isResponseRecognizer = true
            }
            if isResponseRecognizer {
                self.beginAnimator(showDrawer: false)
            }
        case .changed:
            if isResponseRecognizer {
                self.updateAnimator(percentage)
            }
        default:
            if isResponseRecognizer {
                self.cancelAnimator(percentage, velocity: velocity)
            }
        }
    }

    func beginAnimator(showDrawer: Bool) {
        self.animator?.isInterative = true
        if showDrawer {
            self.main?.transitioningDelegate = self.animator
            self.main?.present(self.drawer!, animated: true, completion: nil)
        }else {
            self.drawer?.transitioningDelegate = self.animator
            self.drawer?.dismiss(animated: true, completion: nil)
        }
    }

    func updateAnimator(_ percentage: CGFloat) {
        self.animator?.update(percentage)
    }

    func cancelAnimator(_ percentage: CGFloat, velocity: CGFloat) {
        if percentage < 0.3 && velocity < 300 {
            self.animator?.cancel()
        }else {
            self.animator?.finish()
        }
    }

}
