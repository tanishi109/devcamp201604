//
//  GameScene.swift
//  dive
//
//  Created by MasatoHayakawa on 2016/04/09.
//  Copyright (c) 2016年 MasatoHayakawa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touchableNode = [TouchableNode]()

    private var startY: CGFloat = 0.0
    private var lastY: CGFloat = 0.0
    // タッチされているかどうか
    private var touching = false
    // 少しずつ移動させる
    private var lastScrollDistY: CGFloat = 0.0
    // 動かせるやつ
    private var saintZone = TouchableNode()
    
    override func didMoveToView(view: SKView) {

        // なんか置いてみる
        self.saintZone.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame)
        )

        self.addChild(self.saintZone)
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
            }
        }

    }
    
    // タッチ移動中
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Declare the touched symbol and its location on the screen
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (self.saintZone.containsPoint(location)) {
                let touch = touches.first
                let location = touch!.locationInNode(self)
                let currentY = location.y
                lastScrollDistY =  lastY - currentY
                self.saintZone.position.y -= lastScrollDistY
//                self.saintZone.position.y = currentY // 試し
                
                lastY = currentY

            }
        }
    }

    // タッチ終わり
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touching = false
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
//            let limitFactor: CGFloat = 0.3
//            let topLimitY: CGFloat = 0 * (-limitFactor)
//            let bottomLimitY: CGFloat = self.size.height * limitFactor
//            if self.saintZone.position.y < topLimitY {
//                // 行き過ぎたから戻す
//                self.saintZone.position.y = topLimitY
//                lastScrollDistY = 0.0
//                return
//            }
//            if self.saintZone.position.y > bottomLimitY {
//                // 行き過ぎたから戻す
//                self.saintZone.position.y = bottomLimitY
//                lastScrollDistY = 0.0
//                return
//            }
            
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
        
        if topSaintZonePos.y > self.size.height {

            NSLog("*****")
            self.saintZone.removeAllChildren()
            self.saintZone = TouchableNode()
            self.saintZone.position = CGPoint(
                x:CGRectGetMidX(self.frame),
                y:CGRectGetMidY(self.frame)
            )
            self.addChild(self.saintZone)

            
//            self.saintZone.removeChildrenInArray([topSaintZone])
//            NSLog("\(self.saintZone.children.count)")
//
//            let block = SKSpriteNode(
//                color: UIColor.greenColor(),
//                size: CGSizeMake(UIScreen.mainScreen().bounds.size.width, 300)
//            )
//
//            block.alpha = 0.25
//            block.name = "touchable"
//
//            block.position = CGPoint(
//                x: 0,
//                y: 0
//            )
//
//            self.saintZone.addChild(block)
//
//            NSLog("\(self.saintZone.children.count)")
//            NSLog("\(self.saintZone.children)")
//            NSLog("***\n\n\n\n")

        }

    }
}

