//
//  GameScene.swift
//  SkyDiverGame
//
//  Created by user192046 on 5/13/22.
//

import SpriteKit
import SwiftUI

class GameScene : SKScene, SKPhysicsContactDelegate {
    // All game objects
    private var skyDiverObject: GameObject = SkyDiverObject(image: "skydiver.png", width: 130, height: 130)
    private var newSkyDiverLocation: CGPoint = CGPoint()
    private var currentNode : SKNode?
    private var leftCloudObject: Cloud = Cloud(image: "cloud.png", width: 100, height: 100)
    private var rightCloudObject: Cloud = Cloud(image: "cloud.png", width: 100, height: 100)
    private var leftHelicopterObject: Helicopter = Helicopter(image: "helicopter_l.png", width: 160, height: 160)
    private var rightHelicopterObject: Helicopter = Helicopter(image: "helicopter_r.png", width: 160, height: 160)
    
    // All categories to detect contact between objects
    private let skyDiverCategory: UInt32 = 0x1 << 0
    private let collisionObjectsCategory: UInt32 = 0x1 << 1
    
    private var isGameEnded: Bool = false
    
    // All displayed values
    let distanceText = SKLabelNode(fontNamed: "Futura-Bold")
    let netForceText = SKLabelNode(fontNamed: "Futura")
    let velocityText = SKLabelNode(fontNamed: "Futura-Bold")
    let accelerationText = SKLabelNode(fontNamed: "Futura")
    let airDragForceText = SKLabelNode(fontNamed: "Futura")
    let massText = SKLabelNode(fontNamed: "Futura")
    
    private var distanceTravelled: Int = 0 // Total distance player has travelled
    // Remaining distance to travel
    private var distance: Int = 200000 {
        didSet {
            distanceText.text = "\(distance)KM"
        }
    }
    
    var hours: Int = 0
    
    private let newtonLaws: NewtonLaws = NewtonLaws(acceleration: 0, airDragForce: 0, mass: 75)
    private var netForce: Int = 0 {
        didSet {
            netForceText.text = "\(netForce)N"
        }
    }
    
    private var airDragForce: Int = 0 {
        didSet {
            airDragForceText.text = "\(airDragForce)N"
        }
    }
    
    private var velocity: Int = 0 {
        didSet {
            velocityText.text = "\(velocity)KM/H"
        }
    }
    
    private var acceleration: Int = 0 {
        didSet {
            accelerationText.text = "\(acceleration)KM/H^2"
        }
    }
    
    private var mass: Int = 0 {
        didSet {
            massText.text = "\(mass)KG"
        }
    }
    
    private var newNetForceValue: Int = 0
    public var NewNetForceValue: Int {
        get { return newNetForceValue }
        set(val) { newNetForceValue = val }
    }
    
    public var Distance: Int {
        get { return distance }
    }
    
    public var DistanceTravelled: Int {
        get { return distanceTravelled }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        // Background colour of the scene
        backgroundColor = SKColor.init(red: 179/255, green: 229/255, blue: 252/255, alpha: 1.0)
        
        // All required values to apply newton's laws
        netForce = newtonLaws.NetForce
        airDragForce = newtonLaws.NetForce
        velocity = newtonLaws.Velocity
        acceleration = newtonLaws.Acceleration
        mass = newtonLaws.Mass
        
        // Sky diver object
        skyDiverObject.setPosition(x: size.width / 2, y: (size.height / 2) + 100)
        skyDiverObject.ObjectSpriteNode.name = "Sky diver"
        skyDiverObject.ObjectSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(skyDiverObject.ObjectSpriteNode.size.width / 2, skyDiverObject.ObjectSpriteNode.size.height / 2))
        skyDiverObject.ObjectSpriteNode.physicsBody?.categoryBitMask = skyDiverCategory
        skyDiverObject.ObjectSpriteNode.physicsBody?.contactTestBitMask = collisionObjectsCategory
        skyDiverObject.ObjectSpriteNode.physicsBody?.isDynamic = true
        skyDiverObject.ObjectSpriteNode.physicsBody?.affectedByGravity = false
        addChild(skyDiverObject.ObjectSpriteNode)

        // Left side cloud object
        leftCloudObject.setPosition(x: leftCloudObject.ObjectSpriteNode.size.width, y: 0)
        leftCloudObject.ObjectSpriteNode.name = "Left cloud"
        let leftCloudActionSequence = leftCloudObject.sequenceOfActions(width: size.width / 4, height: size.height, duration: 10)
        leftCloudObject.ObjectSpriteNode.run(SKAction.repeatForever(leftCloudActionSequence))
        addChild(leftCloudObject.ObjectSpriteNode)
        
        // Right side cloud object
        let cloudDelayAction = SKAction.move(to: CGPoint(x: size.width - 50, y: 0 - rightCloudObject.ObjectSpriteNode.size.height), duration: 2)
        rightCloudObject.setPosition(x: size.width - rightCloudObject.ObjectSpriteNode.size.width, y: 0)
        rightCloudObject.ObjectSpriteNode.name = "Right cloud"
        let rightCloudActionSequence = rightCloudObject.sequenceOfActions(width: size.width - 50, height: size.height, duration: 10)
        let rightCloudActionSequenceWithDelay = SKAction.sequence([cloudDelayAction, rightCloudActionSequence])
        rightCloudObject.ObjectSpriteNode.run(SKAction.repeatForever(rightCloudActionSequenceWithDelay))
        addChild(rightCloudObject.ObjectSpriteNode)
        
        // Left side helicopter
        leftHelicopterObject.setPosition(x: leftHelicopterObject.ObjectSpriteNode.size.width / 2, y: 0)
        leftHelicopterObject.ObjectSpriteNode.name = "Left helicopter"
        leftHelicopterObject.ObjectSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(leftHelicopterObject.ObjectSpriteNode.size.width / 2, leftHelicopterObject.ObjectSpriteNode.size.height / 2))
        leftHelicopterObject.ObjectSpriteNode.physicsBody?.categoryBitMask = collisionObjectsCategory
        leftHelicopterObject.ObjectSpriteNode.physicsBody?.contactTestBitMask = skyDiverCategory
        leftHelicopterObject.ObjectSpriteNode.physicsBody?.isDynamic = false
        leftHelicopterObject.ObjectSpriteNode.physicsBody?.affectedByGravity = false
        let leftHelicopterActionSquence = leftHelicopterObject.sequenceOfActions(width: size.width / 4, height: size.height, duration: 8)
        leftHelicopterObject.ObjectSpriteNode.run(SKAction.repeatForever(leftHelicopterActionSquence))
        addChild(leftHelicopterObject.ObjectSpriteNode)
        
        // Right side helicopter
        let helicopterDelayAction = SKAction.move(to: CGPoint(x: size.width - 50, y: 0 - rightCloudObject.ObjectSpriteNode.size.height), duration: 2)
        
        rightHelicopterObject.setPosition(x: size.width - leftHelicopterObject.ObjectSpriteNode.size.width, y: 0)
        rightHelicopterObject.ObjectSpriteNode.name = "Right helicopter"
        rightHelicopterObject.ObjectSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(rightHelicopterObject.ObjectSpriteNode.size.width / 2, rightHelicopterObject.ObjectSpriteNode.size.height / 2))
        rightHelicopterObject.ObjectSpriteNode.physicsBody?.categoryBitMask = collisionObjectsCategory
        rightHelicopterObject.ObjectSpriteNode.physicsBody?.contactTestBitMask = skyDiverCategory
        rightHelicopterObject.ObjectSpriteNode.physicsBody?.isDynamic = false
        rightHelicopterObject.ObjectSpriteNode.physicsBody?.affectedByGravity = false
        let rightHelicopterActionSquence = rightHelicopterObject.sequenceOfActions(width: size.width - leftHelicopterObject.ObjectSpriteNode.size.width, height: size.height, duration: 8)
        let leftHelicopterActionSequenceWithDelay = SKAction.sequence([helicopterDelayAction, rightHelicopterActionSquence])
        rightHelicopterObject.ObjectSpriteNode.run(SKAction.repeatForever(leftHelicopterActionSequenceWithDelay))
        addChild(rightHelicopterObject.ObjectSpriteNode)
        
        // All text element styles
        distanceText.fontSize = 30
        distanceText.fontColor = SKColor.init(red: 2/255, green: 137/255, blue: 209/255, alpha: 1.0)
        distanceText.position = CGPoint(x: 100, y: size.height - 80)
        addChild(distanceText)
        
        velocityText.fontSize = 25
        velocityText.fontColor = SKColor.init(red: 1/255, green: 217/255, blue: 50/255, alpha: 1.0)
        velocityText.position = CGPoint(x: 100, y: size.height - 120)
        addChild(velocityText)
        
        accelerationText.fontSize = 25
        accelerationText.fontColor = SKColor.init(red: 2/255, green: 137/255, blue: 209/255, alpha: 1.0)
        accelerationText.position = CGPoint(x: 100, y: size.height - 160)
        addChild(accelerationText)
        
        netForceText.fontSize = 25
        netForceText.fontColor = SKColor.init(red: 209/255, green: 12/255, blue: 53/255, alpha: 1.0)
        netForceText.position = CGPoint(x: size.width - 40, y: size.height - 75)
        addChild(netForceText)

        airDragForceText.fontSize = 25
        airDragForceText.fontColor = SKColor.init(red: 3/255, green: 169/255, blue: 244/255, alpha: 1.0)
        airDragForceText.position = CGPoint(x: size.width - 40, y: size.height - 115)
        addChild(airDragForceText)
        
        massText.fontSize = 25
        massText.fontColor = SKColor.init(red: 161/255, green: 123/255, blue: 79/255, alpha: 1.0)
        massText.position = CGPoint(x: size.width - 40, y: size.height - 160)
        addChild(massText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            newSkyDiverLocation = location // Get play touched screen location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get sky diver position
        let skyDiverX: CGFloat = skyDiverObject.ObjectSpriteNode.position.x
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            if (skyDiverX > 0 && skyDiverX <= size.width) {
                // Move sky diver to given position
                skyDiverObject.ObjectSpriteNode.run(SKAction.moveTo(x: location.x, duration: 1))
            }
            else {
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isGameEnded {
            // Find total net force
            newtonLaws.calculateNetForce(newNetForceValue: newNetForceValue)
            netForce = newtonLaws.NetForce
            
            // Find total air drag force
            newtonLaws.calculateAirDragForce()
            airDragForce = newtonLaws.AirDragForce
            
            // Total acceleration
            acceleration = newtonLaws.Acceleration
            
            // Overall velocity
            velocity = newtonLaws.Velocity
            
            // Calculate velocity after 1000 km
            if distance % 1000 == 0 {
                newtonLaws.calculateVelocity(hours: self.hours)
            }

            if distance > 0 {
                distance -= 100
                distanceTravelled += 100
                
                if (distance % 1000 == 0) {
                    hours += 1
                }
            }
            else {
                distance = 0
            }
            
            if (distance == 3000) {
                destroyNode(node: leftCloudObject.ObjectSpriteNode)
                destroyNode(node: rightCloudObject.ObjectSpriteNode)
                destroyNode(node: leftHelicopterObject.ObjectSpriteNode)
                destroyNode(node: rightHelicopterObject.ObjectSpriteNode)
                
                // Ocean or sea object
                let seaObject: GameObject = GameObject(image: "water.png", width: Int(size.width), height: Int(size.height))
                seaObject.setPosition(x: 195, y: 0)
                seaObject.ObjectSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 200))
                seaObject.ObjectSpriteNode.physicsBody?.categoryBitMask = collisionObjectsCategory
                seaObject.ObjectSpriteNode.physicsBody?.contactTestBitMask = skyDiverCategory
                seaObject.ObjectSpriteNode.physicsBody?.isDynamic = false
                seaObject.ObjectSpriteNode.physicsBody?.affectedByGravity = false
                let seaAction = SKAction.move(to: CGPoint(x: 195, y: size.height / 2), duration: 4)
                seaObject.ObjectSpriteNode.run(seaAction)
                addChild(seaObject.ObjectSpriteNode)
                
                // Submarine object
                let submarineObject: Submarine = Submarine(image: "submarine.png", width: 200, height: 150)
                submarineObject.setPosition(x: size.width / 2, y: 0)
                let submarineActions: SKAction = submarineObject.sequenceOfActions(width: size.width, height: size.height, duration: 4)
                submarineObject.ObjectSpriteNode.run(submarineActions)
                addChild(submarineObject.ObjectSpriteNode)
            }
        }
        else {
            // Show these text elements when game ends
            let endTextLine1 = SKLabelNode(fontNamed: "Futura")
            endTextLine1.text = "Game has been ended"
            endTextLine1.fontSize = 20
            endTextLine1.fontColor = SKColor.init(red: 3/255, green: 169/255, blue: 244/255, alpha: 1.0)
            endTextLine1.position = CGPoint(x: 200, y: (size.height / 2) + 200)
            addChild(endTextLine1)
            
            let endTextLine2 = SKLabelNode(fontNamed: "Futura")
            endTextLine2.text = "Click on pause button to continue"
            endTextLine2.fontSize = 20
            endTextLine2.fontColor = SKColor.init(red: 3/255, green: 169/255, blue: 244/255, alpha: 1.0)
            endTextLine2.position = CGPoint(x: 200, y: (size.height / 2) + 150)
            addChild(endTextLine2)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Check contact between sky diver and helicopter
        if (contactMask == skyDiverCategory | collisionObjectsCategory) {
            isGameEnded = true
            destroyNode(node: skyDiverObject.ObjectSpriteNode)
            stopNode(node: leftCloudObject.ObjectSpriteNode)
            stopNode(node: rightCloudObject.ObjectSpriteNode)
            stopNode(node: leftHelicopterObject.ObjectSpriteNode)
            stopNode(node: rightHelicopterObject.ObjectSpriteNode)
        }
    }
    
    // Destory sprite from the scene
    private func destroyNode(node: SKNode) {
        node.removeFromParent()
    }
    
    // Stop all sprite actions
    private func stopNode(node: SKNode) {
        node.removeAllActions()
    }
}
