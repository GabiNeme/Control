//
//  SavingsViewController.swift
//  Control
//
//  Created by Gabriela Neme on 22/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

class SavingsViewController: UIViewController {

    @IBOutlet weak var savingsTableView: UITableView!
    
    @IBOutlet weak var savingsValue: UILabel!
    
    let realm = try! Realm()
    
    var savings: Results<Saving>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        savingsTableView.dataSource = self
        savingsTableView.delegate = self
        
        savingsTableView.register(UINib(nibName: "SavingTableViewCell", bundle: nil), forCellReuseIdentifier: "savingCell")
        savingsTableView.rowHeight = 70
        
        
        savings = realm.objects(Saving.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavingsData()
    }

    
    @IBAction func addSavingPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewSaving", sender: self)
    }
        
}

//MARK: - UITableViewDataSource

extension SavingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let savingCell = savingsTableView.dequeueReusableCell(withIdentifier: "savingCell", for: indexPath) as! SavingTableViewCell

        if let saving = savings?[indexPath.row] {
            savingCell.iconImageView.image = IconImage(typeString: saving.iconType, name: saving.iconImage).getImage()
            savingCell.iconColorImageView.backgroundColor = UIColor(named: saving.iconColor)

            if saving.savingGoal > 0 {
                savingCell.savedProgressView.isHidden = false
                var progress = saving.saved / saving.savingGoal
                if progress > 1 {
                    progress = 1
                }
                savingCell.savedProgressView.setProgress(Float(progress), animated: true)
                
                savingCell.savingGoalLabel.isHidden = false
                savingCell.savingGoalLabel.text = saving.savingGoal.toCurrency()
                
                savingCell.goalTitleLabel.isHidden = false
            }else{
                savingCell.savedProgressView.isHidden = true
                
                savingCell.savingGoalLabel.isHidden = true
                savingCell.goalTitleLabel.isHidden = true
            }

            savingCell.savingNameLabel.text = saving.name
            savingCell.savedLabel.text = saving.saved.toCurrency()
        }

        return savingCell
    }
}

//MARK: - UITableViewDelegate

extension SavingsViewController: UITableViewDelegate {
    
      
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            if let saving = savings?[indexPath.row] {
//                AccountsModel().deleteAccount(account: account)
//            }
        }
        loadSavingsData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "viewSaving", sender: self)
    }
    
}

//MARK: - Add new account

extension SavingsViewController: setAccountDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addNewAccount" {
//            let addNewAccountViewController = segue.destination as! SetAccountViewController
//            addNewAccountViewController.delegate = self
//
//        }else if segue.identifier == "viewAccount" {
//            let accountViewController = segue.destination as! AccountViewController
//
//            if let indexPath = savingsTableView.indexPathForSelectedRow, let account = savings?[indexPath.row] {
//                accountViewController.account = account
//            }
//
//
//        }
    }
    
    func accountDataChaged() {
        loadSavingsData()
    }

}

//MARK: - Compute account values

extension SavingsViewController {
    
    func loadSavingsData(){
        savingsTableView.reloadData()
        computeTotalAccounts()
    }
    
    
    func computeTotalAccounts(){
        //var total = 0.00
        
//        if let existingSavings = savings {
//            for saving in existingSavings {
//
//                    total += account.balance
//                    savings += account.savings
//                    available += account.available
//                }
//            }
//        }
//
//        totalBalanceValue.text = total.toCurrency()
//        savingsValue.text = savings.toCurrency()
//        availableBalance.text = available.toCurrency()
    }
    
    
}

