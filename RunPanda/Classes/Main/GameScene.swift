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
    
    
    //移动速度
    var moveSpeed:CGFloat = 15
    
    //判断最后一个平台还有多远完全进入游戏场景
    var lastDis:CGFloat = 0.0
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //场景的背景颜色
        let skyColor = SKColor(red:113/255,green:197/255,blue:207/255,alpha:1)
        
        backgroundColor = skyColor
        //给熊猫定一个初始位置
        panda.position = CGPointMake(200, 400)
        
        panda.color = SKColor.blueColor()
        //将熊猫显示在场景中
        addChild(panda)
        
        setPlatform()

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
        platformFactory.move(self.moveSpeed)
        
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
    }
    
    func onGetData(dist:CGFloat){
        
        self.lastDis = dist
        
    }
}
