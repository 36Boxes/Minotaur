//
//  NormalState.swift
//  Minotaur
//
//  Created by Josh Manik on 10/06/2021.
//

import GameplayKit

class NormalState: GKState{
    
    var cNode: CharacterNode
    
    init(with node: CharacterNode){
            cNode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        var aSpeed: CGFloat = 0
        var dSpeed: CGFloat = 0
        
        if cNode.grounded{
            aSpeed = cNode.groundAccel
            dSpeed = cNode.groundDecel
        } else {
            aSpeed = cNode.airAccel
            dSpeed = cNode.airDecel
        }
        
        if cNode.left {
            cNode.xScale = abs(cNode.xScale) * cNode.facing
            cNode.hSpeed = approach(start: cNode.hSpeed, end: -cNode.walkSpeed, shift: aSpeed)
        } else if cNode.right {
            cNode.xScale = abs(cNode.xScale) * cNode.facing
            cNode.hSpeed = approach(start: cNode.hSpeed, end: cNode.walkSpeed, shift: aSpeed)
        }else{
            cNode.hSpeed = approach(start: cNode.hSpeed, end: 0.0, shift: dSpeed)
        }
        
        if cNode.grounded{
            if !cNode.landed{
                cNode.physicsBody?.velocity = CGVector(dx: (cNode.physicsBody?.velocity.dx)!, dy: 0.0)
                cNode.landed = true
            }
            if cNode.jump{
                cNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: cNode.maxjump))
                cNode.grounded = false
            }
        }
        
        if !cNode.grounded{
            if (cNode.physicsBody?.velocity.dy)! < CGFloat(0.0){
                cNode.jump = false
            }
            if (cNode.physicsBody?.velocity.dy)! > CGFloat(0.0) && !cNode.jump{
                cNode.physicsBody?.velocity.dy *= 0.5
            }
            cNode.landed = false
        }
        
        
        cNode.position.x = cNode.position.x + cNode.hSpeed
    }
    
    func approach(start:CGFloat, end:CGFloat, shift:CGFloat) -> CGFloat{
        
        if (start < end){
            return min(start + shift, end)
        } else {
            return max(start - shift, end)
        }
        
    }
    
    func squashAndStretch(xscale: CGFloat, yscale: CGFloat){
        cNode.xScale = xscale * cNode.facing
        cNode.yScale = yscale
    }
}
