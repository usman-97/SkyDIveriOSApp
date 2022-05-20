//
//  GameObject.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 13/05/2022.
//

import SpriteKit

class GameObject {
    private var objectSpriteNode: SKSpriteNode;
    
    var ObjectSpriteNode: SKSpriteNode {
        get { return objectSpriteNode }
    }
    
    init(image: String, width: Int, height: Int) {
        objectSpriteNode = SKSpriteNode(imageNamed: image) // Sprite
        objectSpriteNode.size = CGSize(width: width, height: height)
    }
    
    // Set sprite position
    internal func setPosition(x: CGFloat, y: CGFloat) {
        objectSpriteNode.position = CGPoint(x: x, y: y)
    }
    
    // Respawn sprite to default location
    internal func respawn() {
        objectSpriteNode.position = CGPoint(x: 0, y: 0)
    }
    
    // Sequence of actions for sprite to perform
    internal func sequenceOfActions(width: CGFloat, height: CGFloat, duration: Int)->SKAction {
        let upAction = SKAction.move(to: CGPoint(x: width, y: height + ObjectSpriteNode.size.height), duration: TimeInterval(duration))
        let respawn = SKAction.move(to: CGPoint(x: width, y: 0 - ObjectSpriteNode.size.height), duration: 0)
        return SKAction.sequence([upAction, respawn])
    }
}
