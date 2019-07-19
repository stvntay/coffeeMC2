//
//  ArtController.swift
//  Coffee-MC2
//
//  Created by Steven on 7/16/19.
//  Copyright © 2019 Andre Elandra. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion
import CoreML

struct MotionData{
    var acceleration: (x: String,y: String,z: String)
    var gravity: (x: String,y: String,z: String)
}

struct ModelConstants {
    static let numOfFeatures = 2
    static let predictionWindowSize = 50
    static let sensorsUpdateInterval = 0.01
    static let hiddenInLength = 200
    static let hiddenCellInLength = 200
}

class ArtController: UIViewController {
    //let tulipModel = tulip1()
    var artTutorialScene: ArtTutorial?
    var getArt: String?
    var motionManager = CMMotionManager()
    let tiltMilkJar = SKTexture(imageNamed: "Milk Jug (Top)")
    let pourMilkJar = SKTexture(imageNamed: "Milk Jug")
    var duration: [[Int]] = [[7,10],[6,13]]
    var setFlag: Int?
    var setStep: Int = 0
    var titleArt: [String] = ["Heart Art","Tulip Art"]
    var timerShow:Timer?
    var time: Int = 0
    var setSuccess: Bool = false
    var setTilt: Bool = false
    var setPour: Bool = false
    var setUndifined: Bool = true
    var currentIndexInPredictionWindow = 0
    let velocity: Double = 20
    
//    let predictionWindowDataArray = try? MLMultiArray(shape: [1 , ModelConstants.predictionWindowSize , ModelConstants.numOfFeatures] as [NSNumber], dataType: MLMultiArrayDataType.double)
//    var lastHiddenOutput = try? MLMultiArray(shape:[ModelConstants.hiddenInLength as NSNumber], dataType: MLMultiArrayDataType.double)
//    var lastHiddenCellOutput = try? MLMultiArray(shape:[ModelConstants.hiddenCellInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? SKView {
                if let scene = SKScene(fileNamed: "ArtScene") as? ArtTutorial {
                    scene.scaleMode = .aspectFill
                    //scene.initialization()
                    artTutorialScene = scene
                    //print(getArt!)
                    //scene.getArtType = getArt
                    //scene.initialization()
                    view.presentScene(scene)
                }
            view.ignoresSiblingOrder = true
        }
        
        // Do any additional setup after loading the view.
        setInit()
        startAcceleration()
     }
    
    func startTutorial(){
        
        timerShow = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSet), userInfo: nil, repeats: true)
        
    }
    
    @objc func timerSet(_ timer:Timer){
        
        
        if time > 0 {
            time -= 1
            
        }else{
            timer.invalidate()
            self.timerShow = nil
            //stopAcceleration()
            
            // harus check pake ML
            
            
            
            //hasilnya nanti
            if setSuccess{
                setStep += 1
                time = duration[setFlag!][setStep]
                artTutorialScene?.setNotes(text: "You are success to do the first step in the tutorial")
            }else{
                setStep -= 1
                time = duration[setFlag!][setStep]
                artTutorialScene?.setNotes(text: "You are Failed to do the first step , please try again")
                
            }
//            time = duration[0][0]
            
            artTutorialScene?.setPositionY(positionY: -507.734, add: 0)
            artTutorialScene?.setPositionX(positionX: 0, add: 0)
            artTutorialScene!.setTimerLbl(time: "\(time)")
            artTutorialScene!.ChangeMilkJarPosition(milkJarPosition: tiltMilkJar)
            self.setMilkJugCondition(tilt: false, pour: false, undifined: false)
        }
        artTutorialScene!.setTimerLbl(time: "\(time)")
        startDoStep(x: 0, y: 0)
    }
    
    func stopAcceleration(){
        motionManager.stopDeviceMotionUpdates()
    }
    
    func setInit(){
        
        time = duration[setFlag!][setStep]
        artTutorialScene!.setTimerLbl(time: "\(time)")
        artTutorialScene!.setTitle(text: titleArt[setFlag!])
    }
    
    func startAcceleration(){
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main){ (data,error) in
            guard let artTutorialScene = self.artTutorialScene else {
                return
            }
            guard let data = data , error == nil else{
                return
            }
            
        
                    let positionX = CGFloat(data.userAcceleration.x * self.velocity  * -1)
                    let positionY = CGFloat(data.userAcceleration.y * self.velocity  * -1)
        
        //            let x = Double(String(format: "%.2f", data.gravity.x))
        //            let y = Double(String(format: "%.2f", data.gravity.y))
        //            let z = Double(String(format: "%.2f", data.gravity.z))
        
                    let xG = data.gravity.x
                    let yG = data.gravity.y
                    let zG = data.gravity.z
                    
                    guard let setFlag = self.setFlag else{
                        return
                    }
                    

                    //tilt pour and undifined position for milk jug
                        if (yG >= -0.1 && yG <= 0.19) && (zG <= 0.0 && zG >= -1.0) {
                            //print("tilt position")
                            artTutorialScene.ChangeMilkJarPosition(milkJarPosition: self.tiltMilkJar)
                            self.setMilkJugCondition(tilt: true, pour: false, undifined: false)
                            
                        }else if (yG >= 0.18 && yG <= 0.95) && (zG  <= -0.3 && zG >= -1.0) {
                            //print("pour position")
                            artTutorialScene.ChangeMilkJarPosition(milkJarPosition: self.pourMilkJar)
                            self.setMilkJugCondition(tilt: false, pour: true, undifined: false)
                        }else{
                            //print("undifined gesture")
                            artTutorialScene.ChangeMilkJarPosition(milkJarPosition: self.tiltMilkJar)
                            self.setMilkJugCondition(tilt: false, pour: false, undifined: true)
                        }
        
        
                    //last
                    //print("X: \(xG) Y: \(yG) Z: \(zG)")
            
            // error karena dijalanin terus
            self.startDoStep(x: positionX,y: positionY)
                }
        
    }
    

    
    func startDoStep(x: CGFloat,y: CGFloat){
        if timerShow == nil{
            if setStep == 0 {
                if setTilt {
                    setStep += 1
                }
            }else if setStep == 1{
                if setPour {
                    startTutorial()
                    
                    
                }
            }else if setStep == 2{
                if setPour {
                    startTutorial()
                    
                }
            }
        }else{
            artTutorialScene!.setPositionY(positionY: artTutorialScene!.milkJar.position.y, add: y)
            artTutorialScene!.setPositionX(positionX: artTutorialScene!.milkJar.position.x, add: x)
        }
        
    }
    
    func addSampleDataUserAcceleration(sampleX: CGFloat,sampleY: CGFloat,sampleZ: CGFloat){
        
    }
    
    func setMilkJugCondition(tilt: Bool , pour: Bool , undifined: Bool){
        setTilt = tilt
        setPour = pour
        setUndifined = undifined
    }
    
    
    override var shouldAutorotate: Bool{
        return false
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}
