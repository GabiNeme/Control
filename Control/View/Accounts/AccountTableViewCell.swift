//
//  ContaTableViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconColorImageView: UIImageView!
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountSavings: UILabel!
    @IBOutlet weak var accountFree: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = .flexibleHeight
        
        iconColorImageView.layer.cornerRadius = 25
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
