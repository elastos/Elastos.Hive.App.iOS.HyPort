//
//  Animator.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

let DRAWER_ANIMATION_TIME = 0.3

class Animator: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    /// Interactive trancition true or false
    var isInterative = false

    /// Show drawer true or false
    var isShowDrawer = false

    /// The mainViewController
    var main: UIViewController?

    /// The drawerViewController
    var drawer:UIViewController?

    /// The width of the mainViewController when displayed in the drawer
    var baseWidth: CGFloat = 100


    /// mask
    lazy var mask = { () -> UIButton in
        let mask = UIButton()
        mask.addTarget(self, action: #selector(maskClicked(_:)), for: .touchUpInside)
        return mask
    }()

    init(_ main: UIViewController, _ drawer: UIViewController) {
        super.init()
        self.main = main
        self.drawer = drawer
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(observeDeviceOrientation(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func observeDeviceOrientation(_ notification: NSObject) {
        if let superView = self.main?.view.superview {
            if isShowDrawer {
                self.main?.view.snp.remakeConstraints({ (make) in
                    make.width.equalTo(SCREEN_WIDTH)
                    make.left.equalTo(superView.snp.right).offset(-self.baseWidth)
                    make.top.bottom.equalTo(superView)
                })
            }else {
                self.main?.view.snp.remakeConstraints({ (make) in
                    make.edges.equalTo(superView)
                })
            }
            superView.layoutIfNeeded()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension Animator {

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isShowDrawer {
            let fromView = transitionContext.view(forKey: .from)
            addShadowToView(fromView!, color: .black, offset: CGSize(width: -1, height: 0), radius: 3, opacity: 0.1)
            let toView = transitionContext.view(forKey: .to)
            let containerView = transitionContext.containerView
            containerView.addSubview(toView!)
            containerView.addSubview(fromView!)
            fromView?.snp.remakeConstraints({ (make) in
                make.edges.equalTo(containerView)
            })
            toView?.snp.remakeConstraints({ (make) in
                make.edges.equalTo(containerView)
            })
            containerView.layoutIfNeeded()
            UIView.animate(withDuration: DRAWER_ANIMATION_TIME, animations: {
                fromView?.snp.remakeConstraints({ (make) in
                    make.left.equalTo((toView?.snp.right)!).offset(-self.baseWidth)
                    make.width.top.bottom.equalTo(toView!)
                })
                containerView.layoutIfNeeded()
            }) { (finish) in
                let cancel = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancel)
                if !cancel {// Distinguish which parent view to add in the cancel state. Mistakes can lead to black screens
                    if self.drawer?.view.superview != nil {
                        self.drawer?.view?.snp.remakeConstraints({ (make) in
                            make.edges.equalTo((self.drawer?.view?.superview)!)
                        })
                    }
                    self.showPartOfView()
                }else {
                    fromView?.snp.remakeConstraints({ (make) in
                        make.edges.equalTo((fromView?.superview)!)
                    })
                }
            }
        }else {
            let fromView = transitionContext.view(forKey: .from)
            let toView = transitionContext.view(forKey: .to)
            addShadowToView(toView!, color: .black, offset: CGSize(width: -1, height: 0), radius: 3, opacity: 0.1)
            let containerView = transitionContext.containerView
            containerView.addSubview(fromView!)
            containerView.addSubview(toView!)
            fromView?.snp.remakeConstraints({ (make) in
                make.edges.equalTo(containerView)
            })
            toView?.snp.remakeConstraints({ (make) in
                make.left.equalTo(containerView.snp.right).offset(-self.baseWidth)
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(SCREEN_HEIGHT)
                make.top.bottom.equalTo(containerView)
            })
            containerView.layoutIfNeeded()
            UIView.animate(withDuration: DRAWER_ANIMATION_TIME, animations: {
                toView?.snp.remakeConstraints({ (make) in
                    make.edges.equalTo(containerView)
                })
                containerView.layoutIfNeeded()
            }) { (finish) in
                let cancel = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancel)
                toView?.snp.remakeConstraints({ (make) in
                    make.edges.equalTo((toView?.superview)!)
                })
                if minX((self.main?.view)!) <= 0 {// Whether return to the mainView at the end
                    self.main?.view.isUserInteractionEnabled = true
                }
            }
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return DRAWER_ANIMATION_TIME
    }

    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isShowDrawer = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isShowDrawer = false
        return self
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInterative {
            return self
        }else {
            return nil
        }
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInterative {
            return self
        }else {
            return nil
        }
    }

}


extension Animator {

    func showPartOfView() {
        self.drawer?.view.addSubview((self.main?.view)!)
        self.main?.view.snp.remakeConstraints({ (make) in
            make.left.equalTo((self.drawer?.view.snp.right)!).offset(-self.baseWidth)
            make.top.bottom.equalTo((self.drawer?.view)!)
            make.width.equalTo(SCREEN_WIDTH)
        })
        // mask
        self.drawer?.view.insertSubview(mask, aboveSubview: (self.main?.view)!)
        self.main?.view.isUserInteractionEnabled = false// close interaction
        mask.snp.remakeConstraints { (make) in
            make.left.equalTo((mask.superview?.snp.right)!).offset(-baseWidth)
            make.top.width.bottom.equalTo(mask.superview!);
        }
        self.drawer?.view.superview?.layoutIfNeeded()
    }

    @objc func maskClicked(_ button: UIButton) {
        button.removeFromSuperview()
        self.drawer?.dismiss(animated: true, completion: nil)
    }

}
