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
    
    private var backgroundMusicPlayer = AVAudioPlayer()
    
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
    
        //获取apple.mp3文件地址
        let bgMusicURL:NSURL =  NSBundle.mainBundle().URLForResource("apple", withExtension: "mp3")!
        //根据背景音乐地址生成播放器
        
        do{
           try backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL)
        }catch let error as NSError {
        
            printRALog(error)
        }
        //设置为循环播放
        backgroundMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        backgroundMusicPlayer.prepareToPlay()
        //播放音乐
        backgroundMusicPlayer.play()

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
