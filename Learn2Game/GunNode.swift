import SpriteKit

class GunNode: SKSpriteNode {
    
    class func gun () -> GunNode {
        let gun = SKSpriteNode(imageNamed: "gun")
        gun.size = CGSize(width: 44, height: 44)
        gun.color = UIColor.orangeColor()

        return gun as GunNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
