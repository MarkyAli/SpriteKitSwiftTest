import SpriteKit

class GameScene: SKScene {
    var lastCurrentTime: NSTimeInterval?
    var lastFireTime: NSTimeInterval?
    weak var touch: UITouch?
    var gunAngle: CGFloat = 0.0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let gun = SKSpriteNode(imageNamed: "gun")
        gun.name = "gun"
        gun.size = CGSize(width: 44, height: 44)
        gun.position = CGPoint(x: (size.width - gun.size.width) / 2, y: 0)
        
        self.addChild(gun)
    }
 
    override func update(currentTime: NSTimeInterval) {
        
        if let lastCurrentTime = self.lastCurrentTime {
            let timeDiff = currentTime - lastCurrentTime
        } else {
            let timeDiff = 0
        }
        
        self.handleTouch()
        
        let rnd = arc4random_uniform(100)
        
        if let touch = self.touch {
            if let lastFireTime = self.lastFireTime {
                if currentTime - 0.3 > lastFireTime {
                    self.lastFireTime = currentTime
                    self.fire()
                }
            } else {
                self.lastFireTime = currentTime
            }
        }
            
        if rnd < 2 {
            self.addObstacle()
        }
        
        self.handleColisions()
        
        self.lastCurrentTime = currentTime
    }
    
    func handleColisions () {
        self.enumerateChildNodesWithName("asteroid", usingBlock: { (asteroid, stopAsteroid) -> Void in
            self.enumerateChildNodesWithName("photon", usingBlock: { (photon, stopPhoton) -> Void in
                if asteroid.intersectsNode(photon) {
                    asteroid.removeFromParent()
                }
            })
        })
    }
    
    func handleTouch () {
        if let touch = self.touch {
            let touchPoint = touch.locationInNode(self)
            let gun = self.childNodeWithName("gun")
            let gunPoint = gun!.position
            
            let c = touchPoint.y - gunPoint.y
            let b = gunPoint.x - touchPoint.x
            self.gunAngle = atan(b / c)
            
            let gunRotation = SKAction.rotateToAngle(self.gunAngle, duration: 0.3)
            gun?.runAction(gunRotation)
        }
    }
    
    func fire () {
        let gun = self.childNodeWithName("gun")
        let shot = SKSpriteNode(imageNamed: "photon")
        shot.name = "photon"
        shot.size = CGSize(width: 10, height: 10)
        shot.position = gun!.position
        
        let x = -(1000 * self.gunAngle) + gun!.position.x
        let y = 1000
        
        let destination = CGPoint(x: x, y: 1000)
        let move = SKAction.moveTo(destination, duration: 2)
        
        self.addChild(shot)
        shot.runAction(move)
    }
    
    func addObstacle () {
        let obstacle = SKSpriteNode(imageNamed: "asteroid")
        obstacle.name = "asteroid"
        let size = 30 + CGFloat(arc4random_uniform(30))
        obstacle.size = CGSize(width: size, height: size)
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        obstacle.physicsBody?.affectedByGravity = true
        obstacle.physicsBody?.dynamic = true
        obstacle.physicsBody?.density = CGFloat(size * 100)
        let maxX = self.size.width - obstacle.size.width
        let x = CGFloat(arc4random_uniform(UInt32(maxX)))
        let y = CGFloat(arc4random_uniform(100))
        obstacle.position = CGPoint(x: x, y: (self.size.height + y))
        
        self.addChild(obstacle)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.touch = touches.anyObject() as? UITouch
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
