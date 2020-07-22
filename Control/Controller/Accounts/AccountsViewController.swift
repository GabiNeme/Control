//
//  FirstViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import RealmSwift

class AccountsViewController: UIViewController {

    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var accountsTableView: UITableView!
    
    @IBOutlet weak var totalBalanceValue: UILabel!
    @IBOutlet weak var savingsValue: UILabel!
    @IBOutlet weak var availableBalance: UILabel!
    
    let realm = try! Realm()
    
    var accounts: Results<Account>?
    var existsAccountNotAddedToTotal: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        accountsTableView.dataSource = self
        accountsTableView.delegate = self
        
        accountsTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        accountsTableView.rowHeight = 70
        
        accounts = realm.objects(Account.self).sorted(byKeyPath: "listPosition")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAccountData()
    }

    
    @IBAction func addAccountPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewAccount", sender: self)
    }
    
    @IBAction func editAccountsPressed(_ sender: UIBarButtonItem) {
        
        accountsTableView.setEditing(!accountsTableView.isEditing, animated: true)
        
        addButton.isEnabled = !addButton.isEnabled
        
        if accountsTableView.isEditing {
            editButton.image = nil
        } else {
            editButton.image = UIImage(systemName: "square.and.pencil")
        }
        
    }
    
}

//MARK: - UITableViewDataSource

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let accountCell = accountsTableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        
        if let account = accounts?[indexPath.row] {
            accountCell.iconImageView.image = IconImage(typeString: account.iconType, name: account.iconImage).getImage()
            accountCell.iconColorImageView.backgroundColor = UIColor(named: account.iconColor)
            
            if existsAccountNotAddedToTotal && account.addToTotal {
                accountCell.addedToTotalIndicator.isHidden = false
            }else{
                accountCell.addedToTotalIndicator.isHidden = true
            }
            
            accountCell.accountName.text = account.name
            accountCell.accountBalance.text = account.balance.toCurrency()
            accountCell.accountSavings.text = account.savings.toCurrency()
            accountCell.accountFree.text = account.available.toCurrency()
        }
        
        return accountCell
    }
}

//MARK: - UITableViewDelegate

extension AccountsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let account1 = accounts?[sourceIndexPath.row], let account2 = accounts?[destinationIndexPath.row] {
            AccountsModel().swapAccounts(account1: account1, account2: account2)
        }

        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let account = accounts?[indexPath.row] {
                account.delete()
            }
        }
        loadAccountData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewAccount", sender: self)
    }
    
}

//MARK: - Add new account

extension AccountsViewController: setAccountDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewAccount" {
            let addNewAccountViewController = segue.destination as! SetAccountViewController
            addNewAccountViewController.delegate = self
            
        }else if segue.identifier == "viewAccount" {
            let accountViewController = segue.destination as! AccountViewController
            
            if let indexPath = accountsTableView.indexPathForSelectedRow, let account = accounts?[indexPath.row] {
                accountViewController.account = account
            }
            
            
        }
    }
    
    func accountDataChaged() {
        loadAccountData()
    }

}

//MARK: - Compute account values

extension AccountsViewController {
    
    func loadAccountData(){
        existsAccountNotAddedToTotal = AccountsModel().existsAccountNotAddedToTotal()
        
        accountsTableView.reloadData()
        computeTotalAccounts()
    }
    
    
    func computeTotalAccounts(){
        var total = 0.00
        var savings = 0.00
        var available = 0.00
        
        if let existingAccounts = accounts {
            for account in existingAccounts {
                if account.addToTotal{
                    total += account.balance
                    savings += account.savings
                    available += account.available
                }
            }
        }

        totalBalanceValue.text = total.toCurrency()
        savingsValue.text = savings.toCurrency()
        availableBalance.text = available.toCurrency()
    }
    
    
}
