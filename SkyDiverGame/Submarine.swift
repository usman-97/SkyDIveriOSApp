//
//  Submarine.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 17/05/2022.
//

import SpriteKit

class Submarine : GameObject {
    override func sequenceOfActions(width: CGFloat, height: CGFloat, duration: Int) -> SKAction {
        let submarineUpAction = SKAction.move(to: CGPoint(x: width / 2, y: (height / 2) + 80), duration: TimeInterval(duration))
        let submarineDownAction = SKAction.move(to: CGPoint(x: width / 2, y: (height / 2) - 200), duration: TimeInterval(duration))
        let submarineMoveRightAction = SKAction.move(to: CGPoint(x: width + 200, y: (height / 2) - 200), duration: TimeInterval(duration))
        return SKAction.sequence([submarineUpAction, submarineDownAction, submarineMoveRightAction])
    }
}
