//
//  GameScene.swift
//  dive
//
//  Created by MasatoHayakawa on 2016/04/09.
//  Copyright (c) 2016年 MasatoHayakawa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // var scrollNode: ScrollNode!
    
    override func didMoveToView(view: SKView) {
        // self.scrollNode = ScrollNode(size: CGSize(width: 1500, height: 44000))
        // self.addChild(scrollNode)
        

        // なんか置いてみる
        let block = SKSpriteNode(
            color: UIColor.greenColor(),
            size: CGSizeMake(100, 100)
        )

        block.alpha = 0.25

        block.position = CGPoint(
            x:CGRectGetMidX(self.frame),
            y:CGRectGetMidY(self.frame)
        )

        self.addChild(block)
        
    }
    
    
//    override func update(currentTime: CFTimeInterval) {
//        // scrollNodeのupdateメソッドを呼ぶ
//        self.scrollNode.update(currentTime)
//    }
    
}
