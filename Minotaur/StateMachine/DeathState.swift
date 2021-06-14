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
    
    init(with node: CharacterNode){
        self.cnode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        }
}
