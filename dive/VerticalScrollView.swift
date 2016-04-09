import SpriteKit

class ScrollNode: SKSpriteNode {
    
    private var contentNode = SKNode()
    private var startX: CGFloat = 0.0
    private var lastX: CGFloat = 0.0
    // タッチされているかどうか
    private var touching = false
    // 少しずつ移動させる
    private var lastScrollDistX: CGFloat = 0.0
    
    init(size: CGSize) {
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        self.userInteractionEnabled = true
        
        self.contentNode.position = CGPoint(x: 3000, y: 0)
        self.addChild(self.contentNode)
        
        // スクロールさせるコンテンツ
        let myLabel = SKLabelNode(fontNamed: "Helvetica")
        myLabel.text = "scroll"
        myLabel.fontSize = 90
        self.contentNode.addChild(myLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touching = true
        // store the starting position of the touch
        let touch = touches.first
        let location = touch!.locationInNode(self)
        startX = location.x
        lastX = location.x
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        // set the new location of touch
        let currentX = location.x
        
        lastScrollDistX =  lastX - currentX
        
        self.contentNode.position.x -= lastScrollDistX
        
        // Set new last location for next time
        lastX = currentX
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touching = false
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.touching = false
    }
    
    func update(currentTime: CFTimeInterval) {
        // タッチされてなかったら
        if !touching {
            // 左と右端の設定
            let limitFactor: CGFloat = 0.3
            let leftLimitX: CGFloat = self.size.width * (-limitFactor)
            let rightLimitX: CGFloat = self.size.width * limitFactor
            if self.contentNode.position.x < leftLimitX {
                // 行き過ぎたから戻す
                self.contentNode.position.x = leftLimitX
                lastScrollDistX = 0.0
                return
            }
            if self.contentNode.position.x > rightLimitX {
                // 行き過ぎたから戻す
                self.contentNode.position.x = rightLimitX
                lastScrollDistX = 0.0
                return
            }
            
            // 慣性処理
            var slowDown: CGFloat = 0.98
            if fabs(lastScrollDistX) < 0.5 {
                slowDown = 0.0
            }
            lastScrollDistX *= slowDown
            self.contentNode.position.x -= lastScrollDistX
        }
    }
}