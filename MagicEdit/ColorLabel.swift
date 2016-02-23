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
        
        let leftLabelBK: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        leftLabelBK.backgroundColor = UIColor.whiteColor()
        leftLabelBK.layer.masksToBounds = true
        leftLabelBK.layer.cornerRadius = 10.0
        leftLabelBK.layer.position = CGPoint(x: 150, y: 150)
        myself.view.addSubview(leftLabelBK)
        
        let rightLabelBK: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        rightLabelBK.backgroundColor = UIColor.whiteColor()
        rightLabelBK.layer.masksToBounds = true
        rightLabelBK.layer.cornerRadius = 10.0
        rightLabelBK.layer.position = CGPoint(x: 450, y: 150)
        myself.view.addSubview(rightLabelBK)
        
        let rightLabelBK2: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 50))
        rightLabelBK2.backgroundColor = UIColor.whiteColor()
        rightLabelBK2.layer.masksToBounds = true
        rightLabelBK2.layer.cornerRadius = 10.0
        rightLabelBK2.layer.position = CGPoint(x: 600, y: 50)
        myself.view.addSubview(rightLabelBK2)
        
        let leftLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        leftLabel.backgroundColor = UIColor.orangeColor()
        leftLabel.layer.masksToBounds = true
        leftLabel.layer.cornerRadius = 10.0
        leftLabel.layer.position = CGPoint(x: 150, y: 150)
        leftLabel.alpha = 0.5
        myself.view.addSubview(leftLabel)
        
        let rightLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        rightLabel.backgroundColor = UIColor.blueColor()
        rightLabel.layer.masksToBounds = true
        rightLabel.layer.cornerRadius = 10.0
        rightLabel.layer.position = CGPoint(x: 450, y: 150)
        rightLabel.alpha = 0.5
        myself.view.addSubview(rightLabel)
        
        let rightLabel2: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 50))
        rightLabel2.backgroundColor = UIColor.blueColor()
        rightLabel2.layer.masksToBounds = true
        rightLabel2.layer.cornerRadius = 10.0
        rightLabel2.layer.position = CGPoint(x: 600, y: 50)
        rightLabel2.alpha = 0.5
        myself.view.addSubview(rightLabel2)
    }
}
