//
//  RemoveSubviews.swift
//  MagicEdit
//
//  Created by 板谷晃良 on 2016/01/04.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class RemoveSubviews: NSObject {
    
    //@1:remove view @2:remove kind(String type)
    func removeAllSubviews(parentView: UIView, kind: String){
        let subviews = parentView.subviews
        for subview in subviews {
            if kind == "ble_start" {
                if subview.tag == 200 {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
