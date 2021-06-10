//
//  ControllerNodes.swift
//  Minotaur
//
//  Created by Josh Manik on 10/06/2021.
//

import SpriteKit

class TouchControlsInputNodes: SKSpriteNode {
    
    var alphaUnpressed: CGFloat = 0.5
    var alphaPressed: CGFloat = 0.9
    
    var pressedButtons = [SKSpriteNode]()
    
    let UpButton = SKSpriteNode(imageNamed: "Up")
    let DownButton = SKSpriteNode(imageNamed: "Down")
    let LeftButton = SKSpriteNode(imageNamed: "Left")
    let RightButton = SKSpriteNode(imageNamed: "Right")
    
    let buttonA = SKSpriteNode(imageNamed: "AButton")
    let buttonB = SKSpriteNode(imageNamed: "BButton")
    let buttonX = SKSpriteNode(imageNamed: "XButton")
    let buttonY = SKSpriteNode(imageNamed: "YButton")
    
    
    
    var inputDelegate : ControlInputDelegate?
    
    init(frame: CGRect){
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        setupControls(size: frame.size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupControls(size:CGSize){
        
        addButton(button: UpButton, position: CGPoint(x: -(size.width)/3, y: (-size.height)/5 + 50), name: "up", scale: 1)
        addButton(button: LeftButton, position: CGPoint(x: -(size.width/3) - 50, y: (-size.height)/5), name: "left", scale: 1)
        addButton(button: DownButton, position: CGPoint(x: -(size.width)/3, y: (-size.height)/5 - 50), name: "down", scale: 1)
        addButton(button: RightButton, position: CGPoint(x: -(size.width/3) + 50, y: (-size.height)/5), name: "right", scale: 1)
        
        addButton(button: buttonX, position: CGPoint(x: (size.width)/3, y: (-size.height)/5 + 50), name: "x", scale: 1)
        addButton(button: buttonY, position: CGPoint(x: (size.width/3) - 50, y: (-size.height)/5), name: "y", scale: 1)
        addButton(button: buttonB, position: CGPoint(x: (size.width)/3, y: (-size.height)/5 - 50), name: "b", scale: 1)
        addButton(button: buttonA, position: CGPoint(x: (size.width/3) + 50, y: (-size.height)/5), name: "a", scale: 1)
        
    }
    
    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat){
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 100
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: parent!)
            
            for button in [UpButton, DownButton, LeftButton, RightButton, buttonX, buttonY, buttonA, buttonB]{
                
                if button.contains(location) && pressedButtons.firstIndex(of:button) == nil{
                    pressedButtons.append(button)
                    if (inputDelegate != nil){
                        inputDelegate?.follow(command: button.name)
                    }
                }
                
                if(pressedButtons.firstIndex(of: button) != nil){
                    button.alpha = alphaPressed
                }else{
                    button.alpha = alphaUnpressed
                }
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            
            let location = t.location(in: parent!)
            let previouslocation = t.previousLocation(in: parent!)
            
            for button in [UpButton, DownButton, LeftButton, RightButton, buttonX, buttonY, buttonA, buttonB]{
                
                if button.contains(previouslocation) && !button.contains(location){
                    let index = pressedButtons.firstIndex(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        if (inputDelegate != nil){
                            inputDelegate?.follow(command: "cancel \(String(button.name!))")
                        }
                    }
                }
                else if  !button.contains(previouslocation) && button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                    pressedButtons.append(button)
                    if (inputDelegate != nil){
                        inputDelegate?.follow(command: button.name!)
                    }
                }
                if(pressedButtons.firstIndex(of: button) != nil){
                    button.alpha = alphaPressed
                } else {
                    button.alpha = alphaUnpressed
                }
                
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches: touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches: touches, withEvent: event)
    }
    
    func touchUp(touches: Set<UITouch>?, withEvent event: UIEvent?){
        for t in touches!{
            let location = t.location(in: parent!)
            let prevL = t.previousLocation(in: parent!)
            
            for button in  [UpButton, DownButton, LeftButton, RightButton, buttonX, buttonY, buttonA, buttonB]{
                if button.contains(location) || button.contains(prevL) {
                    let index = pressedButtons.firstIndex(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        if inputDelegate != nil {
                            inputDelegate?.follow(command: "stop \(String(button.name!))")
                        }
                    }
                }
                if(pressedButtons.firstIndex(of: button) != nil){
                    button.alpha = alphaPressed
                } else {
                    button.alpha = alphaUnpressed
                }
            }
        }
    }
    

    
}
