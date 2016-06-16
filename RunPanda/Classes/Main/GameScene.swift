//
//  GameScene.swift
//  RunPanda
//
//  Created by RockyAo on 16/6/15.
//  Copyright (c) 2016年 RockyAo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene{
    
    private lazy var panda:Panda = {
    
        let newPanda = Panda()
        
        return newPanda
    }()
    
    private lazy var platformFactory:PlatformFactory = {
    
        let newFactory = PlatformFactory()
        
        
        return newFactory
    }()
    
    private lazy var background:Background = {
    
        let bg = Background()
        
        return bg
    }()
    
    private lazy var appleFactory:AppleFactory = {
    
        let newFactory = AppleFactory()
        
        return newFactory
    }()
    
    
    //移动速度
    var moveSpeed:CGFloat = 15
    
    //判断最后一个平台还有多远完全进入游戏场景
    var lastDis:CGFloat = 0.0
    
    /// 苹果的高度
    var appleY:CGFloat = 0.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //场景的背景颜色
        let skyColor = SKColor(red:113/255,green:197/255,blue:207/255,alpha:1)
        //设置物理引擎
        setupPhysics()
        
        backgroundColor = skyColor
        //给熊猫定一个初始位置
        panda.position = CGPointMake(200, 400)
        
        panda.color = SKColor.blueColor()
        //将熊猫显示在场景中
        addChild(panda)
        
        //将平台添加到场景中
        setPlatform()
        
        //将背景添加到场景中
        addChild(background)
        
        appleFactory.onInit(frame.width, y: appleY)
        
        addChild(appleFactory)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        panda.jump()
    }
    

    override func update(currentTime: CFTimeInterval) {
        lastDis -= moveSpeed
        if lastDis <= 0 {
            printRALog("生成新平台")
            platformFactory.creatPlatformRamdom()
        }
        platformFactory.move(moveSpeed)
        background.move(moveSpeed/5.0)
        appleFactory.move(moveSpeed)
    }
    
}

// MARK: - ProtocolMainScene
extension GameScene : ProtocolMainScene{

    ///  设置平台
   private func setPlatform(){
        
        //将平台工厂加入视图
        addChild(platformFactory)
        //将屏幕的宽度传到平台工厂类中
        platformFactory.sceneWidth = self.frame.width
        //设置代理
        platformFactory.delegate = self
    
        platformFactory.creatPlatform(3, x: 0, y: 200)
    }
    
    func onGetData(dist:CGFloat,appleY:CGFloat){
        self.lastDis = dist
        self.appleY = appleY
        appleFactory.appleY = appleY
        
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene : SKPhysicsContactDelegate{

    ///  设置场景物理引擎
    private func setupPhysics(){
    
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -9.8)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsBody?.categoryBitMask = BitMaskType.scene
        physicsBody?.dynamic = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if(contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask) == (BitMaskType.apple|BitMaskType.panda) {
            
            
            printRALog("熊猫撞苹果");
        }
        
        if (contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask) == (BitMaskType.platform|BitMaskType.panda){
            
            printRALog("碰撞平台")
            
            panda.run()
            
            panda.jumpEnd = panda.position.y
            
            if panda.jumpEnd - panda.jumpStart <= -70 {
                
                panda.roll()
                
                downAndUp(contact.bodyA.node!)
                downAndUp(contact.bodyB.node!)

            }
        }
        
        
        if (contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            printRALog("游戏结束")
            
        }

    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        panda.jumpStart = panda.position.y
    }
    
    func downAndUp(node :SKNode,down:CGFloat = -50,downTime:Double=0.05,up:CGFloat=50,upTime:Double=0.1,isRepeat:Bool=false){
        //下沉动作
        let downAct = SKAction.moveByX(0, y: down, duration: downTime)
        //上升动过
        let upAct = SKAction.moveByX(0, y: up, duration: upTime)
        //下沉上升动作序列
        let downUpAct = SKAction.sequence([downAct,upAct])
        if isRepeat {
            node.runAction(SKAction.repeatActionForever(downUpAct))
        }else {
            node.runAction(downUpAct)
        }
    }

}
