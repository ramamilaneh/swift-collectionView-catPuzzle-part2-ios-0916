//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var headerReusableView: HeaderReusableView!
    var footerReusableView: FooterReusableView!
    var sectionInsets: UIEdgeInsets!
    var spacing: CGFloat!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    var imageSlices = [UIImage]()
    var sortedImageSlices = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        self.configureLayout()
        self.createImageSlices()
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageSlices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = self.imageSlices[indexPath.item]
        
        return cell
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            headerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)) as! HeaderReusableView
            
            return headerReusableView
            
        } else {
            
            footerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)) as! FooterReusableView
            
            return footerReusableView
        }
        
    }
    
    func configureLayout() {
       let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        self.numberOfRows = 4
        self.numberOfColumns = 3
        self.spacing = 2
        self.sectionInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing)
        self.referenceSize = CGSize(width: width, height: 60)
        let itemWidth = width/3 - (spacing/2 + sectionInsets.left)
        let itemHeight = height/4 - (spacing/2 + sectionInsets.top)
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.collectionView?.performBatchUpdates({
            
            print("doing stuff")
            print(sourceIndexPath.row)
            self.footerReusableView.startTimer()
            self.footerReusableView.timerLabel.text = String(describing: self.footerReusableView.timer)
            let element = self.imageSlices[sourceIndexPath.row]
            self.imageSlices.remove(at: sourceIndexPath.row)
            self.imageSlices.append(element)
            
            
            }, completion: {completed in
                print("I am finished")
                print(self.imageSlices)
                print(self.sortedImageSlices)
                if self.imageSlices == self.sortedImageSlices {
                    self.footerReusableView.timer.invalidate()
                    
                    
                    print(self.imageSlices.count)
                    self.performSegue(withIdentifier: "solvedSegue", sender: self)
                }
        })
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SolvedViewController
        destination.image = UIImage(named: "cats")
        destination.time = self.footerReusableView.timerLabel.text

    }
    

    func createImageSlices() {
        
        for i in 1...12 {
            self.imageSlices.append(UIImage(named: String(i))!)
        }
        self.sortedImageSlices = self.imageSlices
        for i in 0...self.imageSlices.count-1 {
            let index = Int(arc4random_uniform(12))
            if i != index {
                swap(&self.imageSlices[i], &self.imageSlices[index])
            }
        }
    }
    
}
