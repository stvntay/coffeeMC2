//
//  ArtTutorial.swift
//  Coffee-MC2
//
//  Created by Steven on 7/16/19.
//  Copyright © 2019 Andre Elandra. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class ArtTutorial: SKScene {
    
    var milkJar = SKSpriteNode()
    var cup = SKSpriteNode()
    var motionManager = CMMotionManager()
    var duration: [[Int]] = [[7,10],[6,13]]
    var titleArt: [String] = ["Heart Art","Tulip Art"]
    var timerLbl = SKLabelNode()
    var titleLbl = SKLabelNode()
    var timerShow:Timer?
    
    override func didMove(to view: SKView) {
        self.initialization()
        
    }
    
    func startTutorial(){
        timerShow = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSet), userInfo: nil, repeats: true)
        startAcceleration()
    }
    
    @objc func timerSet(_ timer:Timer){
        
        
        if time > 0 {
            time -= 1
            
        }else{
            timer.invalidate()
            self.timerShow = nil
            stopAcceleration()
            time = duration[0][0]
            timerLbl.text = "\(time)"
        }
        timerLbl.text = "\(time)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func initialization(){
        
        milkJar = childNode(withName: "milkJar") as! SKSpriteNode
        cup = childNode(withName: "cup") as! SKSpriteNode
        timerLbl = childNode(withName: "Timer") as! SKLabelNode
        titleLbl = childNode(withName: "titleArt") as! SKLabelNode
    
        
        cup.zPosition = 1
        milkJar.zPosition = 2
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        physicsBody = border
    }
    
    func startAcceleration(){
        motionManager.deviceMotionUpdateInterval = 0.01
        
        motionManager.startDeviceMotionUpdates(to: .main){ (data,error) in
//            let currentX = self.milkJar.position.x
//            let currentY = self.milkJar.position.y
            
            let velocity = 100
            
            let positionX = CGFloat(data.userAcceleration.x * velocity  * -1)
            let positionY = CGFloat(data.userAcceleration.y * velocity  * -1)
            
            self.ball.position.x += positionX
            self.ball.position.y += positionY
            
            
            
        }
    
    }
    
    func stopAcceleration(){
        motionManager.stopDeviceMotionUpdates()
    }
    
    
    
}
