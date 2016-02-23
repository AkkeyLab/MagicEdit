//
//  CommonValue.swift
//  Smartravel
//
//  Created by 板谷晃良 on 2015/12/15.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit

class CommonValue: NSObject {
    //Size fix
    private var fix_x_size: CGFloat = 1
    private var fix_y_size: CGFloat = 1
    private var fix_size:   CGFloat = 1
    //DisplaySize
    private var width:      CGFloat = 0
    private var height:     CGFloat = 0
    //Save
    private let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func setFix_x_size(data: CGFloat){
        fix_x_size = data
        
        defaults.setDouble(Double(fix_x_size), forKey: "fix_x_size")
    }
    
    func setFix_y_size(data: CGFloat){
        fix_y_size = data
        
        defaults.setDouble(Double(fix_y_size), forKey: "fix_y_size")
    }
    
    func setFix_size(data: CGFloat){
        fix_size = data
        
        defaults.setDouble(Double(fix_size), forKey: "fix_size")
    }
    
    func setDisplaySize(myself: UIViewController){ //This is my class
        width   = myself.view.bounds.width
        height  = myself.view.bounds.height //- myself.tabBarController!.tabBar.frame.size.height
        
        defaults.setDouble(Double(width), forKey: "displayWidth")
        defaults.setDouble(Double(height), forKey: "displayHeight")
    }
    
    
    func getFix_x_size() -> CGFloat {
        if defaults.objectForKey("fix_x_size") != nil {
            fix_x_size = CGFloat(defaults.doubleForKey("fix_x_size"))
        }
        return fix_x_size
    }
    
    func getFix_y_size() -> CGFloat {
        if defaults.objectForKey("fix_y_size") != nil {
            fix_y_size = CGFloat(defaults.doubleForKey("fix_y_size"))
        }
        return fix_y_size
    }
    
    func getFix_size() -> CGFloat {
        if defaults.objectForKey("fix_size") != nil {
            fix_size = CGFloat(defaults.doubleForKey("fix_size"))
        }
        return fix_size
    }
    
    func getDisplayWidth() -> CGFloat {
        if defaults.objectForKey("displayWidth") != nil {
            width = CGFloat(defaults.doubleForKey("displayWidth"))
        }
        return width
    }
    
    func getDisplayHeight() -> CGFloat {
        if defaults.objectForKey("displayHeight") != nil {
            height = CGFloat(defaults.doubleForKey("displayHeight"))
        }
        return height
    }
}
