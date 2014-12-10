import SpriteKit

class GameScene: SKScene {
    weak var shipTouch: UITouch?
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        
        let ship = SKSpriteNode(imageNamed: "ship.png")
        ship.name = "ship"
        ship.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ship.size = CGSize(width: 40, height: 40)
        
        self.addChild(ship)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.shipTouch = touches.anyObject() as UITouch?
    }
    
    override func update(currentTime: NSTimeInterval) {
        if let shipTouch = self.shipTouch {
            if let ship = self.childNodeWithName("ship") {
                ship.position = shipTouch.locationInNode(self)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
