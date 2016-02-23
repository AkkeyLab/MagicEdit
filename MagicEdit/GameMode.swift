//
//  GameMode.swift
//  MagicEdit
//
//  Created by 板谷晃良 on 2016/02/21.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class GameMode: NSObject {
    
    private var gameMode:         String = "new"
    private let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func loadGameMode(){
        if defaults.objectForKey("gameMode") != nil {
            gameMode = defaults.stringForKey("gameMode")!
        }
    }
    
    func saveGameMode(){
        defaults.setObject(gameMode, forKey: "gameMode")
        /*
        let successful = defaults.synchronize()
        if successful {
        NSLog("Successful gameMode save!")
        }
        */
    }
    
    func getMode() -> String {
        loadGameMode()
        
        return gameMode
    }
    
    func setMode(data: String){
        gameMode = data
        
        saveGameMode()
    }
}
