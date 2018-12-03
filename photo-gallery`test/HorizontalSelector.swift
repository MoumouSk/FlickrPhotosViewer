//
//  HorizontalSelector.swift
//  photo-gallery-test
//
//  Created by Tom Hays on 29/10/2018.
//  Copyright © 2018 Tom Hays. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HorizontalSelector: UICollectionViewController {
    var searches = [String]()
    var delegate: FlickrPhotosDelegate?
}

protocol FlickrPhotosDelegate {
    func didScrollToSection()
}

extension HorizontalSelector {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HorizontalSelectorCell
        cell.HorizontalSelectorCellLabel.text = searches[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected.")
        delegate!.didScrollToSection()
    }
    
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        print("Cell \(indexPath.item) selected.")
//        delegate!.didScrollToSection()
//        return true
//    }
}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

//}
