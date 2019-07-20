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


class ArtController: UIViewController{
    //let tulipModel = tulip1()
    var artTutorialScene: ArtTutorial?
    var getArt: String?
    var motionManager = CMMotionManager()
    let tiltMilkJar = SKTexture(imageNamed: "Milk Jug (Top)")
    let pourMilkJar = SKTexture(imageNamed: "Milk Jug")
    var duration: [[Int]] = [[0,6,10],[0,6,13]]
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
    var gifView = SKSpriteNode()
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var setSuccessGravity = false
    var setAnimate = false
    
    let tulipModelAcc = tulipAcc()
    let tulipModelGrav = tulipGrav()
    
    let predictionWindowDataArrayAcceleration = try? MLMultiArray(shape: [1 , ModelConstants.predictionWindowSize , ModelConstants.numOfFeatures] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let predictionWindowDataArrayGravity = try? MLMultiArray(shape: [1 , ModelConstants.predictionWindowSize , ModelConstants.numOfFeatures] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    var lastHiddenOutputAcceleration = try? MLMultiArray(shape:[ModelConstants.hiddenInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    var lastHiddenOutputGravity = try? MLMultiArray(shape:[ModelConstants.hiddenInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    var lastHiddenCellOutputAcceleration = try? MLMultiArray(shape:[ModelConstants.hiddenCellInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    var lastHiddenCellOutputGravity = try? MLMultiArray(shape:[ModelConstants.hiddenCellInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    
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
        
//
//        animateGIF(gifFolder: "ForwardGIF", gifName: "forward", width: 110, height: 350, x: 30, y: Int(-80.807), z: 2, timePerFrame: 0.05)
     }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
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
                if setStep < 3 {
                    time = duration[setFlag!][setStep]
                    artTutorialScene?.setNotes(text: "You are success to do the first step in the tutorial")
                    artTutorialScene?.showAlert(controller: self, titleAlert: "Success", messageAlert: "You success to do the tutorial , continue to the other step")
                }else{
                    artTutorialScene?.setNotes(text: "You have done the tutorial")
                    artTutorialScene?.showAlert(controller: self, titleAlert: "Finished", messageAlert: "You success to do the tutorial , please choose another tutorial to mastering your latte art's skills")
                    stopAcceleration()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "mainMenu") as! ViewController
                    self.present(controller, animated: false, completion: nil)
                }
               
            }else{
//                setStep -= 1
                time = duration[setFlag!][setStep]
                artTutorialScene?.setNotes(text: "You are Failed to do the first step , please try again")
                 artTutorialScene?.showAlert(controller: self, titleAlert: "Failed", messageAlert: "You failed to do the tutorial , step restarted")
            }
//            time = duration[0][0]
            
            artTutorialScene?.setPositionY(positionY: -507.734, add: 0)
            artTutorialScene?.setPositionX(positionX: 35, add: 0)
            artTutorialScene!.setTimerLbl(time: "\(time)")
            artTutorialScene!.ChangeMilkJarPosition(milkJarPosition: tiltMilkJar)
            self.setMilkJugCondition(tilt: false, pour: false, undifined: false)
        }
        artTutorialScene!.setTimerLbl(time: "\(time)")
//        startDoStep(x: 0, y: 0)
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
        artTutorialScene?.addChild(gifView)
        gifView.zPosition = z
        
        gifView.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame:  timePerFrame)))
    }
    
    func stopAnimation(){
        gifView.removeAllActions()
        artTutorialScene?.removeChildren(in: [gifView])
        
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
            if setFlag == 1{
                self.setDataGravML(xGrav: xG, yGrav: yG, zGrav: zG)
                self.setDataAccML(x: data.userAcceleration.x , y: data.userAcceleration.y, z: data.userAcceleration.z)
            }
            
                }
        
    }
    
    func setDataAccML(x: Double , y: Double , z: Double){
        if timerShow != nil {
            guard let dataArray = predictionWindowDataArrayAcceleration else {
                return
            }
            dataArray[[0,currentIndexInPredictionWindow,0] as [NSNumber]] = x as NSNumber
            dataArray[[0 , currentIndexInPredictionWindow ,1] as [NSNumber]] = y as NSNumber
            dataArray[[0 , currentIndexInPredictionWindow ,2] as [NSNumber]] = z as NSNumber
            
            currentIndexInPredictionWindow += 1
            
            if (currentIndexInPredictionWindow == ModelConstants.predictionWindowSize) {
                let predictedActivity = performModelPredictionAcceleration() ?? "N/A"
                
                // Use the predicted activity here
                // ...
                
                if setStep == 1{
                    if predictedActivity == "Foam Pouring"{
                        setSuccess = true
                        print("Gesture Accelerometer step 1 Bener")
                    }else{
                        setSuccess = false
                    }
                }else if setStep == 2{
                    if predictedActivity == "Milk Pouring" {
                        setSuccess = true
                        print("Gesture Accelerometer step 2 Bener")
                    }else{
                        setSuccess = false
                    }
                }
                
                
                // Start a new prediction window
                currentIndexInPredictionWindow = 0
                
            }
        }
    }
    
    func performModelPredictionAcceleration () -> String? {
        guard let dataArray = predictionWindowDataArrayAcceleration else { return "Error!"}
        
        // Perform model prediction
        let modelPrediction = try? tulipModelAcc.prediction(features: dataArray, hiddenIn: lastHiddenOutputGravity, cellIn: lastHiddenCellOutputGravity)
        
        // Update the state vectors
        lastHiddenOutputGravity = modelPrediction?.hiddenOut
        lastHiddenCellOutputGravity = modelPrediction?.cellOut
        
        // Return the predicted activity - the activity with the highest probability
        return modelPrediction?.activity
    }
    
    
    func setDataGravML(xGrav: Double, yGrav: Double, zGrav: Double){
        if timerShow != nil {
                guard let dataArray = predictionWindowDataArrayGravity else {
                    return
                }
                dataArray[[0,currentIndexInPredictionWindow,0] as [NSNumber]] = xGrav as NSNumber
                dataArray[[0 , currentIndexInPredictionWindow ,1] as [NSNumber]] = yGrav as NSNumber
                dataArray[[0 , currentIndexInPredictionWindow ,2] as [NSNumber]] = zGrav as NSNumber
                
                currentIndexInPredictionWindow += 1
                
                if (currentIndexInPredictionWindow == ModelConstants.predictionWindowSize) {
                    let predictedActivity = performModelPredictionGravity() ?? "N/A"
                    
                    // Use the predicted activity here
                    // ...
                    
                    if setStep == 1{
                        if predictedActivity == "Foam Pouring"{
                            print("Gesture Gravity step 1 Bener")
                            setSuccessGravity = true
                        }else{
                            setSuccessGravity = false
                        }
                    }else if setStep == 2{
                        if predictedActivity == "Milk Pouring" {
                            setSuccessGravity = true
                            print("Gesture Gravity step 2 Bener")
                        }else{
                            setSuccessGravity = false
                        }
                    }
                    
                    
                    // Start a new prediction window
                    currentIndexInPredictionWindow = 0
                
            }
        }
    }
    
    func performModelPredictionGravity () -> String? {
        guard let dataArray = predictionWindowDataArrayGravity else { return "Error!"}
        
        // Perform model prediction
        let modelPrediction = try? tulipModelGrav.prediction(features: dataArray, hiddenIn: lastHiddenOutputGravity, cellIn: lastHiddenCellOutputGravity)
        
        // Update the state vectors
        lastHiddenOutputGravity = modelPrediction?.hiddenOut
        lastHiddenCellOutputGravity = modelPrediction?.cellOut
        
        // Return the predicted activity - the activity with the highest probability
        return modelPrediction?.activity
    }

    
    func startDoStep(x: CGFloat,y: CGFloat){
        
        if timerShow == nil{
            
            if setStep == 0 {
                if !setAnimate{
                    animateGIF(gifFolder: "TiltGIF", gifName: "tilt", width: 200, height: 300, x: 30, y: Int(-80.807), z: 2, timePerFrame: 0.2)
                    setAnimate = true
                    print("Step 0 ")
                }
                if setTilt {
                    
                    
                    setStep += 1
                    time = duration[setFlag!][setStep]
                    artTutorialScene!.setTimerLbl(time: "\(time)")
                    artTutorialScene!.setNotes(text: "Pour your milk jar to start")
                }
            }else if setStep == 1{
                if setAnimate {
                    
                    stopAnimation()
                    animateGIF(gifFolder: "RotationGIF", gifName: "rotation", width: 200, height: 300, x: 30, y: Int(-80.807), z: 2, timePerFrame: 0.2)
                    setAnimate = false
                    print("step 1")
                }
                
                if setPour {
                    startTutorial()
                    setSuccess = true
                }
            }else if setStep == 2{
                
                if !setAnimate {
                    stopAnimation()
                    
                    //give another animation
                    
                    setAnimate = false
                }
                if setPour {
                    startTutorial()
                    
                }
            }
        }else{
            artTutorialScene!.setPositionY(positionY: artTutorialScene!.milkJar.position.y, add: y)
            artTutorialScene!.setPositionX(positionX: artTutorialScene!.milkJar.position.x, add: x)
            
           

        }
        
    }
    
    // for coreMLnya
//    func addSampleDataUserAcceleration(sampleX: CGFloat,sampleY: CGFloat,sampleZ: CGFloat){
//
//    }
    
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
    
    func transitionRight(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition,forKey: kCATransition)
    }
}
