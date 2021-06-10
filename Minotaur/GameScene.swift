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
    var player: CharacterNode?
    
    var parallaxComponentSystem: GKComponentSystem<ParallaxComponent>?
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = physicsDelegate
        
        parallaxComponentSystem = GKComponentSystem.init(componentClass: ParallaxComponent.self)
        
        for entity in self.entities{
            parallaxComponentSystem?.addComponent(foundIn: entity)
        }
        
        for component in (parallaxComponentSystem?.components)!{
            component.prepareWith(camera: camera)
        }
        if let thePlayer = childNode(withName: "player"){
            let entity = GKEntity()
            entity.addComponent(PlayerControlComponent())
            entity.addComponent(AnimationComponent())
            entity.addComponent(GKSKNodeComponent(node: thePlayer))
            entities.append(entity)
            player = thePlayer as? CharacterNode
            if player != nil {
                player?.createPhysics()
                player?.setupSates()
            }

            if let plComponent = thePlayer.entity?.component(ofType: PlayerControlComponent.self){
                plComponent.setupControls(camera: camera!, scene: self)
            }
        }
        
        if let tilemap = childNode(withName: "ForegroundMap") as? SKTileMapNode{
            giveTileMapPhysicsBody(map: tilemap)
        }
    }
    
    func centerOnNode(node: SKNode){
        self.camera!.run(SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y), duration: 0.5))
    }
    
    override func didFinishUpdate() {
        centerOnNode(node: player!)
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0){
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        
        for entity in self.entities{
            entity.update(deltaTime: dt)
        }
        
        parallaxComponentSystem?.update(deltaTime: currentTime)
        
        self.lastUpdateTime = currentTime
    }
    
    func createGrounds(){
        
        for i in 0...3 {
            
            let ground = SKSpriteNode(imageNamed: "GrassFloor")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 30)
            
            self.addChild(ground)
            
            let tree = SKSpriteNode(imageNamed: "TreeWithoutPath")
            tree.name = "Tree"
            tree.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            tree.anchorPoint = CGPoint(x:0.5, y:0.5)
            tree.zPosition = 10
            tree.position = CGPoint(x: CGFloat(i) * tree.size.width, y: frame.maxY/3 + 140)
            self.addChild(tree)
            
            let sky = SKSpriteNode(imageNamed: "SkyWithClouds")
            sky.name = "Sky"
            sky.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            sky.anchorPoint = CGPoint(x:0.5, y:0.5)
            sky.zPosition = 1
            sky.position = CGPoint(x: CGFloat(i) * ground.size.width, y: frame.maxY/3 + 150)
            
            self.addChild(sky)
            
            let hill = SKSpriteNode(imageNamed: "BackgroundMountains")
            hill.name = "Hills"
            hill.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            hill.anchorPoint = CGPoint(x:0.5, y:0.5)
            hill.zPosition = 2
            hill.position = CGPoint(x: CGFloat(i) * ground.size.width, y: frame.maxY/3 + 150)
            
            self.addChild(hill)
        }
    }
    
    func moveGroundLeft(){
        
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            
            node.position.x += 1.5
            
            if node.position.x > ((self.scene?.size.width)!){
                node.position.x -= (self.scene?.size.width)! * 3
            }
        }))
        self.enumerateChildNodes(withName: "Tree", using: ({
            (node, error) in
            
            node.position.x += 1.5
            
            if node.position.x > ((self.scene?.size.width)!){
                node.position.x -= (self.scene?.size.width)! * 3
            }
        }))
        self.enumerateChildNodes(withName: "Hills", using: ({
            (node, error) in
            
            node.position.x += 0.5
            
            if node.position.x > ((self.scene?.size.width)!){
                node.position.x -= (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func moveSky(){
        self.enumerateChildNodes(withName: "Sky", using: ({
            (node, error) in
            
            node.position.x -= 0.25
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func moveGroundRight(){
        
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            
            node.position.x -= 1.5
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
        
        self.enumerateChildNodes(withName: "Tree", using: ({
            (node, error) in
            
            node.position.x -= 1.5
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
        
        
        self.enumerateChildNodes(withName: "Hills", using: ({
            (node, error) in
            
            node.position.x -= 0.5
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
        
        self.enumerateChildNodes(withName: "Enemy", using: ({
            (node, error) in
            
            node.position.x -= 0.5
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func giveTileMapPhysicsBody(map: SKTileMapNode){
        
        let tileMap = map
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns{
            for row in 0..<tileMap.numberOfRows{
                if let tileDefinitiion = tileMap.tileDefinition(atColumn: col, row: row){
                    let isEdgeTile = tileDefinitiion.userData?["AddBody"] as? Int
                    if (isEdgeTile != 0){
                        let tileArray = tileDefinitiion.textures
                        let tileTexture = tileArray[0]
                        let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                        _ = CGRect(x:0,y:0, width: tileSize.width, height: tileSize.height)
                        let tileNode = SKNode()
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                        tileNode.physicsBody?.linearDamping = 0
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.restitution = 0
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 20.0
                        tileNode.physicsBody?.mass = 30.0
                        tileNode.physicsBody?.contactTestBitMask = 0
                        tileNode.physicsBody?.fieldBitMask = 0
                        tileNode.physicsBody?.collisionBitMask = 0
                        
                        if (isEdgeTile) == 1{
                            tileNode.physicsBody?.restitution = 0.0
                            tileNode.physicsBody?.contactTestBitMask = Catergories.PLAYER
                        }
                        
                        tileNode.physicsBody?.categoryBitMask = Catergories.GROUND
                        
                        tileMap.addChild(tileNode)
                    }
                }
            }
        }
    }
    }

