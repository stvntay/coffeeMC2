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
    var circlePath:SKShapeNode?
    var circleBezierPath: UIBezierPath?
    var linePath: UIBezierPath?
    var gifView = SKSpriteNode()
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    
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
        milkJar.zPosition = 3
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        physicsBody = border
        
    }
    
    func animateGIF(gifFolder: String, gifName: String, width: Int, height: Int, x: Int, y: Int, z: CGFloat,timePerFrame: TimeInterval) {
        textureAtlas = SKTextureAtlas(named: gifFolder)
        
        for i in 1...textureAtlas.textureNames.count{
            
            let names = "\(gifName)_\(i).png"
            textureArray.append(SKTexture(imageNamed: names))
            
        }
        
        gifView = SKSpriteNode(imageNamed: textureAtlas.textureNames[0])
        
        gifView.size = CGSize(width: width, height: height)
        gifView.position = CGPoint(x: x, y: y)
        self.addChild(gifView)
        gifView.zPosition = z
        
        gifView.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame:  timePerFrame)))
    }
    
    func stopAnimation(){
        textureArray = []
        gifView.removeAllActions()
        self.removeChildren(in: [gifView])
    }
    
//    func circularPath(){
//        circlePath = SKShapeNode(circleOfRadius: 400)
//        guard let circlePath = self.circlePath else{
//            return
//        }
//
//        circlePath.zPosition = 4
//        //circlePath.strokeColor = SKColor.white
//        self.addChild(circlePath)
//
//
//    }
    
    func liningPath(startPoint: CGPoint,endPoint: CGPoint){
        linePath = UIBezierPath()
        guard let linePath = linePath else{
            return
        }
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
    }
    
    func removeLiningpPath(){
        linePath!.removeAllPoints()
    }
    
    func removeCircular(){
        
    }

    func followPathCircle(){
        let circle = UIBezierPath(roundedRect: CGRect(x: (self.frame.width/2) - 200, y: self.frame.midY - 200, width: 400, height: 400), cornerRadius: 200)
        let circularMove = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: true, duration: 1)
        milkJar.run( SKAction.repeat(circularMove, count: 6))
    }
    
//    func removeCirclePath(){
//        guard let circlePath = self.circlePath else{
//            return
//        }
//        self.removeChildren(in: [circlePath])
//    }
    
    func moveLinePath(duration: TimeInterval){
        guard let linePath = linePath else{
            return
        }
        
        let move = SKAction.follow(linePath.cgPath, asOffset: true, orientToPath: true, duration: duration)
        milkJar.run(move)
        
    }
    
    func setWaitDuration(time: TimeInterval){
        let wait = SKAction.wait(forDuration: time)
        milkJar.run(wait)
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
    
    func showAlert(controller: UIViewController,titleAlert: String , messageAlert: String,handler : @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        controller.present(alert, animated: true)
    }
    
    func setCupCondition(cupCondition: SKTexture){
        cup.texture = cupCondition
    }
}




