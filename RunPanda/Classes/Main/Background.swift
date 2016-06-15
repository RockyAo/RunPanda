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
        
        let farTexture = SKTexture(imageNamed: "background_f1")
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func creatSpriteNode(texture:SKTexture!,anchorPoint:CGPoint!,zPosition:CGFloat!,position:CGPoint!) -> SKSpriteNode {
    
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = anchorPoint!
        node.zPosition = zPosition!
        node.position.x = position.x
        node.position.y = position.y
        
        return node
    }
}
