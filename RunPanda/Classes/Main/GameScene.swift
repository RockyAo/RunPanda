//
//  GameScene.swift
//  RunPanda
//
//  Created by ZCBL on 16/6/15.
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
    
    
    //移动速度
    var moveSpeed:CGFloat = 15
    
    //判断最后一个平台还有多远完全进入游戏场景
    var lastDis:CGFloat = 0.0
    
    
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
        
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        //当熊猫状态为跑的时候播放跳的动作
        if panda.status == pandaStatus.run {
            panda.jump()
        }else if panda.status == pandaStatus.jump {
            //当状态为跳的时候，执行打滚动画
            panda.jump_effect()
        }else if panda.status == pandaStatus.jump_effect{
        
            panda.roll()
        }
    }
    

    override func update(currentTime: CFTimeInterval) {
        lastDis -= moveSpeed
        if lastDis <= 0 {
            printRALog("生成新平台")
            platformFactory.creatPlatformRamdom()
        }
        platformFactory.move(moveSpeed)
        background.move(moveSpeed/5.0)
        
    }
    
}

// MARK: - ProtocolMainScene
extension GameScene : ProtocolMainScene{

   private func setPlatform(){
        
        //将平台工厂加入视图
        addChild(platformFactory)
        //将屏幕的宽度传到平台工厂类中
        platformFactory.sceneWidth = self.frame.width
        //设置代理
        platformFactory.delegate = self
    
        platformFactory.creatPlatform(3, x: 0, y: 200)
    }
    
    func onGetData(dist:CGFloat){
        
        self.lastDis = dist
        
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
        
        if contact.bodyA.categoryBitMask == BitMaskType.panda && contact.bodyB.contactTestBitMask == BitMaskType.scene{
            
            printRALog("游戏结束")
        }
        
        
        if contact.bodyA.categoryBitMask == BitMaskType.platform || contact.bodyB.categoryBitMask == BitMaskType.panda  {
            
            panda.run()
        }
    }
}
