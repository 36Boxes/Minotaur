//
//  DeathState.swift
//  Minotaur
//
//  Created by Josh Manik on 14/06/2021.
//
import SpriteKit
import GameplayKit

class DeathState : GKState {
    var cnode : CharacterNode?
    
    var activeTime = 0.8
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
            
        } else {
            cnode?.removeFromParent()
            activeTime = 0.8
        }
        
        self.lastUpdateTime = seconds
    }
}
