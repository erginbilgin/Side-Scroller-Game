//
//  GameScene.swift
//  GameProject
//
//  Created by Ergin Bilgin on 31/10/15.
//  Copyright (c) 2015 Ergin Bilgin. All rights reserved.
//
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let sheet = Sprites()
    var player = Player()
    var scoretable = SKSpriteNode()
    var fruit1 = SKSpriteNode()
    var fruit2 = SKSpriteNode()
    var fruit3 = SKSpriteNode()
    var fruit4 = SKSpriteNode()
    var fruit5 = SKSpriteNode()
    var fruit6 = SKSpriteNode()
    var fruit7 = SKSpriteNode()
    var fruit8 = SKSpriteNode()
    var background = SKSpriteNode()
    var buttonActive:Bool = false
    var isPlaying: Bool = false
    var isRunning: Bool = false
    var ground = SKSpriteNode()
    var collectedItems = Queue()
    
    struct Category { // Physics categories
        static let Player: UInt32 = 1
        static let Obstacle: UInt32 = 2
        static let Ground: UInt32 = 4
        static let Fruit: UInt32 = 8
    }
    
    func SetPlayer(){
        player.position = CGPoint(x: 0.0 - (player.size.width * 0.5), y: size.height * 0.5)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.texture!.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = Category.Player
        player.physicsBody?.contactTestBitMask = Category.Fruit
        player.physicsBody?.collisionBitMask = Category.Obstacle
    }
    
    func SpawnPlayer(){
        player.RunTo(CGPoint(x: size.width/2, y: size.height * 0.5))
        addChild(player)
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
        box.position = CGPointMake(self.size.width + (box.texture!.size().width * 0.5),
            self.size.height * 0.3 + box.texture!.size().height * 0.5)
        box.physicsBody?.dynamic = false
        box.physicsBody?.allowsRotation = false
        let boxMove = SKAction.moveToX(0.0 - box.size.width, duration: 2.33)
        box.runAction(boxMove, completion: {box.removeFromParent()})
        addChild(box)
    }
    
    func GenerateScoreSprite() -> SKSpriteNode{
        let opt1 = SKSpriteNode(texture: sheet.cherry())
        let opt2 = SKSpriteNode(texture: sheet.strawberry())
        let opt3 = SKSpriteNode()
        let fruit = collectedItems.dequeue()
        if fruit == "cherry"{
            return opt1
        }
        if fruit == "strawberry"{
            return opt2
        }
        return opt3
    }
    
    func ShowScore(){
        //-------------------------------------------------------------
        scoretable = SKSpriteNode(texture: sheet.score())
        fruit1 = GenerateScoreSprite()
        fruit2 = GenerateScoreSprite()
        fruit3 = GenerateScoreSprite()
        fruit4 = GenerateScoreSprite()
        fruit5 = GenerateScoreSprite()
        fruit6 = GenerateScoreSprite()
        fruit7 = GenerateScoreSprite()
        fruit8 = GenerateScoreSprite()
        //-------------------------------------------------------------
        let positionX = self.size.width * 0.5
        let positionY = self.size.height + scoretable.size.height * 0.5
        //-------------------------------------------------------------
        fruit1.position = CGPointMake(positionX - scoretable.size.width / 9 * 3.5, positionY)
        fruit2.position = CGPointMake(positionX - scoretable.size.width / 9 * 2.5, positionY)
        fruit3.position = CGPointMake(positionX - scoretable.size.width / 9 * 1.5, positionY)
        fruit4.position = CGPointMake(positionX - scoretable.size.width / 9 * 0.5, positionY)
        fruit5.position = CGPointMake(positionX + scoretable.size.width / 9 * 0.5, positionY)
        fruit6.position = CGPointMake(positionX + scoretable.size.width / 9 * 1.5, positionY)
        fruit7.position = CGPointMake(positionX + scoretable.size.width / 9 * 2.5, positionY)
        fruit8.position = CGPointMake(positionX + scoretable.size.width / 9 * 3.5, positionY)
        scoretable.alpha = 0.5
        scoretable.position = CGPointMake(self.size.width * 0.5, self.size.height + scoretable.size.height * 0.5)
        //-------------------------------------------------------------
        let scoreMove = SKAction.moveToY(self.size.height - scoretable.size.height * 0.5, duration: 0.5)
        scoretable.runAction(scoreMove)
        fruit1.runAction(scoreMove)
        fruit2.runAction(scoreMove)
        fruit3.runAction(scoreMove)
        fruit4.runAction(scoreMove)
        fruit5.runAction(scoreMove)
        fruit6.runAction(scoreMove)
        fruit7.runAction(scoreMove)
        fruit8.runAction(scoreMove)
        //-------------------------------------------------------------
        addChild(scoretable)
        addChild(fruit1)
        addChild(fruit2)
        addChild(fruit3)
        addChild(fruit4)
        addChild(fruit5)
        addChild(fruit6)
        addChild(fruit7)
        addChild(fruit8)
    }

    
    func RemoveScore(){
        let scoreMove = SKAction.moveToY(self.size.height + scoretable.size.height * 0.5, duration: 0.5)
        scoretable.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit1.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit2.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit3.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit4.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit5.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit6.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit7.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
        fruit8.runAction(scoreMove, completion:{self.scoretable.removeFromParent()})
    }
    
    func SpawnFruit(){
        let cherry = SKSpriteNode(texture: sheet.cherry())
        let strawberry = SKSpriteNode(texture: sheet.strawberry())
        var fruitList: [SKSpriteNode] = [cherry, strawberry]
        let random: Int = Int(arc4random_uniform(UInt32(fruitList.count)))
        let fruit = fruitList[random]
        switch random{
        case 0:
            fruit.name = "cherry"
        case 1:
            fruit.name = "strawberry"
        default:
            break
        }

        fruit.physicsBody = SKPhysicsBody(rectangleOfSize: (fruit.texture?.size())!)
        fruit.position = CGPointMake(self.size.width + (fruit.texture!.size().width * 0.5),
            self.size.height * 0.3 + fruit.texture!.size().height * 2)
        fruit.physicsBody?.dynamic = false
        fruit.physicsBody?.allowsRotation = false
        fruit.physicsBody?.categoryBitMask = Category.Fruit
        fruit.physicsBody?.contactTestBitMask = Category.Player
        fruit.physicsBody?.collisionBitMask = Category.Obstacle
        let fruitMove = SKAction.moveToX(0.0 - fruit.size.width, duration: 2.27)
        fruit.runAction(fruitMove, completion: {fruit.removeFromParent()})
        addChild(fruit)
    }
    
    func StartGame(node: SKNode){
        collectedItems = Queue()
        let actionMove = SKAction.moveTo(CGPoint(x: -self.background.size.width*0.5, y: 0.0), duration: NSTimeInterval(3.0))
        func bgloop(){                        // Creating a backround loop with "bgloop()" It's recursive!
            background.runAction(actionMove, completion: {self.background.position = CGPoint(x: 0.0, y: 0.0); bgloop()})
        }
        let buttonFadeOut = SKAction.fadeOutWithDuration(3.0)
        let playerGoBack = SKAction.moveTo(CGPoint(x: self.size.width*0.2, y: self.size.height*0.5), duration: NSTimeInterval(0.6))
        node.runAction(buttonFadeOut, completion: {node.removeFromParent()})
        bgloop()
        RemoveScore()
        player.runAction(playerGoBack, completion: {self.player.Run()}) // Place player to run position and start running!
        print("start") // DEBUG LOG
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
//        while (!collectedItems.isEmpty()){
//            print(collectedItems.dequeue())
//        }
        player.removeFromParent()
        UIStart()
        buttonActive = true
        isPlaying = false
        isRunning = false
        background.removeAllActions()           // REMOVE ALL ACTIONS FROM BACKGROUND
        self.removeAllActions()                 // REMOVE ALL ACTIONS FROM SCENE
        let wait = SKAction.waitForDuration(1)  // WAIT FOR 1 SEC BEFORE SPAWNING PLAYER AGAIN
        let spawnPlayer = SKAction.runBlock {
            self.SpawnPlayer()
        }
        let sequence = SKAction.sequence([wait, spawnPlayer])
        self.runAction(sequence)
        ShowScore()
    }
    
    func playerDidCollideWithFruit(player:SKSpriteNode, fruit:SKSpriteNode) {
        print("collect " + fruit.name!)
        collectedItems.enqueue(fruit.name!)
        fruit.removeFromParent()
    }
    
    override func didMoveToView(view: SKView) {
        SetBackground()     // 1- CREATE BACKGROUND
        SetGround()         // 2- CREATE GROUND
        SetPlayer()         // 3- CREATE PLAYER
        SpawnPlayer()       // 4- SPAWN PLAYER
        physicsWorld.contactDelegate = self
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node as! SKSpriteNode
        let secondNode = contact.bodyB.node as! SKSpriteNode
        
        if (contact.bodyA.categoryBitMask == Category.Player) &&
            (contact.bodyB.categoryBitMask == Category.Fruit) {
               playerDidCollideWithFruit(firstNode, fruit: secondNode)
        }
        if (contact.bodyB.categoryBitMask == Category.Player) &&
            (contact.bodyA.categoryBitMask == Category.Fruit) {
                playerDidCollideWithFruit(secondNode, fruit: firstNode)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if player.position.x < (0 - player.size.width/2) && isRunning{
            StopGame()
        }
//        if collectedItems.list.count == 8 {
//            StopGame()
//        }
    }
}