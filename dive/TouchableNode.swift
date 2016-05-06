import SpriteKit

class TouchableNode: SKNode {

    override init() {
        super.init()
        self.addSaintZones()
    }
    
    private func addSaintZones() {

        // なんか置いてみる
        let block = SKSpriteNode(
            color: UIColor.whiteColor(),
            size: CGSizeMake(getRandom(300, max: 500), getRandom(300, max: 500))
        )

        block.alpha = 0.5
        block.name = "touchable"

        block.position = CGPoint(
            x: 0,
            y: CGRectGetMidY(self.frame)
        )

        self.addChild(block)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getRandom(min: UInt32, max: UInt32) -> CGFloat {
       return CGFloat( Int(arc4random_uniform(min)) + Int(arc4random_uniform(max+1)) )
    }

}