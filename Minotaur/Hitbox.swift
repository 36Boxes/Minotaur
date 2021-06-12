//
//  Hitbox.swift
//  Minotaur
//
//  Created by Josh Manik on 12/06/2021.
//

import SpriteKit

class Hitbox : SKSpriteNode {
    var image_alpha : CGFloat = 0.0
    var xOffset: CGFloat = 20.0
    var yOffset: CGFloat = -10.0
    var xHit: CGFloat = 0.0
    var yHit: CGFloat = 0.0
    var damage: CGFloat = 2.0
    var hitStun: CGFloat = 60
    var ignore = false
    var ignoreList = [Hurtbox]()
}
