//
//  GameScene.swift
//  Pachinko
//
//  Created by Paulo Filho on 22/09/22.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        addChild(background)
    }
}
