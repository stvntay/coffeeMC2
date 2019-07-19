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
    
    var getArtType: String?
   
    var milkJar = SKSpriteNode()
    var cup = SKSpriteNode()
    var duration: [[Int]] = [[7,10],[6,13]]
    var titleArt: [String] = ["Heart Art","Tulip Art"]
    var timerLbl = SKLabelNode()
    var tutorialNotes = SKLabelNode()
    var titleLbl = SKLabelNode()
    
    var blur = SKSpriteNode()
    var tutorialBackground = SKSpriteNode()
    
//    var pourMilkJar: SKTexture?
//    var tiltMilkJar: SKTexture?
    
    
    override func didMove(to view: SKView) {
        
        self.initialization()
        //startTutorial()
        //startMotion(MotionManager: motionManager!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func initialization(){
        
        print("initialization getting called")
        
        milkJar = childNode(withName: "milkJar") as! SKSpriteNode
        cup = childNode(withName: "cup") as! SKSpriteNode
        timerLbl = childNode(withName: "Timer") as! SKLabelNode
        titleLbl = childNode(withName: "titleArt") as! SKLabelNode
        tutorialNotes = childNode(withName: "tutorialNotes") as! SKLabelNode
        tutorialBackground = childNode(withName: "tutorialBackground") as! SKSpriteNode
        
//        pourMilkJar = SKTexture(imageNamed: "Milk Jug")
//        tiltMilkJar = SKTexture(imageNamed: "Milk Jug (Top)")
        
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
    
    
    
    func ChangeMilkJarPosition(milkJarPosition : SKTexture){
        milkJar.texture = milkJarPosition
        
    }

    func setPositionX(positionX: CGFloat,add: CGFloat){
        milkJar.position.x = positionX + add
    }
    
    func setPositionY(positionY: CGFloat,add: CGFloat){
        milkJar.position.y = positionY + add
    }
    
    
    func setTimerLbl(time: String){
        timerLbl.text = time
    }
    
    func setNotes(text: String){
        tutorialNotes.text = text
    }
    
    func setTitle(text: String){
        titleLbl.text = text
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Test", message: "apasih", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert)
    }
}




