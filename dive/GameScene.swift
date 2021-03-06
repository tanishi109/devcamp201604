//
//  GameScene.swift
//  dive
//
//  Created by MasatoHayakawa on 2016/04/09.
//  Copyright (c) 2016年 MasatoHayakawa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var touchableNode = [TouchableNode]()

    private var startY: CGFloat = 0.0
    private var lastY: CGFloat = 0.0
    // タッチされているかどうか
    private var touching = false
    private var touchingBg = false
    // 少しずつ移動させる
    private var lastScrollDistY: CGFloat = 0.0
    // 動かせるやつ
    private var saintZone = TouchableNode()
    
    // スコア
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()

    // ゲームオーバー
    var timerLabelNode:SKLabelNode!
    var timer = NSInteger()
    var canRestart = Bool()
    var GameTimer = NSTimer()
    
    override func didMoveToView(view: SKView) {

        self.saintZone = TouchableNode()

        // 踏めるところ
        self.saintZone.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame)
        )

        self.addChild(self.saintZone)

        // スコア
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.fontColor = UIColor.blackColor()
        scoreLabelNode.alpha = 0.4
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)

        // 時間
        timer = 5
        timerLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        timerLabelNode.fontColor = UIColor.blueColor()
        timerLabelNode.alpha = 0.4
        timerLabelNode.position = CGPoint( x: 312 + 32, y: self.frame.height - 64 )
        timerLabelNode.zPosition = 100
        timerLabelNode.text = String(timer)
        self.addChild(timerLabelNode)

        GameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
        
        let sky = Sky()
        sky.setScene(self)
        self.addChild(sky)
    }

    // タッチ開始
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            if (touchNode.name == "touchable") {
                // タッチ座標
                self.touching = true
                let touch = touches.first
                let location = touch!.locationInNode(self)
                startY = location.y
                lastY = location.y

                // タッチ済みにする
                if touchNode.alpha != 1.0 {
                    touchNode.alpha = 1.0
                }
            } else {
                self.touchingBg = true
            }
        }

        // restartできる
        if canRestart {
            self.resetScene()
        }

    }

    // タッチ移動中
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // SaintZoneのタッチ中かどうか調べる
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (self.saintZone.containsPoint(location) && self.touchingBg == false) {
                let touch = touches.first
                let location = touch!.locationInNode(self)
                let currentY = location.y
                lastScrollDistY =  lastY - currentY
                self.saintZone.position.y -= lastScrollDistY
                lastY = currentY
            }

            if (self.saintZone.containsPoint(location)) {
                // タッチ済みにする
                if self.saintZone.children[0].alpha != 1.0 {
                    self.saintZone.children[0].alpha = 1.0
                }
            }

        }
    }

    // タッチ終わり
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touching = false
        self.touchingBg = false
    }
    
    // タッチキャンセル
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.touching = false
    }

    // 毎フレームの処理
    override func update(currentTime: CFTimeInterval) {

        // 十分画面外に出た
        let topSaintZone    = self.saintZone.children[0]
        let topSaintZonePos = self.convertPoint(topSaintZone.position, fromNode: self.saintZone)
        let height = topSaintZone.calculateAccumulatedFrame().size.height

        if topSaintZonePos.y > self.size.height + height / 2 + 0 {

            // 下から出てくるようにする
            // self.saintZone.position.y = 0 - height

            
            self.saintZone.removeAllChildren()
            self.saintZone = TouchableNode()
            let x = CGFloat( Int(arc4random_uniform(UInt32(0 + 256))) + Int(arc4random_uniform(UInt32(self.size.width - 256))) )
            

            NSLog("\(self.saintZone)")
//            self.saintZone.anchorPoint = CGPointMake(1.0, 1.0);
            self.saintZone.position = CGPoint(
//                x: CGRectGetMidX(self.frame),
                x: x,
                y: 10
            )
            NSLog("\(x)")
            self.addChild(self.saintZone)

            // スコア加算
            if (topSaintZone.alpha == 1.0) {
                score += 1
                scoreLabelNode.text = String(score)
                // スコアアニメーション
                scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
            }

            // 透過に戻す
            topSaintZone.alpha = 0.25

        }

        // タッチされてなかったら
        if !touching {
            // 上と下端の設定
            let limitFactor: CGFloat = 0.3
            let topLimitY: CGFloat = 0 * (-limitFactor)
            if self.saintZone.position.y < topLimitY - height {
                // 行き過ぎたから戻す
                self.saintZone.position.y = topLimitY
                lastScrollDistY = 0.0
                return
            }
            
            // 慣性処理
            var slowDown: CGFloat = 0.98
            if fabs(lastScrollDistY) < 0.5 {
                slowDown = 0.0
            }
            lastScrollDistY *= slowDown
            self.saintZone.position.y -= lastScrollDistY
        }

        // 毎時スクロール
        self.saintZone.position.y += 1
    }
    
    
    func countDown () {
        NSLog("count down")
        timer -= 1
        timerLabelNode.text = String(timer)
        if timer == 0 {
            self.canRestart = true
            self.speed = 0
            GameTimer.invalidate()

//            self.saintZone.removeFromParent()

        }
    }

    func resetScene () {
        // Move bird to original position and reset velocity
//        self.saintZone.removeAllChildren()
        self.saintZone.removeFromParent()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)

        timer = 5
        timerLabelNode.text = String(timer)

        GameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)

        self.saintZone.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame)
        )
        
        self.addChild(self.saintZone)
    }

}

