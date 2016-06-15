//
//  GameScene.swift
//  RunPanda
//
//  Created by ZCBL on 16/6/15.
//  Copyright (c) 2016年 RockyAo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private lazy var panda:Panda = {
    
        let newPanda = Panda()
        
        return newPanda
    }()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //场景的背景颜色
        let skyColor = SKColor(red:113/255,green:197/255,blue:207/255,alpha:1)
        
        backgroundColor = skyColor
        //给熊猫定一个初始位置
        panda.position = CGPointMake(200, 400)
        //将熊猫显示在场景中
        addChild(panda)

    }
    
}
