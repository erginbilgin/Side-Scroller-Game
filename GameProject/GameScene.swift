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
    var ground = SKSpriteNode()
    
    
    struct Category { // Physics categories
        static let Player: UInt32 = 1
        static let Obstacle: UInt32 = 2
        static let Ground: UInt32 = 4
    }
    
    override func didMoveToView(view: SKView) {
        // BACKGROUND START
        // TODO: CREATE BETTTER BACKGROUND SYSTEM (USE CLASS MAYBE)
        backgroundColor = SKColor.whiteColor()
        background = SKSpriteNode(texture: sheet.background())
        background.anchorPoint = CGPointMake(0, 0)
        physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        let actionMove = SKAction.moveTo(CGPoint(x: -background.size.width*0.5, y: 0.0), duration: NSTimeInterval(3.0))
        func bgloop(){
            background.runAction(actionMove, completion: {self.background.position = CGPoint(x: 0.0, y: 0.0); bgloop()})
        }
        addChild(background)
        // BACKGROUND END
        // GROUND START
        ground.size = CGSize(width: self.size.width, height: self.size.height * 0.3)
        ground.anchorPoint = CGPointMake(0, 0)
        addChild(ground)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size, center: CGPointMake(ground.size.width/2, ground.size.height/2))
        ground.physicsBody?.dynamic = false
        // GROUND END
        // PLAYER START
        player.position = CGPoint(x: 0.0 - (player.size.width * 0.5), y: size.height * 0.5)
        player.RunTo(CGPoint(x: size.width/2, y: size.height * 0.5))
        addChild(player)
        //player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.texture!.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        // PLAYER END
        // UI START
        let playButton = SKSpriteNode(texture: sheet.playbutton())
        playButton.position = CGPoint(x: size.width * 0.75, y: size.height * 0.5)
        let fadeButton = SKAction.fadeInWithDuration(3.0)
        let wait = SKAction.waitForDuration(1.5)
        let acts = SKAction.sequence([wait, fadeButton])
        playButton.name = "play"
        playButton.alpha = 0.0
        playButton.runAction(acts, completion: {self.buttonActive = true})
        self.addChild(playButton)
        // UI END
    }
    // Touch Handling
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location) //1
            if (node.name == "play" && buttonActive){ //2  If we touch play button & button is active.
                let actionMove = SKAction.moveTo(CGPoint(x: -self.background.size.width*0.5, y: 0.0), duration: NSTimeInterval(3.0))
                func bgloop(){                        // Creating a backround loop with "bgloop()" It's recursive!
                    background.runAction(actionMove, completion: {self.background.position = CGPoint(x: 0.0, y: 0.0); bgloop()})
                }
                let buttonFadeOut = SKAction.fadeOutWithDuration(3.0)
                let playerGoBack = SKAction.moveTo(CGPoint(x: self.size.width*0.2, y: self.size.height*0.5), duration: NSTimeInterval(0.6))
                node.runAction(buttonFadeOut)
                bgloop()
                player.runAction(playerGoBack, completion: {self.player.Run()}) // Place player to run position and start running!
                print("heeey") // DEBUG LOG
                buttonActive = false
                isPlaying = true
                
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
}