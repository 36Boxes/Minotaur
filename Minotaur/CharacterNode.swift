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
    
    var attack1 = false
    
    var maxjump:CGFloat = 30.0
    
    var airAccel: CGFloat = 0.1
    var airDecel: CGFloat = 0.0
    var groundAccel: CGFloat = 0.2
    var groundDecel: CGFloat = 0.5
    
    var facing: CGFloat = 1.0
    
    var hSpeed:CGFloat = 0
    
    var walkSpeed: CGFloat = 2
    
    var hurtbox: Hurtbox?
    var hitbox: Hitbox?
    
    var hit = false
    var hitStun: CGFloat = 0
    var hitBy: Hitbox?
    
    var stateMachine:GKStateMachine?
    
    func setHurtbox(size: CGSize){
        hurtbox = Hurtbox(color: .green, size: size)
        hurtbox?.position = CGPoint(x:(hurtbox?.xOffset)!, y:(hurtbox?.yOffset)!)
        hurtbox?.alpha = (hurtbox?.image_alpha)!
        hurtbox?.zPosition = 50
        self.addChild(hurtbox!)
    }
    
    func setHitbox(size: CGSize){
        hitbox = Hitbox(color: .red, size: size)
        hitbox?.position = CGPoint(x:(hitbox?.xOffset)!, y:(hitbox?.yOffset)!)
        hitbox?.alpha = (hitbox?.image_alpha)!
        hitbox?.zPosition = 50
        self.addChild(hitbox!)
    }
    
    func setupSates(){
        let normalState = NormalState(with: self)
        let attackState = AttackState(with: self)
        let damageState = DamageState(with: self)
        stateMachine = GKStateMachine(states: [normalState, attackState, damageState])
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
