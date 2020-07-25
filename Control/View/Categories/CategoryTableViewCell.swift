//
//  CategoriesTableViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var editCategoryImageView: UIImageView!
    
    static let identifier = "categoryCell"
      
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconColorImageView.layer.cornerRadius = 20
        editCategoryImageView.isHidden = true
    }

    static func nib() -> UINib {
        return UINib(nibName: "CategoryTableViewCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
