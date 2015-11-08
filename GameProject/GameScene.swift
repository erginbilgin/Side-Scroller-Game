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
    let sheet = sprites()
    var player = Player()
    
    override func didMoveToView(view: SKView) {
        // 2
        backgroundColor = SKColor.whiteColor()
        let background = SKSpriteNode(texture: sheet.background());
        background.anchorPoint = CGPointMake(0, 0)
        addChild(background)
        player.position = CGPoint(x: 0.0 - (player.size.width * 0.5), y: size.height * 0.5)
        player.RunTo(CGPoint(x: size.width/2, y: size.height * 0.5))
        addChild(player)
    }
}