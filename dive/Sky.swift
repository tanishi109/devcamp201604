import SpriteKit

class Sky: SKSpriteNode {
    
    var gameScene: SKScene!
    func setScene(scene: SKScene) {
        self.gameScene = scene
    }
    
    required init() {
        super.init(texture: nil, color: UIColor.blueColor(), size: CGSizeMake(80, 20))
        
        self.position = CGPointMake(400, 500)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        
    }
}