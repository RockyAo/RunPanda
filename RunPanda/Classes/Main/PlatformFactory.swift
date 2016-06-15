//
//  PlatformFactory.swift
//  RunPanda
//
//  Created by ZCBL on 16/6/15.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import SpriteKit


//定义一个协议，用来接收数据
protocol ProtocolMainScene{
    
    func onGetData(dist:CGFloat)
}

class PlatformFactory: SKNode {

    //定义平台左边纹理
    let textureLeft = SKTexture(imageNamed: "platform_l")
    //定义平台中间纹理
    let textureMid = SKTexture(imageNamed: "platform_m")
    //定义平台右边纹理
    let textureRight = SKTexture(imageNamed: "platform_r")
    
    ///组装平台用的数组
    var platforms = [Platform]()
    
    //游戏场景的宽度
    var sceneWidth:CGFloat = 0
    
    //ProtocolMainScene代理
    var delegate:ProtocolMainScene?
}

extension PlatformFactory{
    
    /// 生成随机平台
    internal func creatPlatformRamdom(){
        
        //随机平台的长度
        let midNum:UInt32 = arc4random()%4 + 1
        //随机间隔
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        //随机x坐标
        let x:CGFloat = self.sceneWidth + CGFloat( midNum*50 ) + gap + 100
        //随机y坐标
        let y:CGFloat = CGFloat(arc4random()%200 + 200)
        
        let platform = self.createPlatform(true, midNum: midNum, x: x, y: y)
        
        //回传距离用于判断什么时候生成新的平台
        delegate?.onGetData(platform.width + x - sceneWidth)

    }
    
    /// 移除平台
    ///
    /// - parameter speed: 速度
    internal func move(speed:CGFloat){
        //遍历所有
        for p in platforms{
            //x坐标的变化长生水平移动的动画
            p.position.x -= speed
        }
        //移除平台
        if platforms[0].position.x < -platforms[0].width {
            platforms[0].removeFromParent()
            platforms.removeAtIndex(0)
        }
    }
}

// MARK: - private method
extension PlatformFactory{

    
    private func createPlatform(isRandom:Bool,midNum:UInt32,x:CGFloat,y:CGFloat)->Platform{
        //声明一个平台类，用来组装平台。
        let platform = Platform()
        //生成平台的左边零件
        let platform_left = SKSpriteNode(texture: textureLeft)
        //设置中心点
        platform_left.anchorPoint = CGPoint(x: 0, y: 0.9)
        //生成平台的右边零件
        let platform_right = SKSpriteNode(texture: textureRight)
        //设置中心点
        platform_right.anchorPoint = CGPoint(x: 0, y: 0.9)
        
        //声明一个数组来存放平台的零件
        var arrPlatform = [SKSpriteNode]()
        
        //将左边零件加入零件数组
        arrPlatform.append(platform_left)
        
        //根据传入的参数来决定要组装几个平台的中间零件
        //然后将中间的零件加入零件数组
        for _ in 1...midNum {
            
            let platform_mid = SKSpriteNode(texture: textureMid)
            platform_mid.anchorPoint = CGPoint(x: 0, y: 0.9)
            arrPlatform.append(platform_mid)
        }
        //将右边零件加入零件数组
        arrPlatform.append(platform_right)
        //将零件数组传入
        platform.onCreate(arrPlatform)
        platform.name = "platform"
        //设置平台的位置
        platform.position = CGPoint(x: x, y: y)
        //放到当前实例中
        addChild(platform)
        //将平台加入平台数组
        platforms.append(platform)
        return platform
    }

}
