//
//  GameScene.swift
//  GameProject
//
//  Created by Ergin Bilgin on 31/10/15.
//  Copyright (c) 2015 Ergin Bilgin. All rights reserved.
//
import SpriteKit

class GameScene: SKScene {
    
    // 1
    let sheet = Sprites()
    var player = Player()
    var background = SKSpriteNode()
    var buttonActive:Bool = false
    var isPlaying: Bool = false
    var isRunning: Bool = false
    var ground = SKSpriteNode()
    
    
    struct Category { // Physics categories
        static let Player: UInt32 = 1
        static let Obstacle: UInt32 = 2
        static let Ground: UInt32 = 4
    }
    
    func SetPlayer(){
        player.position = CGPoint(x: 0.0 - (player.size.width * 0.5), y: size.height * 0.5)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.texture!.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
    }
    
    func SpawnPlayer(){
        player.RunTo(CGPoint(x: size.width/2, y: size.height * 0.5))
        addChild(player)
        //player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
    }
    
    func UIStart(){
        let playButton = SKSpriteNode(texture: sheet.playbutton())
        playButton.position = CGPoint(x: size.width * 0.75, y: size.height * 0.5)
        let fadeButton = SKAction.fadeInWithDuration(3.0)
        let wait = SKAction.waitForDuration(1.5)
        let acts = SKAction.sequence([wait, fadeButton])
        playButton.name = "play"
        playButton.alpha = 0.0
        playButton.runAction(acts, completion: {self.buttonActive = true; self.isRunning = true})
        self.addChild(playButton)
    }
    
    func SetBackground(){
        backgroundColor = SKColor.whiteColor()
        background = SKSpriteNode(texture: sheet.background())
        background.anchorPoint = CGPointMake(0, 0)
        physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        let actionMove = SKAction.moveTo(CGPoint(x: -background.size.width*0.5, y: 0.0), duration: NSTimeInterval(3.0))
        func bgloop(){
            background.runAction(actionMove, completion: {self.background.position = CGPoint(x: 0.0, y: 0.0); bgloop()})
        }
        addChild(background)
    }
    
    func SetGround(){
        ground.size = CGSize(width: self.size.width, height: self.size.height * 0.3)
        ground.anchorPoint = CGPointMake(0, 0)
        addChild(ground)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size, center: CGPointMake(ground.size.width/2, ground.size.height/2))
        ground.physicsBody?.dynamic = false
    }
    
    func SpawnBox(){
        let box = SKSpriteNode(texture: sheet.box())
        box.physicsBody = SKPhysicsBody(rectangleOfSize: (box.texture?.size())!)
        //box.anchorPoint = CGPointMake(0.0, 0.0)
        box.position = CGPointMake(self.size.width + (box.texture!.size().width * 0.5),
            self.size.height * 0.3 + box.texture!.size().height * 0.5)
        box.physicsBody?.dynamic = false
        box.physicsBody?.allowsRotation = false
        let boxMove = SKAction.moveToX(0.0 - box.size.width, duration: 2.33)
        box.runAction(boxMove, completion: {box.removeFromParent()})
        addChild(box)
    }
    
    func SpawnFruit(){
        let cherry = SKSpriteNode(texture: sheet.cherry())
        let strawberry = SKSpriteNode(texture: sheet.strawberry())
        var fruitList: [SKSpriteNode] = [cherry, strawberry]
        let random: Int = Int(arc4random_uniform(2))
        let fruit = fruitList[random]
        if random == 0 {
            fruit.name = "cherry"
        } else if random == 1 {
            fruit.name = "strawberry"
        }
        fruit.physicsBody = SKPhysicsBody(rectangleOfSize: (fruit.texture?.size())!)
        fruit.position = CGPointMake(self.size.width + (fruit.texture!.size().width * 0.5),
            self.size.height * 0.3 + fruit.texture!.size().height * 2)
        fruit.physicsBody?.dynamic = false
        fruit.physicsBody?.allowsRotation = false
        let boxMove = SKAction.moveToX(0.0 - fruit.size.width, duration: 2.33)
        fruit.runAction(boxMove, completion: {fruit.removeFromParent()})
        addChild(fruit)
    }
    
    func StartGame(node: SKNode){
        let actionMove = SKAction.moveTo(CGPoint(x: -self.background.size.width*0.5, y: 0.0), duration: NSTimeInterval(3.0))
        func bgloop(){                        // Creating a backround loop with "bgloop()" It's recursive!
            background.runAction(actionMove, completion: {self.background.position = CGPoint(x: 0.0, y: 0.0); bgloop()})
        }
        let buttonFadeOut = SKAction.fadeOutWithDuration(3.0)
        let playerGoBack = SKAction.moveTo(CGPoint(x: self.size.width*0.2, y: self.size.height*0.5), duration: NSTimeInterval(0.6))
        node.runAction(buttonFadeOut, completion: {node.removeFromParent()})
        bgloop()
        player.runAction(playerGoBack, completion: {self.player.Run()}) // Place player to run position and start running!
        print("heeey") // DEBUG LOG
        buttonActive = false
        isPlaying = true
        // SPAWN BOX
        let wait = SKAction.waitForDuration(3, withRange: 2)
        let spawn = SKAction.runBlock {
            // Create a new node and it add to the scene...
            self.SpawnBox()
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
        // SPAWN CHERRY
        let spawn2 = SKAction.runBlock {
            // Create a new node and it add to the scene...
            self.SpawnFruit()
        }
        let sequence2 = SKAction.sequence([wait, spawn2])
        self.runAction(SKAction.repeatActionForever(sequence2))
        
        //SpawnBox()
        
    }
    
    func StopGame(){
        player.removeFromParent()
        UIStart()
        buttonActive = true
        isPlaying = false
        isRunning = false
        background.removeAllActions()
        self.removeAllActions()
        SpawnPlayer()
    }
    
    override func didMoveToView(view: SKView) {
        SetBackground()     // 1- CREATE BACKGROUND
        SetGround()         // 2- CREATE GROUND
        SetPlayer()         // 3- CREATE PLAYER
        SpawnPlayer()       // 4- SPAWN PLAYER
        UIStart()           // 5- SHOW UI
    }
    
    
    
    
    // Touch Handling
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if (node.name == "play" && buttonActive){ // If we touch play button && button is active.
                StartGame(node)
            } else {
                if isPlaying && !player.isJumping {
                    print("jump") // DEBUG LOG
                    player.Jump()
                    player.physicsBody!.velocity = CGVectorMake(0, 0)
                    player.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
                    
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if player.position.x < (0 - player.size.width) && isRunning{
            StopGame()
        }
    }
}