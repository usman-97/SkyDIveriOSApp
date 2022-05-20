//
//  Cloud.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 13/05/2022.
//

import SpriteKit

class Cloud : GameObject {
    private var x: CGFloat = CGFloat()
    private var y: CGFloat = CGFloat()
    
    override func setPosition(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        super.setPosition(x: x, y: y)
    }
    
    override func respawn() {
        ObjectSpriteNode.position = CGPoint(x: ObjectSpriteNode.size.width, y: 0)
    }
    
//    func cloudAction(width: CGFloat, height: CGFloat, duration: Int)->SKAction {
//        return super.SequenceOfActions(width: width, height: height, duration: duration)
//    }
}
