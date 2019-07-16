//
//  CollectionViewCell.swift
//  Coffee-MC2
//
//  Created by Andre Elandra on 15/07/19.
//  Copyright © 2019 Andre Elandra. All rights reserved.
//

import UIKit
import Gemini

class CollectionViewCell: GeminiCell{
    
    
    
    @IBOutlet weak var backgroundMenuView: UIView!
    @IBOutlet weak var cupMenuImage: UIImageView!
    @IBOutlet weak var latteArtMenuTitle: UILabel!
    @IBOutlet weak var latteArtMenuSubtitle: UILabel!
    
    
    func style(){
        
    }
    
    func setCell(imageNamed: String) {
        cupMenuImage.image = UIImage(named: imageNamed)
    }
    
}
