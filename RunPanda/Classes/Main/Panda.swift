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
    
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        setupAllPhotoFrame(texture)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 初始化
extension Panda{
    
    private func setupAllPhotoFrame(texture:SKTexture?){
        
        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        
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
        
        //填充打滚的纹理数组
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
        
        
    }
    
    
}
