import SpriteKit

class TouchableNode: SKNode {

    override init() {
        super.init()
        
        self.addFireNode()
        NSLog("*** init")
    }
    
    private func addFireNode() {
        // なんか置いてみる
        let block = SKSpriteNode(
            color: UIColor.greenColor(),
            size: CGSizeMake(100, 100)
        )
        
        block.alpha = 0.25
        block.name = "touchable"
        
        block.position = CGPoint(
            x:CGRectGetMidX(self.frame)-10,
            y:CGRectGetMidY(self.frame)
        )
        
        self.addChild(block)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}