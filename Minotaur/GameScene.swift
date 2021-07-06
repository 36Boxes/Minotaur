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
    var enemies = [CharacterNode]()
    var graphs = [String : GKGraph]()
    var physicsDelegate = PhysicsDetection()
    var player: CharacterNode?
    var enemy : CharacterNode?
    var opp : CharacterNode!
    
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
                player?.setHurtbox(size: CGSize(width: 20, height: 40))
            }
        

            if let plComponent = thePlayer.entity?.component(ofType: PlayerControlComponent.self){
                plComponent.setupControls(camera: camera!, scene: self)
            }
            
        opp = CharacterNode(imageNamed: "MI1")
        let entit = GKEntity()
        entit.addComponent(EnemyControlComponent())
        entit.addComponent(AnimationComponent())
        entit.addComponent(GKSKNodeComponent(node: opp))
            entities.append(entit)
            opp.createPhysics()
            opp.setupSates()
            opp.name = "Enemy"
            opp.zPosition = 5
            opp.position = CGPoint(x: (camera?.position.x)! - 50, y: (camera?.position.y)!)
            self.addChild(opp)
            
        }
        
        if let tilemap = childNode(withName: "ForegroundMap") as? SKTileMapNode{
            giveTileMapPhysicsBody(map: tilemap)
        }
    }
    
    func centerOnNode(node: SKNode){
        self.camera!.run(SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y + 100), duration: 0.5))
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
        
        if let _ = scene!.childNode(withName:"//*Enemy*"){
            print("opps deya")
        } else {
            print("opps not deya")
            opp = CharacterNode(imageNamed: "MI1")
            let entit = GKEntity()
            entit.addComponent(EnemyControlComponent())
            entit.addComponent(AnimationComponent())
            entit.addComponent(GKSKNodeComponent(node: opp))
                entities.append(entit)
                opp.createPhysics()
                opp.setupSates()
                opp.name = "Enemy"
                opp.zPosition = 5
                opp.position = CGPoint(x: (camera?.position.x)! - 500, y: (camera?.position.y)!)
                self.addChild(opp)
        }
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

