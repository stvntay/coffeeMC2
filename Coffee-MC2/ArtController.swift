//
//  ArtController.swift
//  Coffee-MC2
//
//  Created by Steven on 7/16/19.
//  Copyright © 2019 Andre Elandra. All rights reserved.
//

import UIKit

class ArtController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "ArtScene") {
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
        }

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
