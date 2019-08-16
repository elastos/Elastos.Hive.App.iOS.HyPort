//
//  SuspendDelegate.swift
//
//  Created by 李爱红 on 2018/9/28.
//  Copyright © 2018年 李爱红. All rights reserved.
//

import Foundation

/**
 Optional delegate that can be used to be notified whenever the user
 taps on a FAB that does not contain any sub items.
 */
@objc public protocol SuspendDelegate {
  /**
   Indicates that the user has tapped on a FAB widget that does not
   contain any defined sub items.
   - parameter suspend: The FAB widget that was selected by the user.
   */
  @objc optional func emptySuspendSelected(_ suspend: Suspend)

  @objc optional func suspendShouldOpen(_ suspend: Suspend) -> Bool
  
  @objc optional func suspendWillOpen(_ suspend: Suspend)
  
  @objc optional func suspendDidOpen(_ suspend: Suspend)

  @objc optional func suspendShouldClose(_ suspend: Suspend) -> Bool
  
  @objc optional func suspendWillClose(_ suspend: Suspend)
  
  @objc optional func suspendDidClose(_ suspend: Suspend)
  
  /**
   This method has been deprecated. Use suspendWillOpen and suspendDidOpen instead.
   */
  @objc optional func suspendOpened(_ suspend: Suspend)
  
  /**
   This method has been deprecated. Use suspendWillClose and suspendDidClose instead.
   */
  @objc optional func suspendClosed(_ suspend: Suspend)
}
