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
    var nearBackgroundArray = [SKSpriteNode]()
    
    //远处背景数组
    var farBackgroundArray = [SKSpriteNode]()
    
    
    override init() {
        super.init()
        
        setUpFarBackground()
        setUpNearBackground()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - public method
extension Background{

    internal func move(speed:CGFloat!){
    
        
        for bg in nearBackgroundArray {
            
            bg.position.x -= speed
        }
        
        //循环滚动
        if nearBackgroundArray[0].position.x + nearBackgroundArray[0].frame.width < speed {
            
            nearBackgroundArray[0].position.x = 0
            nearBackgroundArray[1].position.x = nearBackgroundArray[0].frame.width
        }
        
        
        for farBg in farBackgroundArray {
            
            farBg.position.x -= speed/4.0
        }
        
        if farBackgroundArray[0].position.x + farBackgroundArray[0].frame.width < speed/4.0 {
            
            farBackgroundArray.first?.position.x = 0
            farBackgroundArray[1].position.x = farBackgroundArray[0].frame.width
            farBackgroundArray.last?.position.x = farBackgroundArray[0].frame.width * 2
        }

        
    }
}

// MARK: - install method
extension Background{

    ///  创建远景
    private func setUpFarBackground(){
    
        let farTexture = SKTexture(imageNamed: "background_f1")
        
        let farBackgroundLeft = creatSpriteNode(farTexture,zPosition: 9, position: CGPointMake(9, 150))
        
        let farBackgroundCenter = creatSpriteNode(farTexture, zPosition: 9, position: CGPointMake(farBackgroundLeft.frame.width, farBackgroundLeft.position.y))
        
        let farBackgroundRight = creatSpriteNode(farTexture, zPosition: 9, position: CGPointMake(farBackgroundLeft.frame.width * 2,farBackgroundLeft.position.y ))
        
        
        addChild(farBackgroundLeft)
        addChild(farBackgroundCenter)
        addChild(farBackgroundRight)
        farBackgroundArray.append(farBackgroundLeft)
        farBackgroundArray.append(farBackgroundCenter)
        farBackgroundArray.append(farBackgroundRight)
    }
    
    ///  创建近景
    private func setUpNearBackground(){
        
        let nearTexture = SKTexture(imageNamed: "background_f0")
        
        let nearBackgroundLeft = creatSpriteNode(nearTexture, zPosition: 10, position: CGPointMake(0, 70))
        let nearBackgroundRight = creatSpriteNode(nearTexture, zPosition: 10, position: CGPointMake(nearBackgroundLeft.frame.width, nearBackgroundLeft.position.y))
        
        addChild(nearBackgroundLeft)
        addChild(nearBackgroundRight)
        nearBackgroundArray.append(nearBackgroundLeft)
        nearBackgroundArray.append(nearBackgroundRight)
    }
}


// MARK: - private method
extension Background{
    ///  创建背景图
    ///
    ///  - parameter texture:     图
    ///  - parameter anchorPoint: 锚点
    ///  - parameter zPosition:   z坐标
    ///  - parameter position:    位置
    ///
    ///  - returns: 背景
    private func creatSpriteNode(texture:SKTexture!,anchorPoint:CGPoint! = CGPointZero,zPosition:CGFloat!,position:CGPoint!) -> SKSpriteNode {
        
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = anchorPoint!
        node.zPosition = zPosition!
        node.position.x = position.x
        node.position.y = position.y
        
        return node
    }
    
}
