import GameplayKit
import SpriteKit

struct Catergories {
    static let PLAYER : UInt32 = 1
    static let GROUND : UInt32 = 2
}

class PhysicsDetection : NSObject, SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == Catergories.PLAYER | Catergories.GROUND {
            if let player = contact.bodyA.node as? CharacterNode{
                player.grounded = true
            } else if let player = contact.bodyB.node as? CharacterNode{
                player.grounded = true
            }
        }
    }
}
