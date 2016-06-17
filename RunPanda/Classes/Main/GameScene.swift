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
    
    private lazy var scoreLabel:SKLabelNode = {
    
        let score = SKLabelNode(fontNamed: "Chalkduster")
        score.horizontalAlignmentMode = .Left
        score.position = CGPointMake(20, self.frame.size.height - 150)
        score.text = "run 0km"
        
        return score
    }()
    
    private lazy var appleLabel:SKLabelNode = {
    
        let apple = SKLabelNode(fontNamed:"Chalkduster")
        apple.horizontalAlignmentMode = .Left
        apple.position = CGPointMake(400, self.frame.size.height-150)
        apple.text = "eat: \(self.appleNum) apple"
        return apple
    }()
    
    private lazy var soundManger:SoundManager = {
    
        let manger = SoundManager()
        
        return manger
    }()
    
    
    //跑了多远变量
    private var distance :CGFloat = 0.0
    //吃了多少个苹果变量
    private var appleNum = 0

    //最大速度
    var maxSpeed :CGFloat = 50.0
    
    //移动速度
    var moveSpeed:CGFloat = 10
    
    //判断最后一个平台还有多远完全进入游戏场景
    var lastDis:CGFloat = 0.0
    
    /// 苹果的高度
    var appleY:CGFloat = 0.0
    
    /// 游戏是否结束
    var isGameOver = false
    
    
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
        
        //设置记分牌
        setUpScoreLabel()
        
        soundManger.playBackgroundMusic()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        
        if panda.status != pandaStatus.jump_effect {
            //如果处于2段跳状态则不播放起跳音效
            soundManger.playJump()
        }
        
        panda.jump()
    }
    

    override func update(currentTime: CFTimeInterval) {
       
        if !isGameOver {
            
            lastDis -= moveSpeed
            
            //速度以5为基础，以跑的距离除以2000为增量
            var tempSpeed = CGFloat(5 + Int(distance/2000))
            //将速度控制在maxSpeed
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            //如果移动速度小于新的速度就改变
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if lastDis <= 0 {
                printRALog("生成新平台")
                platformFactory.creatPlatformRamdom()
            }
            platformFactory.move(moveSpeed)
            background.move(moveSpeed/5.0)
            appleFactory.move(moveSpeed)
            
            
            distance += moveSpeed
            scoreLabel.text = "run: \(Int(distance/10*10)/10) m"
            appleLabel.text = "eat: \(appleNum) apple"

        }
    }
    
}

// MARK: - 记分牌相关
extension GameScene{

    private func setUpScoreLabel(){
    
        addChild(scoreLabel)
        addChild(appleLabel)
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
            
            appleNum += 1
            
            soundManger.playEat()
            
            //如果碰撞体A是苹果，隐藏碰撞体A，反之隐藏碰撞体B
            if contact.bodyA.categoryBitMask == BitMaskType.apple {
                contact.bodyA.node?.hidden = true
            }else{
                
                contact.bodyB.node?.hidden = true
            }
        }
        
        if (contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask) == (BitMaskType.platform|BitMaskType.panda){
            
            printRALog("碰撞平台")
            
            var isDown = false
            
            var canRun = false
            
            //碰撞平台为A
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                
                if (contact.bodyA.node as! Platform).isDown {
                 
                    isDown = false
               
                    //让平台接受重力影响
                    contact.bodyA.node?.physicsBody?.dynamic = true
                    
                    contact.bodyA.node?.physicsBody?.collisionBitMask = 0
                   
                    
                }else if (contact.bodyA.node as! Platform).isShock {
                
                    (contact.bodyA.node as! Platform).isShock = false
                    
                     downAndUp(contact.bodyA.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                    
                }
                
                if contact.bodyB.node?.position.y > contact.bodyA.node!.position.y {
                    
                    canRun=true
                }
                
            }else if contact.bodyB.categoryBitMask == BitMaskType.platform {
            
                if (contact.bodyB.node as! Platform).isDown {
                    
                    contact.bodyB.node?.physicsBody?.dynamic = true
                    
                    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
                    
                    isDown = true
                    
                }else if (contact.bodyB.node as! Platform).isShock {
                    
                    (contact.bodyB.node as! Platform).isShock = false
                    
                    downAndUp(contact.bodyB.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                
                if contact.bodyA.node?.position.y > contact.bodyB.node?.position.y {
                    
                    canRun=true
                    
                }

            }
            
            
            
            //判断是否打滚
            panda.jumpEnd = panda.position.y
            if panda.jumpEnd-panda.jumpStart <= -70 {
                
                soundManger.playRoll()
                panda.roll()
                //如果平台下沉就不让它被震得颤抖一下
                if !isDown {
                    downAndUp(contact.bodyA.node!)
                    downAndUp(contact.bodyB.node!)
                }
            }else{
                
                if canRun {
                    panda.run()
                }
            }
        }
        
        
        if (contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            printRALog("游戏结束")
            
            isGameOver = true
            
            soundManger.playDead()
            

            let alert = UIAlertView(title: "游戏结束", message: "GameOver", delegate: self, cancelButtonTitle: "确认")
            
            alert.show()
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
    
    //重新开始游戏
   private func reSet(){
        //重置isLose变量
        isGameOver = false
        //重置熊猫位置
        panda.position = CGPointMake(200, 400)
        //重置移动速度
        moveSpeed  = 15.0
        //重置跑的距离
        distance = 0.0
        //重置首个平台完全进入游戏场景的距离
        lastDis = 0.0
        //重置吃了苹果的数量
        self.appleNum = 0
        //平台工厂的重置方法
        platformFactory.reSet()
        //苹果工厂的重置方法
        appleFactory.reSet()
        //创建一个初始的平台给熊猫一个立足之地
        platformFactory.creatPlatform(3, x: 0, y: 200)
    }


}

extension GameScene : UIAlertViewDelegate{

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        reSet()
    }
}
