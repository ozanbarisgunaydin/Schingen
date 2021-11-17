//
//  Extensions.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 10.11.2021.
//

import Foundation
import UIKit

//  This extension use for the  generate layouts with quick way
extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
}

extension Notification.Name {
    /// This is the notification when user logged in.
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
