//
//  FlickrPhotoCell.swift
//  photo-gallery-test
//
//  Created by Tom Hays on 08/10/2018.
//  Copyright © 2018 Tom Hays. All rights reserved.
//

/* THIS CLASS MANAGES CELL BEHAVIOUR */

import UIKit

class FlickrPhotoCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderWidth = isSelected ? 3 : 1
            imageView.layer.borderColor = isSelected ? themeColor.cgColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        isSelected = false
    }
}
