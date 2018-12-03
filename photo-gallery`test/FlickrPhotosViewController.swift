//
//  FlickrPhotosViewController.swift
//  photo-gallery-test
//
//  Created by Tom Hays on 03/10/2018.
//  Copyright © 2018 Tom Hays. All rights reserved.
//

import UIKit

class FlickrPhotosViewController: UIViewController, FlickrPhotosDelegate {
    
    private let flickr = Flickr()
    
    var flickrPhotosCollectionController: FlickrPhotosCollectionController?
    var horizontalSelectorController: HorizontalSelector?
    
    @IBOutlet weak var FlickrPhotosCollectionContainerView: UIView!
    @IBOutlet weak var HorizontalSelectorContainerView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let childViewController = destination as? FlickrPhotosCollectionController {
            flickrPhotosCollectionController = childViewController
        }
        if let childViewController = destination as? HorizontalSelector {
            horizontalSelectorController = childViewController
            horizontalSelectorController?.delegate = self
        }
    }
    
    func didScrollToSection() {
        let indexPath = horizontalSelectorController?.collectionView!.indexPathsForSelectedItems?.first
        flickrPhotosCollectionController?.scrollToSection((indexPath?.item)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Flickr()
        self.view.sendSubviewToBack(HorizontalSelectorContainerView)
    }   
}

// MANAGES THE TEXTFIELD FOR QUERIES

extension FlickrPhotosViewController : UITextFieldDelegate {
    
    // Fill the searches Array in the embedded view, and reload Data 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            textField.addSubview(activityIndicator)
            activityIndicator.frame = textField.bounds
            activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text!) {
            results, error  in
            activityIndicator.removeFromSuperview()
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.flickrPhotosCollectionController?.searches.insert(results, at: 0)
                self.flickrPhotosCollectionController?.collectionView.reloadData()

                self.horizontalSelectorController?.searches.insert(results.searchTerm, at: 0)
                self.horizontalSelectorController?.collectionView!.reloadData()
            }
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}


