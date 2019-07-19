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
    var latteImageData = ["HeartLatteMenu", "TulipLatteMenu", "RosettaLatteMenu"]
    var titleData = ["Heart", "Latte", "Rosetta"]
    var subtitleData = ["Easy", "Medium", "Hard"]
    var starFilledData = "StarFilled"
    var starEmptyData = "StarEmpty"
    
    @IBOutlet weak var menuCollectionView: GeminiCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentInset()
        
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
    //    var colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! CollectionViewCell
        cell.cupMenuImage.image = UIImage(named: latteImageData[indexPath.row])
        cell.latteArtMenuTitle.text = titleData [indexPath.item]
        cell.latteArtMenuSubtitle.text = subtitleData[indexPath.item]
        cell.backgroundMenuView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8235294118, blue: 0.7764705882, alpha: 1)
        cell.backgroundMenuView.layer.cornerRadius = 25
        cell.backgroundMenuView.layer.masksToBounds = true
        //        cell.backgroundColor = colors[indexPath.row]
        cell.style()
        //        cell.backgroundColor = UIColor.red
        
        //Animate
        self.menuCollectionView.animateCell(cell)
        
        return cell
    }
    
    /**Configure content inset in collection view*/
    func contentInset() {
        menuCollectionView.contentInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        performSegue(withIdentifier: "heartSegue", sender: indexPath)
    //    }
    
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
        //        let generator = UIImpactFeedbackGenerator(style: .light)
        //        generator.prepare()
        //        generator.impactOccurred()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //        let generator = UIImpactFeedbackGenerator(style: .medium)
        //        generator.prepare()
        //        generator.impactOccurred()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        
        
        //                let pageWidht:CGFloat = 200.0 + 30.0
        //                let currentOffset = scrollView.contentOffset.x
        //                let targetOffset = CGFloat(targetContentOffset.pointee.x)
        //                var newTargetOffset:CGFloat = 0.0
        //
        //                if targetOffset > currentOffset {
        //                    newTargetOffset = CGFloat(ceilf(Float((currentOffset / pageWidht) * pageWidht)))
        //                }
        //                else {
        //                    newTargetOffset = CGFloat(floorf(Float((currentOffset / pageWidht) * pageWidht)))
        //                }
        //
        //                if newTargetOffset < 0.0 {
        //                    newTargetOffset = 0.0
        //                }
        //                else if newTargetOffset > scrollView.contentSize.width {
        //                    newTargetOffset = scrollView.contentSize.width
        //                }
        //                targetContentOffset.pointee = CGPoint(x: newTargetOffset, y: 0.0)
        
        let layout = self.menuCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = view.frame.width * 0.75
        let cellWidthIncludingSpacing = cellWidth + 20
        
        
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        //        let visibleWidth = scrollView.bounds.size.width
        //            - scrollView.contentInset.left
        //            - scrollView.contentInset.right
        //
        //        offset = CGPoint(
        //            x: roundedIndex * cellWidthIncludingSpacing
        //                - scrollView.contentInset.left
        //                + layout.itemSize.width / 2
        //                - visibleWidth / 2,
        //            y: -scrollView.contentInset.top
        //        )
        
        //        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left + cellWidthIncludingSpacing / 2 - scrollView.bounds.size.width / 2, y: -scrollView.contentInset.top)
        // cellwidth : 310,5 - 50
        print(view.frame.width)
        print(cellWidth)
        print(offset.x)
        print(roundedIndex)
        print(roundedIndex * cellWidthIncludingSpacing)
        
        if roundedIndex == 0{
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - 50, y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
        if roundedIndex == 1 {
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - 72.5, y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
        if roundedIndex == 2{
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing, y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.75
        let height = view.frame.height * 0.7
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "artTutorial") as! ArtController
        
        
        controller.getArt = titleData[indexPath.row]
        controller.setFlag = indexPath.row
        
//        self.navigationController?.show(controller, sender: nil)
        
        transitionRight()
        self.present(controller, animated: false, completion: nil)
        
    }
    
    func transitionRight(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition,forKey: kCATransition)
    }
    
}
