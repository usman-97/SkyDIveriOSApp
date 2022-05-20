//
//  SkyDiverObject.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 13/05/2022.
//

import SpriteKit

class SkyDiverObject : GameObject {
    private var defaultSkyDiverY: CGFloat = CGFloat()
    
    public var DefaultSkyDiverY: CGFloat {
        get { return defaultSkyDiverY }
    }
    
    override init(image: String, width: Int, height: Int) {
        super.init(image: image, width: width, height: height)
    }
    
    internal override func setPosition(x: CGFloat, y: CGFloat) {
        defaultSkyDiverY = y
        super.setPosition(x: x, y: y)
    }
}
