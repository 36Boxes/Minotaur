//
//  GameScene.swift
//  Minotaur
//
//  Created by Josh Manik on 10/06/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var background = SKSpriteNode(imageNamed: "SkyWithClouds")
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var physicsDelegate = PhysicsDetection()
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = physicsDelegate
        
        if let thePlayer = childNode(withName: "player"){
            let entity = GKEntity()
            entity.addComponent(PlayerControlComponent())
            entity.addComponent(GKSKNodeComponent(node: thePlayer))
            entities.append(entity)
            (thePlayer as! CharacterNode).setupSates()
            if let plComponent = thePlayer.entity?.component(ofType: PlayerControlComponent.self){
                plComponent.setupControls(camera: camera!, scene: self)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0){
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        
        for entity in self.entities{
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    }

