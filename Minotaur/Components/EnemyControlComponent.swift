//
//  EnemyControlComponent.swift
//  Minotaur
//
//  Created by Josh Manik on 12/06/2021.
//

import SpriteKit
import GameplayKit

class EnemyControlComponent : GKComponent {
    
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

        else{
            cnode?.stateMachine?.update(deltaTime: seconds)
        }
        
    }
    
    override class var supportsSecureCoding: Bool { true }
}
