//
//  AttackState.swift
//  Minotaur
//
//  Created by Josh Manik on 12/06/2021.
//

import SpriteKit
import GameplayKit

class AttackState : GKState {
    var cnode : CharacterNode?
    
    var activeTime = 0.5
    private var lastUpdateTime : TimeInterval = 0
    
    
    init(with node: CharacterNode){
        cnode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = seconds
        }
        
        if activeTime >= 0{
            activeTime = activeTime - lastUpdateTime
            
            if (activeTime <= 0.3 && activeTime >= 0.1){
                if (cnode?.hitbox == nil){
                    cnode?.setHitbox(size: CGSize(width: 20, height: 40))
                    cnode?.hitbox?.xHit = 2.0 * cnode!.facing
                    cnode?.hitbox?.hitStun = 30
                }
                
            } else {
                if (cnode?.hitbox != nil){
                    cnode?.hitbox?.removeFromParent()
                    cnode?.hitbox = nil
                }
            }
        } else {
            cnode?.attack1 = false
            stateMachine?.enter(NormalState.self)
            activeTime = 0.4
        }
        
        self.lastUpdateTime = seconds
    }
}
