//
//  DamageState.swift
//  Minotaur
//
//  Created by Josh Manik on 12/06/2021.
//

import SpriteKit
import GameplayKit

class DamageState : GKState {
    var cnode : CharacterNode?
    
    init(with node: CharacterNode){
        self.cnode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        cnode?.hSpeed = approach(start: cnode!.hSpeed, end: 0, shift: 0.1)
        cnode?.hitStun = cnode!.hitStun - 1
        
        if cnode?.hurtbox?.life == 0.0{
            print("DEAD")
        }
        
        if (cnode?.hitStun)! <= 0 {
            if cnode?.name == "Enemy"{
                cnode?.hurtbox?.life -= 1
            }
            cnode?.hSpeed = 0
            cnode?.physicsBody?.velocity.dx = 0.0
            self.stateMachine?.enter(NormalState.self)
        }
        
        cnode?.position.x = (cnode?.position.x)! + (cnode?.hSpeed)!
        
        cnode?.hurtbox?.position = CGPoint(x: (cnode?.hurtbox?.xOffset)!, y: (cnode?.hurtbox?.yOffset)!)
        
        
        
        
        
        
    }
    
    func approach(start:CGFloat, end:CGFloat, shift:CGFloat) -> CGFloat{
        
        if (start < end){
            return min(start + shift, end)
        } else {
            return max(start - shift, end)
        }
        
    }
}
