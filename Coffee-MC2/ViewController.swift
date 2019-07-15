//
//  ViewController.swift
//  Coffee-MC2
//
//  Created by Andre Elandra on 15/07/19.
//  Copyright © 2019 Andre Elandra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var imageData = "MenuBg"
    var titleData = ["Heart", "Latte", "Rosetta"]
    var starFilledData = "StarFilled"
    var starEmptyData = "StarEmpty"
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! CollectionViewCell
        
        cell.backgroundMenuImage.image = UIImage(named: "MenuBg")
        cell.cupMenuImage.image = UIImage(named: "HeartLatteMenu")
       cell.latteArtMenuTitle.text = titleData [indexPath.item]
        cell.starImage1.image = UIImage(named: "StarFilled")
        cell.starImage2.image = UIImage(named: "StarEmpty")
        cell.starImage3.image = UIImage(named: "StarEmpty")
        
        return cell
    }

}

