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
    
    
    override func didMoveToView(view: SKView) {

        // なんか置いてみる
        let touchableNode = TouchableNode()
        touchableNode.position = CGPoint(
            x:CGRectGetMidX(self.frame),
            y:CGRectGetMidY(self.frame)
        )
        self.addChild(touchableNode)
    }
    
    override func update(currentTime: CFTimeInterval) {

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touching = true
        // store the starting position of the touch
        let touch = touches.first
        let location = touch!.locationInNode(self)
        startY = location.y
        lastY = location.y
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Declare the touched symbol and its location on the screen
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            if (touchNode.name == "touchable") {
                let touch = touches.first
                let location = touch!.locationInNode(self)
                let currentY = location.y
                lastScrollDistY =  lastY - currentY
                touchNode.position.y -= lastScrollDistY
                // Set new last location for next time
                lastY = currentY

            }
        }
    }
}

