//
//  Helicopter.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 14/05/2022.
//

import SpriteKit

class Helicopter : GameObject {
    override func sequenceOfActions(width: CGFloat, height: CGFloat, duration: Int) -> SKAction {
        let delay = SKAction.move(to: CGPoint(x: width, y: 0 - ObjectSpriteNode.size.height), duration: 0)
        let upAction = SKAction.move(to: CGPoint(x: width, y: height + ObjectSpriteNode.size.height), duration: TimeInterval(duration))
        let respawn = SKAction.move(to: CGPoint(x: width, y: 0 - ObjectSpriteNode.size.height), duration: 0)
        return SKAction.sequence([delay, upAction, respawn])
    }
}
