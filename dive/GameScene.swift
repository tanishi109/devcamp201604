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

    override func didMoveToView(view: SKView) {

        // 緑
        self.saintZone.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame)
        )

        self.addChild(self.saintZone)

        // スコア
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
    }

    // タッチ開始
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            if (touchNode.name == "touchable") {
                self.touching = true
                let touch = touches.first
                let location = touch!.locationInNode(self)
                startY = location.y
                lastY = location.y
            } else {
                self.touchingBg = true
            }
        }

    }
    
    // タッチ移動中
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("\(self.touchingBg)")
        // Declare the touched symbol and its location on the screen
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (self.saintZone.containsPoint(location) && self.touchingBg == false) {
                NSLog("*** hogehogehoge")
                let touch = touches.first
                let location = touch!.locationInNode(self)
                let currentY = location.y
                lastScrollDistY =  lastY - currentY
                self.saintZone.position.y -= lastScrollDistY
                
                lastY = currentY
            }
        }
    }

    // タッチ終わり
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("ENDENDENDENDENDENDEND")
        self.touching = false
        self.touchingBg = false
    }
    
    // タッチキャンセル
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.touching = false
    }

    // 毎秒処理
    override func update(currentTime: CFTimeInterval) {
        // タッチされてなかったら
        if !touching {
            // 上と下端の設定
            let limitFactor: CGFloat = 0.3
            let topLimitY: CGFloat = 0 * (-limitFactor)
            if self.saintZone.position.y < topLimitY {
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

        // 高さがある程度行ったら
        let topSaintZone    = self.saintZone.children[0]
        let topSaintZonePos = self.convertPoint(topSaintZone.position, fromNode: self.saintZone)
        let height = topSaintZone.calculateAccumulatedFrame().size.height

        if topSaintZonePos.y > self.size.height + height / 2 + 100 {
            self.saintZone.position.y = 0
            score += 1
            scoreLabelNode.text = String(score)
            
            // Add a little visual feedback for the score increment
            scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
        }
    }

}

