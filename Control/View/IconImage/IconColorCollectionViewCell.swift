//
//  IconColorCollectionViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 25/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class IconColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundColorImageView: UIImageView!
    @IBOutlet weak var selectionIndicator: UIImageView!
    
    static let identifier = "iconColorCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColorImageView.layer.cornerRadius = 20
        
        selectionIndicator.layer.cornerRadius = 15
        selectionIndicator.layer.borderWidth = 3
        selectionIndicator.layer.borderColor = UIColor(named: "BackgroundColor")?.cgColor
        selectionIndicator.isHidden = true
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "IconColorCollectionViewCell", bundle: nil)
    }
}
