//
//  CheckDisplay.swift
//  Smartravel
//
//  Created by 板谷晃良 on 2016/01/03.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class CheckDisplay: NSObject {

    func checkDisplaySize(){
        let value  = CommonValue()
        let width  = value.getDisplayWidth()
        let height = value.getDisplayHeight()
        
        value.setFix_x_size(width / 375)
        value.setFix_y_size(height / 618)
        
        let fix_x  = value.getFix_x_size()
        let fix_y  = value.getFix_y_size()
        
        value.setFix_size((fix_x + fix_y) / 2)
    }
}
