//
//  SecondViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addTransactionButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "setTransaction", sender: self)
    }
    
}

