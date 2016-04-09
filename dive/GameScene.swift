//
//  GameScene.swift
//  dive
//
//  Created by MasatoHayakawa on 2016/04/09.
//  Copyright (c) 2016年 MasatoHayakawa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var scrollNode: ScrollNode!
    
    override func didMoveToView(view: SKView) {
        self.scrollNode = ScrollNode(size: CGSize(width: 1500, height: 44000))
        self.addChild(scrollNode)
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        // scrollNodeのupdateメソッドを呼ぶ
        self.scrollNode.update(currentTime)
    }
    
}
