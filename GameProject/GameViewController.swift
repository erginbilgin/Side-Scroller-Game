//
//  GameViewController.swift
//  GameProject
//
//  Created by Ergin Bilgin on 31/10/15.
//  Copyright (c) 2015 Ergin Bilgin. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        skView.showsPhysics = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}