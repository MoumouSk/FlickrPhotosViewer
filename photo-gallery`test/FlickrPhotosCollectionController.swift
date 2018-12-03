//
//  FlickrPhotosCollectionController.swift
//  photo-gallery-test
//
//  Created by Tom Hays on 08/10/2018.
//  Copyright © 2018 Tom Hays. All rights reserved.
//

import UIKit

/* THIS CLASS IS THE IMAGES COLLECTIONVIEW CONTROLLER */

class FlickrPhotosCollectionController: UICollectionViewController {
    
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 05.0, left: 05.0, bottom: 05.0, right: 05.0)
    private let itemsPerRow: CGFloat = 3
    private var contentHeight: CGFloat = 0
    
    var searches = [FlickrSearchResults]()
    var selectedPhotos = [FlickrPhoto]()
    
    func scrollToSection(_ section: Int)  {
        if let cv = self.collectionView {
            let indexPath = IndexPath(item: 1, section: section)
            if let attributes =  cv.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                
                let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - cv.contentInset.top)
                cv.setContentOffset(topOfHeader, animated:true)
            }
        }
    }
}

extension FlickrPhotosCollectionController {
    
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as IndexPath).row]
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FlickrPhotoHeaderView", for: indexPath) as! FlickrPhotoHeaderView
            headerView.FlickrHeaderLabel.text = searches[(indexPath as NSIndexPath).section].searchTerm
            headerView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            headerView.layer.borderWidth = 1
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension FlickrPhotosCollectionController : UICollectionViewDelegateFlowLayout {
    
    // DEFINE PADDING AND IMAGE SIZE AS A SQUARE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow - 5
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collection: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collection: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
