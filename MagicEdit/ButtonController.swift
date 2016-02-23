//
//  ButtonController.swift
//  MagicEdit
//
//  Created by 板谷晃良 on 2016/02/22.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class ButtonController: NSObject {
    
    private var buttons: [[UIButton]] = [[UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()]]
    
    private let viewText: [[String]] = [["あ","か","さ","た","な","゛","は","ま","や","ら","わ","ん"],
                                        ["い","き","し","ち","に","゜","ひ","み","い","り","ゐ","消"],
                                        ["う","く","す","つ","ぬ","。","ふ","む","ゆ","る","う","😃"],
                                        ["え","け","せ","て","ね","、","へ","め","え","れ","ゑ","消"],
                                        ["お","こ","そ","と","の","小","ほ","も","よ","ろ","を","Ｂ"]]
    //dakuten
    private let dackText: [[String]] = [["あ","が","ざ","だ","な","゛","ば","ま","や","ら","わ","ん"],
                                        ["い","ぎ","じ","ぢ","に","゜","び","み","い","り","ゐ","消"],
                                        ["う","ぐ","ず","づ","ぬ","。","ぶ","む","ゆ","る","う","😃"],
                                        ["え","げ","ぜ","で","ね","、","べ","め","え","れ","ゑ","消"],
                                        ["お","ご","ぞ","ど","の","小","ぼ","も","よ","ろ","を","Ｂ"]]
    //handakuten
    private let hDakText: [[String]] = [["あ","か","さ","た","な","゛","ぱ","ま","や","ら","わ","ん"],
                                        ["い","き","し","ち","に","゜","ぴ","み","い","り","ゐ","消"],
                                        ["う","く","す","つ","ぬ","。","ぷ","む","ゆ","る","う","😃"],
                                        ["え","け","せ","て","ね","、","ぺ","め","え","れ","ゑ","消"],
                                        ["お","こ","そ","と","の","小","ぽ","も","よ","ろ","を","Ｂ"]]
    //mini
    private let miniText: [[String]] = [["ぁ","ヵ","さ","た","な","゛","は","ま","ゃ","ら","わ","ん"],
                                        ["ぃ","き","し","ち","に","゜","ひ","み","ぃ","り","ゐ","消"],
                                        ["ぅ","く","す","っ","ぬ","。","ふ","む","ゅ","る","ぅ","😃"],
                                        ["ぇ","ヶ","せ","て","ね","、","へ","め","ぇ","れ","ゑ","消"],
                                        ["ぉ","こ","そ","と","の","小","ほ","も","ょ","ろ","を","Ｂ"]]
    
    func getButtonText(y: Int, x: Int) -> String {
        return viewText[y][x]
    }
    
    func getDackText(y: Int, x: Int) -> String {
        return dackText[y][x]
    }
    
    func getHDakText(y: Int, x: Int) -> String {
        return hDakText[y][x]
    }
    
    func getMiniText(y: Int, x: Int) -> String {
        return miniText[y][x]
    }
    
    func getButtonObject(y: Int, x: Int) -> UIButton {
        return buttons[y][x]
    }
    
    func setButtons(myself: UIViewController){
        for var y = 0; y < 5; y++ {
            for var x = 0; x < 12; x++ {
                buttons[y][x].frame = CGRectMake(0,0,40,40)
                buttons[y][x].backgroundColor = UIColor.whiteColor()
                buttons[y][x].layer.masksToBounds = true
                buttons[y][x].setTitle(viewText[y][x], forState: UIControlState.Normal)
                buttons[y][x].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                buttons[y][x].setTitle(viewText[y][x], forState: UIControlState.Highlighted)
                buttons[y][x].setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
                buttons[y][x].layer.cornerRadius = 10.0
                buttons[y][x].layer.position = CGPoint(x: 50 * (x + 1), y: 50 * (y + 1))
                buttons[y][x].tag = 1
                buttons[y][x].alpha = 0.7
                buttons[y][x].addTarget(myself, action: "onClickButton:", forControlEvents: .TouchUpInside)
                myself.view.addSubview(buttons[y][x])
            }
        }
        buttons[4][11].backgroundColor = UIColor.blueColor()
        buttons[4][11].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
}
