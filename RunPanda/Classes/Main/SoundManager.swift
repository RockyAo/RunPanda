//
//  SoundManager.swift
//  RunPanda
//
//  Created by ZCBL on 16/6/17.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import SpriteKit

import AVFoundation


class SoundManager: SKNode {
    
    private lazy var backgroundMusicPlayer:AVAudioPlayer = {
        
        //获取apple.mp3文件地址
        let bgMusicURL:NSURL =  NSBundle.mainBundle().URLForResource("apple", withExtension: "mp3")!
        //根据背景音乐地址生成播放器
        
        let musicPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicURL)
        
        //设置为循环播放
        musicPlayer.numberOfLoops = -1
        
        return musicPlayer
    }()
    
     /// 跳的声效
    private var jumpAct = SKAction.playSoundFileNamed("jump_from_platform.mp3", waitForCompletion: false)
     /// 游戏失败
    private let loseAct = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    ///播放滚动音效的动作
    private let rollAct = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    ///播放吃苹果音效的动作
    private let eatAct = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    

}

extension SoundManager{

    internal func playBackgroundMusic(){
    
        if !backgroundMusicPlayer.playing {
            
            //准备播放音乐
            backgroundMusicPlayer.prepareToPlay()
            //播放音乐
            backgroundMusicPlayer.play()
        }

    }
    
    internal func stopPlayBackgroundMusic(){
    
        if backgroundMusicPlayer.playing {
             backgroundMusicPlayer.stop()
        }
       
    }
    
    ///播放game over 音效动作的方法
    internal func playDead(){
        runAction(loseAct)
    }
    ///播放起跳音效动作的方法
    internal func playJump(){
        runAction(jumpAct)
    }
    
    ///播放打滚音效动作的方法
    internal func playRoll(){
        runAction(rollAct)
    }
    
    ///播放吃苹果音效动作的方法
    internal func playEat(){
        runAction(eatAct)
    }
    

}
