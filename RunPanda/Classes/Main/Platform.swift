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
    
    //是否下沉
    var isDown = false
    //是否升降
    var isShock = false
    
    func onCreate(arrSprite:[SKSpriteNode]){
        //通过接受SKSpriteNode数组来创建平台
        
        //通过接受SKSpriteNode数组来创建平台
        for platform in arrSprite {
            //以当前宽度为平台零件的x坐标
            platform.position.x = width
            //加载
            addChild(platform)
            //更新宽度
            width += platform.size.width
            
        }
        
        //当平台的零件只有三样，左中右时，设为会下落的平台
        if arrSprite.count<=3 {
            isDown = true
        }else{
            //如果超过3，则有30%的几率称为会升降的平台
            let random = arc4random()%10
            if random > 6 {
                isShock = true
            }
        }

        zPosition = 20
        physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(width, height) , center: CGPointMake(width/2.0, 0))
        physicsBody?.categoryBitMask = BitMaskType.platform
        physicsBody?.dynamic = false
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0;

    }

}
