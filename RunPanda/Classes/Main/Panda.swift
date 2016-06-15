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
    
    /// 二段跳
    private let jump_effect_Atlas = SKTextureAtlas(named: "jump_effect")
    
    /// 二段跳纹理数组
    private var jump_effect_frames = [SKTexture]()
    
     /// 打滚纹理
    private let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    
     /// 打滚纹理数组
    private var rollFrame = [SKTexture]()
    
    internal  var  status = pandaStatus.run
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let size = runAtlas.textureNamed("panda_run_01").size()
        
        super.init(texture: texture, color: color, size: size)
        
        setupAllPhotoFrame(texture)
        
        run()

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        /// 初始化二段跳
        for i in 1..<jump_effect_Atlas.textureNames.count {
            
            let tempName = String(format: "jump_effect_%.2d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            jump_effect_frames.append(jumpTexture)
        }
        
        ///填充打滚的纹理数组
        for i in 1..<rollAtlas.textureNames.count {
            
            let tempName = String(format: "panda_roll_%.2d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            rollFrame.append(rollTexture)
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
        status = .jump
        runAction(SKAction.animateWithTextures(jumpFrame, timePerFrame: timeDuration))
    }
    
    /// 二段跳
    internal func jump_effect(){
    
        removeAllActions()
        
        status = .jump_effect
        
        runAction(SKAction.animateWithTextures(jump_effect_frames, timePerFrame: timeDuration))
    }
    
    ///打滚
    internal func roll(){
        self.removeAllActions()
        status = .roll
        self.runAction(SKAction.animateWithTextures(rollFrame, timePerFrame: timeDuration),completion:{() in self.run()})
    }

}
