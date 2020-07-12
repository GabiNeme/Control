//
//  IconImageCollectionViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 12/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class IconImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    static let identifier = "iconImageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "IconImageCollectionViewCell", bundle: nil)
    }
}
