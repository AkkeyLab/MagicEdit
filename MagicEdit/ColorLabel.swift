//
//  colorLabel.swift
//  MagicEdit
//
//  Created by 板谷晃良 on 2016/02/21.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class ColorLabel: NSObject {
    
    func makeLabel(myself: UIViewController){
        let value = CommonValue()
        let fix_x = value.getFix_x_size()
        let fix_y = value.getFix_y_size()
        let fix   = value.getFix_size()
        
        let leftLabelBK: UILabel = UILabel(frame: CGRectMake(0, 0, 250 * fix_x, 250 * fix_y))
        leftLabelBK.backgroundColor = UIColor.whiteColor()
        leftLabelBK.layer.masksToBounds = true
        leftLabelBK.layer.cornerRadius = 10.0 * fix
        leftLabelBK.layer.position = CGPoint(x: 150 * fix_x, y: 150 * fix_y)
        myself.view.addSubview(leftLabelBK)
        
        let rightLabelBK: UILabel = UILabel(frame: CGRectMake(0, 0, 250 * fix_x, 250 * fix_y))
        rightLabelBK.backgroundColor = UIColor.whiteColor()
        rightLabelBK.layer.masksToBounds = true
        rightLabelBK.layer.cornerRadius = 10.0 * fix
        rightLabelBK.layer.position = CGPoint(x: 450 * fix_x, y: 150 * fix_y)
        myself.view.addSubview(rightLabelBK)
        
        let rightLabelBK2: UILabel = UILabel(frame: CGRectMake(0, 0, 50 * fix_x, 50 * fix_y))
        rightLabelBK2.backgroundColor = UIColor.whiteColor()
        rightLabelBK2.layer.masksToBounds = true
        rightLabelBK2.layer.cornerRadius = 10.0 * fix
        rightLabelBK2.layer.position = CGPoint(x: 600 * fix_x, y: 50 * fix_y)
        myself.view.addSubview(rightLabelBK2)
        
        let leftLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 250 * fix_x, 250 * fix_y))
        leftLabel.backgroundColor = UIColor.orangeColor()
        leftLabel.layer.masksToBounds = true
        leftLabel.layer.cornerRadius = 10.0 * fix
        leftLabel.layer.position = CGPoint(x: 150 * fix_x, y: 150 * fix_y)
        leftLabel.alpha = 0.5
        myself.view.addSubview(leftLabel)
        
        let rightLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 250 * fix_x, 250 * fix_y))
        rightLabel.backgroundColor = UIColor.blueColor()
        rightLabel.layer.masksToBounds = true
        rightLabel.layer.cornerRadius = 10.0 * fix
        rightLabel.layer.position = CGPoint(x: 450 * fix_x, y: 150 * fix_y)
        rightLabel.alpha = 0.5
        myself.view.addSubview(rightLabel)
        
        let rightLabel2: UILabel = UILabel(frame: CGRectMake(0, 0, 50 * fix_x, 50 * fix_y))
        rightLabel2.backgroundColor = UIColor.blueColor()
        rightLabel2.layer.masksToBounds = true
        rightLabel2.layer.cornerRadius = 10.0 * fix
        rightLabel2.layer.position = CGPoint(x: 600 * fix_x, y: 50 * fix_y)
        rightLabel2.alpha = 0.5
        myself.view.addSubview(rightLabel2)
    }
}
