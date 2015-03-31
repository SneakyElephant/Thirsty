//
//  Styling.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/30/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import Foundation

extension UIColor {
    class func backgroundColor () -> UIColor {
        return UIColor(red: 162/255, green: 68/255, blue: 200/255, alpha: 1)
    }
    
    class func buttonColor () -> UIColor {
        return UIColor(red: 176/255, green: 91/255, blue: 219/255, alpha: 1)
    }
    
    class func listItemsColor () -> UIColor {
        return UIColor(red: 186/255, green: 103/255, blue: 228/255, alpha: 1)
    }
    
    class func selectedColor () -> UIColor {
        return UIColor(red: 109/255, green: 37/255, blue: 138/255, alpha: 1)
    }
}

extension UIFont {
    class func titleFont () -> UIFont? {
        return UIFont(name: "Roboto-Medium", size: 18)
    }
    
    class func bodyFont () -> UIFont? {
        return UIFont(name: "Roboto-Light", size: 14)
    }
    
    class func buttonFont () -> UIFont? {
        return UIFont(name: "Roboto-Light", size: 13)
    }
}