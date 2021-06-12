//
//  AttackComponent.swift
//  Minotaur
//
//  Created by Josh Manik on 12/06/2021.
//

import SpriteKit
import GameplayKit

class AttackComponent : GKComponent {
    var cnode : CharacterNode?
    
    override func update(deltaTime seconds: TimeInterval) {
        if (cnode == nil){
            if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self){
                cnode = nodeComponent.node as? CharacterNode
                cnode?.setupSates()
                cnode?.setHurtbox(size: CGSize(width: 20.0, height: 35))
                if let parentScene = cnode?.parent as? GameScene {
                    parentScene.enemies.append(cnode!)
                }
            }
        }
        
        if cnode?.stateMachine?.currentState is AttackState {
            if cnode?.hitbox != nil {
                if let scene = cnode?.parent as! GameScene? {
                    for enemy in scene.enemies {
                        if (cnode?.hitbox?.intersects((enemy.hurtbox)!))! {
                            if !(cnode?.hitbox?.ignoreList.contains((enemy.hurtbox)!))!{
                                cnode?.hitbox?.ignoreList.append((enemy.hurtbox)!)
                                enemy.hitBy = cnode?.hitbox
                                enemy.hit = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override class var supportsSecureCoding: Bool { true }
}
