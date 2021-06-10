//
//  CharacterNode.swift
//  Minotaur
//
//  Created by Josh Manik on 10/06/2021.
//

import GameplayKit
import SpriteKit

class CharacterNode: SKSpriteNode{
    
    var left = false
    var right = false
    
    var jump = false
    var landed = false
    var grounded = false
    
    var maxjump:CGFloat = 30.0
    
    var airAccel: CGFloat = 0.1
    var airDecel: CGFloat = 0.0
    var groundAccel: CGFloat = 0.2
    var groundDecel: CGFloat = 0.5
    
    var facing: CGFloat = 1.0
    
    var hSpeed:CGFloat = 0
    
    var walkSpeed: CGFloat = 2
    
    var stateMachine:GKStateMachine?
    
    func setupSates(){
        let normalState = NormalState(with: self)
        stateMachine = GKStateMachine(states: [normalState])
        stateMachine!.enter(NormalState.self)
    }
    
    func createPhysics(){
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 40), center: CGPoint(x: 0, y: 3))
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.categoryBitMask = Catergories.PLAYER
        physicsBody?.collisionBitMask = Catergories.GROUND
    }
}
