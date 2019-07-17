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

struct MotionData{
    var acceleration: (x: String,y: String,z: String)
    var gravity: (x: String,y: String,z: String)
}


class ArtTutorial: SKScene {
    
    var data: [MotionData] = []
    var milkJar = SKSpriteNode()
    var cup = SKSpriteNode()
    var motionManager = CMMotionManager()
    var duration: [[Int]] = [[7,10],[6,13]]
    var titleArt: [String] = ["Heart Art","Tulip Art"]
    var timerLbl = SKLabelNode()
    var tutorialNotes = SKLabelNode()
    var titleLbl = SKLabelNode()
    var timerShow:Timer?
    var time: Int = 0
    var blur = SKSpriteNode()
    var tutorialBackground = SKSpriteNode()
    
    let pourMilkJar = SKTexture(imageNamed: "Milk Jug")
    let tiltMilkJar = SKTexture(imageNamed: "Milk Jug (Top)")
    
    
    override func didMove(to view: SKView) {
        time = duration[0][0]
        self.initialization()
        startTutorial()
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
            //stopAcceleration()
            time = duration[0][0]
            timerLbl.text = "\(time)"
        }
        timerLbl.text = "\(time)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //X: 0.014809364452958107 Y: -0.002221374772489071 Z: -0.9998878836631775 hadep depan
    //X: 0.001009892439469695 Y: 0.013348270207643509 Z: -0.9999104142189026 hadep belakang
    
    func initialization(){
        
        milkJar = childNode(withName: "milkJar") as! SKSpriteNode
        cup = childNode(withName: "cup") as! SKSpriteNode
        timerLbl = childNode(withName: "Timer") as! SKLabelNode
        titleLbl = childNode(withName: "titleArt") as! SKLabelNode
        tutorialNotes = childNode(withName: "tutorialNotes") as! SKLabelNode
        tutorialBackground = childNode(withName: "tutorialBackground") as! SKSpriteNode
        
        
        tutorialNotes.text = "Tilt your phone first"
        tutorialBackground.zPosition = 4
        tutorialNotes.zPosition = 4
        
        timerLbl.text = "\(time)"
        
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
            guard let data = data , error == nil else{
                return
            }
            
            let velocity: Double = 50
            
            let positionX = CGFloat(data.userAcceleration.x * velocity  * -1)
            let positionY = CGFloat(data.userAcceleration.y * velocity  * -1)
            
//            let x = Double(String(format: "%.2f", data.gravity.x))
//            let y = Double(String(format: "%.2f", data.gravity.y))
//            let z = Double(String(format: "%.2f", data.gravity.z))

            let xG = data.gravity.x
            let yG = data.gravity.y
            let zG = data.gravity.z
//            guard let xG = x else{
//                return
//            }
//
//            guard let yG = y else{
//                return
//            }
//            guard let zG = z else{
//                return
//            }
            
            if (yG >= -0.1 && yG <= 0.19) && (zG <= 0.0 && zG >= -1.0) {
                print("tilt position")
                self.milkJar.texture = self.tiltMilkJar
            }else if (yG >= 0.18 && yG <= 0.95) && (zG  <= -0.3 && zG >= -1.0) {
                print("pour position")
                self.milkJar.texture = self.pourMilkJar
            }else{
                print("undifined gesture")
                self.milkJar.texture = self.tiltMilkJar
            }
            //last
            
            print("X: \(xG) Y: \(yG) Z: \(zG)")
//            self.milkJar.position.x += positionX
//            self.milkJar.position.y += positionY
            
            
            
        }
    
    }
    
    func stopAcceleration(){
        motionManager.stopDeviceMotionUpdates()
    }
    
    
    
}


