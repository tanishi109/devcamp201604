import SpriteKit

class TouchableNode: SKNode {

    override init() {
        super.init()
        self.addSaintZones(self.getRandom)
    }
    
    private func addSaintZones(getRand: () -> CGFloat) {

        // なんか置いてみる
        let block = SKSpriteNode(
            color: UIColor.greenColor(),
            size: CGSizeMake(UIScreen.mainScreen().bounds.size.width, getRand())
        )


        block.alpha = 0.25
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
    
    private func getRandom() -> CGFloat {
       NSLog("called")
       return CGFloat(Int((arc4random_uniform(10)+1)*100))
    }

}