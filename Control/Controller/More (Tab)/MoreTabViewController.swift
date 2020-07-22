//
//  MoreTabViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class MoreTabViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func categoriesButton(_ sender: UIButton) {
        performSegue(withIdentifier: "categories", sender: self)
    }
    
    
    @IBAction func savingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "savings", sender: self)
    }
    
}

