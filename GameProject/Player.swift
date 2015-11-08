//
//  Player.swift
//  GameProject
//
//  Created by Ergin Bilgin on 07/11/15.
//  Copyright © 2015 Ergin Bilgin. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode{
   
    let sheet = sprites()

    init(){
        super.init(texture: sheet.player_idle_000(), color: UIColor.clearColor(), size: sheet.player_idle_000().size())
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
   
    
    func RunTo(to: CGPoint){
        let playerRun = SKAction.animateWithTextures(sheet.player_run(), timePerFrame: 0.07, resize: true, restore: true)
        let makePlayerRun = SKAction.repeatActionForever(playerRun)
        let actionMove = SKAction.moveTo(to, duration: NSTimeInterval(3.0))
        runAction(makePlayerRun)
        runAction(actionMove, completion:{self.Slide()})
    }
    
    func Run(){
        let playerRun = SKAction.animateWithTextures(sheet.player_run(), timePerFrame: 0.07, resize: true, restore: true)
        let makePlayerRun = SKAction.repeatActionForever(playerRun)
        runAction(makePlayerRun)
    }
    
    func Idle(){
        let playerIdle = SKAction.animateWithTextures(sheet.player_idle(), timePerFrame: 0.07, resize: true, restore: true)
        let makePlayerIdle = SKAction.repeatActionForever(playerIdle)
        runAction(makePlayerIdle)
    }
    
    func Dead(){
        let playerDead = SKAction.animateWithTextures(sheet.player_dead(), timePerFrame: 0.07, resize: true, restore: true)
        removeAllActions()
        texture = sheet.player_dead_009()
        size = sheet.player_dead_009().size()
        runAction(playerDead)
    }
    
    func Slide(){
        let playerSlide = SKAction.animateWithTextures(sheet.player_slide(), timePerFrame: 0.07, resize: true, restore: true)
        removeAllActions()
        runAction(playerSlide, completion: {self.Idle()})
    }

}