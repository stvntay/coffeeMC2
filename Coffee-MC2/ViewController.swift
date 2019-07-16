//
//  ViewController.swift
//  Coffee-MC2
//
//  Created by Andre Elandra on 15/07/19.
//  Copyright © 2019 Andre Elandra. All rights reserved.
//

import UIKit
import Gemini

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var menuImageData = "MenuBg"
    var latteImageData = ["HeartLatteMenu", "TulipLatteMenu", "TulipLatteMenu"]
    var titleData = ["Heart", "Latte", "Rosetta"]
    var subtitleData = ["Easy", "Medium", "Hard"]
    var starFilledData = "StarFilled"
    var starEmptyData = "StarEmpty"
    
    @IBOutlet weak var menuCollectionView: GeminiCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.showsVerticalScrollIndicator = false
        menuCollectionView.showsHorizontalScrollIndicator = false
        
        // Configure animations
        menuCollectionView.gemini
            .scaleAnimation()
            .scale(0.75)
            .scaleEffect(.scaleUp)
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! CollectionViewCell
        
        cell.cupMenuImage.image = UIImage(named: latteImageData[indexPath.row])
       cell.latteArtMenuTitle.text = titleData [indexPath.item]
        cell.latteArtMenuSubtitle.text = subtitleData[indexPath.item]
        cell.style()
        cell.backgroundColor = UIColor.red
        
        //Animate
        self.menuCollectionView.animateCell(cell)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Animate
        self.menuCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Animate
        if let cell = cell as? CollectionViewCell {
            self.menuCollectionView.animateCell(cell)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        <#code#>
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
//    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
//        <#code#>
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.75
        let height = view.frame.height * 0.7
        
        return CGSize(width: width, height: height)
    }

}

