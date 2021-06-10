//
//  AnimationComponent.swift
//  Minotaur
//
//  Created by Josh Manik on 10/06/2021.
//

import SpriteKit
import GameplayKit

class AnimationComponent : GKComponent {
    
    var cnode : CharacterNode?
    
    var idleAnimation: SKAction?
    var walkAnimation: SKAction?
    var jumpAnimation: SKAction?
    var attackAnimation: SKAction?
    
    override init(){
        super.init()
        idleAnimation = SKAction(named: "Idle")
        walkAnimation = SKAction(named: "Run")
        jumpAnimation = SKAction(named: "Jump")
        attackAnimation = SKAction(named: "Attack1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        idleAnimation = SKAction(named: "Idle")
        walkAnimation = SKAction(named: "Run")
        jumpAnimation = SKAction(named: "Jump")
        attackAnimation = SKAction(named: "Attack1")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if cnode == nil{
            if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self){
                cnode = nodeComponent.node as? CharacterNode
            }
        }
        
        if cnode?.stateMachine?.currentState is NormalState {
            if (cnode?.grounded)!{
                if (cnode?.left)! || (cnode?.right)!{
                    if (cnode?.action(forKey: "walk") == nil){
                        cnode?.removeAllActions()
                        cnode?.run(walkAnimation!, withKey: "walk")
                    }
                } else{
                if (cnode?.action(forKey: "idle") == nil){
                    cnode?.removeAllActions()
                    cnode?.run(idleAnimation!, withKey: "idle")
                }
                }
            }else{
                
                if (cnode?.physicsBody?.velocity.dy)! > 20.0 {
                    if cnode?.action(forKey: "jumpup") == nil{
                        cnode?.removeAllActions()
                        cnode?.run(jumpAnimation!, withKey: "jumpup")
                    }
                }else if (cnode?.physicsBody?.velocity.dy)! < 20.0 {
                    if cnode?.action(forKey: "jumpup") == nil{
                        cnode?.removeAllActions()
                        cnode?.run(jumpAnimation!, withKey: "jumpup")
                    }
                }
            }
        }
    }

}
