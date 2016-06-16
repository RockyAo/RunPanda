//
//  Panda.swift
//  RunPanda
//
//  Created by ZCBL on 16/6/15.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit

import SpriteKit

/// 熊猫动作枚举
///
/// - run:   跑
/// - jump:  跳
/// - jump_effect: 二段跳
/// - roll:  打滚
enum pandaStatus:Int {
    case run = 1
    case jump
    case jump_effect
    case roll
}

class Panda: SKSpriteNode {
 
    private let timeDuration = 0.05
    
    ///熊猫跑纹理合集
    private let runAtlas = SKTextureAtlas(named: "run.atlas")
    
    /// 跑纹理数组
    private var runFrame = [SKTexture]()
    
    /// 跳纹理合集
    private let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    
     /// 跳纹理数组
    private var jumpFrame = [SKTexture]()
    
     /// 打滚纹理
    private let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    
     /// 打滚纹理数组
    private var rollFrame = [SKTexture]()
    
    internal  var  status = pandaStatus.run
    
    //起跳 y坐标
    var jumpStart:CGFloat = 0.0
    //落地 y坐标
    var jumpEnd :CGFloat = 0.0
    
    //起跳特效纹理集
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    //存储七条特效纹理的数组
    var jumpEffectFrames = [SKTexture]()
    //起跳特效
    var jumpEffect = SKSpriteNode()
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let tture = runAtlas.textureNamed("panda_run_01")
        
        
        let size = tture.size()
        
        super.init(texture: tture, color: color, size: size)
        
        
        zPosition = 20
        
        setupAllPhotoFrame(tture)
        
        run()
        
        setUpPhysics(tture)
        
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPointMake(-80, -30)
        jumpEffect.hidden = true
        addChild(jumpEffect)


    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 物理引擎

extension Panda{

    private func setUpPhysics(texture:SKTexture?){
        
        //根据文理尺寸设置物理体
        physicsBody = SKPhysicsBody(rectangleOfSize: texture?.size() ?? CGSizeZero)
        
        
        //允许物理检测
        physicsBody?.dynamic = true
        //不允许转动
        physicsBody?.allowsRotation = false
        //弹性
        physicsBody?.restitution = 0
        
        physicsBody?.categoryBitMask = BitMaskType.panda
        
        physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform
        
        
    }
}

// MARK: - 初始化
extension Panda{
    
    private func setupAllPhotoFrame(texture:SKTexture?){

        
        /// 初始化跑纹理数组
        for i in 1..<runAtlas.textureNames.count {
            
            let tempName = String(format: "panda_run_%.2d", i)
            let runTexture = runAtlas.textureNamed(tempName)
            runFrame.append(runTexture)
        }
        
        /// 初始化跳纹理数组
        for i in 1..<jumpAtlas.textureNames.count {
            
            let tempName = String(format: "panda_jump_%.2d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            jumpFrame.append(jumpTexture)
        }
        
        ///填充打滚的纹理数组
        for i in 1..<rollAtlas.textureNames.count {
            
            let tempName = String(format: "panda_roll_%.2d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            rollFrame.append(rollTexture)
        }
        
        for i in 1..<jumpEffectAtlas.textureNames.count {
            
            let tempName = String(format: "jump_effect_%.2d", i)
            let effectexture = jumpEffectAtlas.textureNamed(tempName)
            jumpEffectFrames.append(effectexture)
            
        }

    }
}

// MARK: - 熊猫动作函数
extension Panda{

    /// 跑路函数
    internal func run() -> Void {
        
        //移除所有的动作
        removeAllActions()
        //将当前动作状态设为跑
        status = .run
        //通过SKAction.animateWithTextures将跑的文理数组设置为0.05秒切换一次的动画
//         SKAction.repeatActionForever将让动画永远执行
        // self.runAction执行动作形成动画
        runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runFrame, timePerFrame: timeDuration)))

    }
    
    ///跳
    internal func jump (){
        
        removeAllActions()
        if status != pandaStatus.jump_effect {
            runAction(SKAction.animateWithTextures(jumpFrame, timePerFrame: timeDuration))
            //施加一个向上的力，让熊猫跳起来
            physicsBody?.velocity = CGVectorMake(0, 500)
            if status == pandaStatus.jump {
                status = pandaStatus.jump_effect
                jumpStart = position.y
            }else{
                showJumpEffect()
                status = pandaStatus.jump
            }
        }
    }
    
    
    ///打滚
    internal func roll(){
        removeAllActions()
        status = .roll
        runAction(SKAction.animateWithTextures(rollFrame, timePerFrame: timeDuration),completion:{() in self.run()})
    }
    
    ///起跳特效
    private func showJumpEffect(){
        //先将特效取消隐藏
        jumpEffect.hidden = false
        //利用action播放特效
        let ectAct = SKAction.animateWithTextures( jumpEffectFrames, timePerFrame: timeDuration)
        //执行闭包，再次隐藏特效
        let removeAct = SKAction.runBlock({() in
            self.jumpEffect.hidden = true
        })
        //组成序列Action进行执行
        jumpEffect.runAction(SKAction.sequence([ectAct,removeAct]))
    }
    


}
