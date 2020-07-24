//
//  CategoryCollectionViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 23/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    static let identifier = "categoryCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconColorImageView.layer.cornerRadius = 25
        
        shadowView.clipsToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 25).cgPath
        
        deselect()
    }

    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }
    
    func select(){
        shadowView.isHidden = false
        checkmarkImageView.isHidden = false
    }
    
    func deselect(){
        shadowView.isHidden = true
        checkmarkImageView.isHidden = true
        
    }  
    
}
