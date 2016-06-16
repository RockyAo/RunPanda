//
//  Platform.swift
//  RunPanda
//
//  Created by RockyAo on 16/6/15.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import SpriteKit

class Platform: SKNode {
    
    //宽
    var width :CGFloat = 0.0
    //高
    var height :CGFloat = 10.0
    
    func onCreate(arrSprite:[SKSpriteNode]){
        //通过接受SKSpriteNode数组来创建平台
        for platform in arrSprite {
            //以当前宽度为平台零件的x坐标
            platform.position.x = width
            //加载
            addChild(platform)
            //更新宽度
            width += platform.size.width
            
            zPosition = 20
            
            physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(width, height) , center: CGPointMake(width/2.0, 0))
            physicsBody?.categoryBitMask = BitMaskType.platform
            physicsBody?.dynamic = false
            physicsBody?.allowsRotation = false
            physicsBody?.restitution = 0;
        }
    }

}
