//
//  SavingTableViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 22/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit


class SavingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconColorImageView: UIImageView!
    
    @IBOutlet weak var savingNameLabel: UILabel!
    
    
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var savingGoalLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    @IBOutlet weak var savedProgressView: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconColorImageView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
