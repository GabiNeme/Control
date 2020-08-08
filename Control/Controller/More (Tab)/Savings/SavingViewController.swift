//
//  SavingViewController.swift
//  Control
//
//  Created by Gabriela Neme on 27/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

class SavingViewController: UIViewController {
   
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalValueLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var transactionTableViewHeight: NSLayoutConstraint!
    
    let realm = try! Realm()
    
    var saving: Saving?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        iconColorImageView.layer.cornerRadius = 25
        loadSaving()
    }

    override func updateViewConstraints() {
        
        transactionTableViewHeight.constant = transactionTableView.contentSize.height
        super.updateViewConstraints()
    }
    
    func loadSaving(){
        if let currentSaving = saving {
            title = currentSaving.name
            iconImageView.image = IconImage(typeString: currentSaving.iconType, name: currentSaving.iconImage).getImage()
            iconColorImageView.backgroundColor = UIColor(named: currentSaving.iconColor)
            
            if currentSaving.savingGoal == 0 {
                goalLabel.isHidden = true
                goalValueLabel.isHidden = true
                
            }else{
                goalLabel.isHidden = false
                goalValueLabel.isHidden = false
                goalValueLabel.text = currentSaving.savingGoal.toCurrency()
            }
            
            savingsLabel.text = currentSaving.saved.toCurrency()
        }
    }


    
}

//MARK: - Edit account

extension SavingViewController: setSavingDelegate{

    
    
    @IBAction func editSaving(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editSaving", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSaving" {
            let destination = segue.destination as! SetSavingViewController
            destination.delegate = self
            destination.editingSaving = saving
        }
    }
    
    func savingDataChaged() {
        loadSaving()
    }
    

    
}

extension SavingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transactionCell")
        
        cell?.textLabel?.text = "Teste"
        return cell!
    }
    
}

extension SavingViewController: UITableViewDelegate{
    
}



