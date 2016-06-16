//
//  AppleFactory.swift
//  RunPanda
//
//  Created by RockyAo on 16/6/16.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import SpriteKit

class AppleFactory: SKNode {
    //定义苹果纹理
    private let appleTexture = SKTexture(imageNamed: "apple")
    //游戏场景的狂赌
    internal var sceneWidth :CGFloat = 0.0
    //定义苹果数组
    private var appleArray = [SKSpriteNode]()
    
    internal var appleY:CGFloat = 0.0
    
    private var timer = NSTimer()
    
  
}
// MARK: - public method
extension AppleFactory{
    
    internal func onInit(width:CGFloat, y:CGFloat) {
        
        sceneWidth = width
        appleY = y
        
        //启动的定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(creatApple), userInfo: nil, repeats: true)
    }

    /// 创建苹果
    internal func creatApple(){
        
        let random = arc4random()%10
        
        if random > 8 {
            
            let apple = SKSpriteNode(texture: appleTexture)
            
            apple.physicsBody = SKPhysicsBody(rectangleOfSize: apple.size)
            
            apple.physicsBody?.restitution = 0.0
            
            apple.physicsBody?.categoryBitMask = BitMaskType.apple
            

            
            apple.physicsBody?.dynamic = false
            
            apple.anchorPoint = CGPointZero
            
            apple.zPosition = 40
            
            apple.position = CGPointMake(sceneWidth+apple.frame.width, appleY+150)
            
            appleArray.append(apple)
            
            addChild(apple)
        }
        
    }
    
    
    /// 苹果移动
    ///
    /// - parameter speed: 速度
    internal func move(speed:CGFloat){
        
        for apple in appleArray {
            
            apple.position.x -= speed
        }
        
        if appleArray.count > 0 && appleArray[0].position.x < -20{
            
            appleArray[0].removeFromParent()
            appleArray.removeAtIndex(0)
        }
    }
}
