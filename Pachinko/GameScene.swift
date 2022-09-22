//
//  GameScene.swift
//  Pachinko
//
//  Created by Paulo Filho on 22/09/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballAssets: [String] = ["ballRed", "ballBlue", "ballCyan", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballsLeftLabel: SKLabelNode!
    var ballsLeft = 5 {
        didSet {
            ballsLeftLabel.text = "Balls Left: \(ballsLeft)"
        }
    }
    
    var obstaclesPlaced: Bool = false
    var obstaclesLabel: SKLabelNode!
    var obstacles = 0 {
        didSet {
            obstaclesLabel.text = "Obstacles: \(obstacles)"
            
            if obstacles == 5 {
                obstaclesPlaced = true
            }
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLeftLabel.text = "Balls Left: 5"
        ballsLeftLabel.horizontalAlignmentMode = .right
        ballsLeftLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballsLeftLabel)
        
        obstaclesLabel = SKLabelNode(fontNamed: "Chalkduster")
        obstaclesLabel.text = "Obstacles: 0"
        obstaclesLabel.horizontalAlignmentMode = .right
        obstaclesLabel.position = CGPoint(x: 980, y: 600)
        addChild(obstaclesLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                // Create a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "obstacle"
                
                obstacles += 1
                
                addChild(box)
            } else {
                if obstaclesPlaced {
                    let ballImage = ballAssets[Int.random(in: 0...ballAssets.count-1)]
                    let ball = SKSpriteNode(imageNamed: ballImage)
                    
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = CGPoint(x: location.x, y: 768)
                    ball.name = "ball"
                    
                    addChild(ball)
                } else {
                    showAlert(message: "Place at least 5 obstacles first!", buttonTitle: "OK")
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            ballsLeft += 1
            checkResult()
        } else if object.name == "bad" {
            destroy(ball: ball)
            ballsLeft -= 1
            checkResult()
        } else if object.name == "obstacle" {
            destroy(ball: ball)
            destroy(ball: object)
            ballsLeft -= 1
            obstacles -= 1
            checkResult()
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func checkResult() {
        let resetGameAction: (UIAlertAction) -> Void = { [weak self] _ in
            self?.obstacles = 0
            self?.obstaclesPlaced = false
            self?.ballsLeft = 5
            self?.enumerateChildNodes(withName: "obstacle", using: { node, _ in
                node.removeFromParent()
            })
        }
        
        if obstacles > 0 && ballsLeft == 0 {
            showAlert(message: "Aww... you've lost.", buttonTitle: "Retry", action: resetGameAction)
        }
        
        if obstacles == 0 {
            score += 1
            showAlert(message: "Yay! Congratulations, you've won!", buttonTitle: "New game", action: resetGameAction)
        }
    }
    
    func showAlert(message: String, buttonTitle: String, action: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        
        view?.window?.rootViewController?.present(ac, animated: true)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
