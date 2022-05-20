//
//  NewtonLaws.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 15/05/2022.
//

class NewtonLaws {
    private let initialVelocity: Int = 100
    private let netForceLimit: Int = 1000
    private let finalVelocity = 200
    
    private var acceleration: Int
    private var airDragForce: Int
    private var mass: Int
    private var initialNetForce: Int
    private var oldNetForceValue: Int = 0
    private var netForce: Int
    private var velocity: Int
    
    public var NetForce: Int {
        get{ return netForce }
        set(val) { netForce = val }
    }
    
    public var AirDragForce: Int {
        get { return airDragForce }
    }
    
    public var Velocity: Int {
        get { return velocity }
        set(val) { velocity = val }
    }
    
    public var Acceleration: Int {
        get { return acceleration }
    }
    
    public var Mass: Int {
        get { return mass }
    }
    
    init(acceleration: Int, airDragForce: Int, mass: Int) {
        self.acceleration = acceleration
        self.airDragForce = airDragForce
        self.mass = mass
        
        initialNetForce = Int(Double(mass) * 9.80)
        netForce = initialNetForce
        velocity = initialVelocity
    }
    
    
    func calculateNetForce(newNetForceValue: Int) {
        if  newNetForceValue > oldNetForceValue && netForce < netForceLimit {
            netForce += 1
        }
        else if netForce > initialVelocity {
            if newNetForceValue < oldNetForceValue && netForce > initialNetForce {
                netForce -= 1
            }
        }
        
        calculateAcceleration()
        oldNetForceValue = newNetForceValue
    }
    
    // Calculate acceleration using newton's second law of motion
    private func calculateAcceleration() {
        if (netForce == initialNetForce) {
            acceleration = 0
        }
        else {
            acceleration = netForce / mass
        }
    }
    
    func calculateAirDragForce() {
        if (airDragForce != netForce) {
            if airDragForce > netForce {
                airDragForce -= 1
            }
            if airDragForce < netForce {
                airDragForce += 1
            }
        }
    }
    
    func calculateVelocity(hours: Int) {
        let tempVelocity: Int = initialVelocity + (acceleration * hours)
        if tempVelocity > velocity {
            if (velocity < (finalVelocity + 1)) {
                velocity += 1
            }
        }
        else if velocity > initialVelocity{
            velocity -= 1
        }
    }
    
    func findChangeInVelocity()->Int {
        return velocity - initialVelocity
    }
}
