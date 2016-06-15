//
//  BitMaskType.swift
//  RunPanda
//
//  Created by Rocky on 16/6/15.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import Foundation


class BitMaskType {
    
    /// 熊猫标识
    class var panda : UInt32 {
    
        return 1<<0
    }
    
    /// 平台标识
    class var platform : UInt32 {
    
        return 1<<1
    }
    
    /// 苹果标识
    class var apple: UInt32 {
        
        return 1<<2
    }
    
    /// 场景标识
    class var scene: UInt32 {
        
        return 1<<3
    }
    
}