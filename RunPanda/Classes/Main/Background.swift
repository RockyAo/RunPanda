//
//  Background.swift
//  RunPanda
//
//  Created by ZCBL on 16/6/15.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import SpriteKit

class Background: SKNode {

    //近处背景数组
    var backgroundArray = [SKSpriteNode]()
    
    //远处背景数组
    var farBackgroundArray = [SKSpriteNode]()
    
    
    override init() {
        super.init()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
