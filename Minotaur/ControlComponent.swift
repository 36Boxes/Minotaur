//
//  ControlComponent.swift
//  Minotaur
//
//  Created by Josh Manik on 10/06/2021.
//

import SpriteKit
import GameplayKit

class PlayerControlComponent : GKComponent, ControlInputDelegate {
    
    var touchControlNode: TouchControlsInputNodes?
    var characterControlNode: CharacterNode?
    
    func setupControls(camera: SKCameraNode, scene: SKScene){
        touchControlNode = TouchControlsInputNodes(frame: scene.frame)
        touchControlNode?.inputDelegate = self
        touchControlNode?.position = CGPoint.zero
        
        camera.addChild(touchControlNode!)
        
        if (characterControlNode == nil){
            if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self){
                characterControlNode = nodeComponent.node as? CharacterNode
            }
        }
    }
    
    
    
    func follow(command: String?) {
        if characterControlNode != nil{
            switch (command!) {
            case ("left"):
                characterControlNode?.facing = -1.0
                characterControlNode?.left = true
            case"cancel left", "stop left":
                characterControlNode?.left = false
            case "right":
                characterControlNode?.facing = 1.0
                characterControlNode?.right = true
            case "cancel right", "stop right":
                characterControlNode?.right = false
            case "a":
                characterControlNode?.jump = true
            case "cancel a", "stop a":
                characterControlNode?.jump = false
                
            default:
                print("command: \(String(command!))")
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        characterControlNode?.stateMachine?.update(deltaTime: seconds)
    }
}
