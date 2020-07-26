//
//  IconImageCollectionViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 12/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class IconImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedIndicator: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    static let identifier = "iconImageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedIndicator.layer.cornerRadius = 20
        selectedIndicator.isHidden = true
    }

    static func nib() -> UINib {
        return UINib(nibName: "IconImageCollectionViewCell", bundle: nil)
    }
}
