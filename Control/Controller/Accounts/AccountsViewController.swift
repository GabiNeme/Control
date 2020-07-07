//
//  FirstViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var totalAccounts: UILabel!
    
    //temporary variable to store accounts
    //used while database is not implemented
    var accounts: [Account] = [
        Account(name: "Inter", balance: 500.00),
        Account(name: "Nubank", balance: 3456.97),
        Account(name: "Carteira", balance: 196.50)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTableView.dataSource = self
        accountsTableView.delegate = self
        
        accountsTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        accountsTableView.rowHeight = 50
        
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
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        
        let accountCell = accountsTableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        
        accountCell.accountName.text = account.name
        accountCell.accountBalance.text = account.balance.toCurrency()
        
        return accountCell
    }
}

//MARK: - UITableViewDelegate

extension AccountsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tempAccount = accounts[sourceIndexPath.row]
        accounts.remove(at: sourceIndexPath.row)
        accounts.insert(tempAccount, at: destinationIndexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            accounts.remove(at: indexPath.row)
            accountsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        loadAccountData()
    }
    
    
}


//MARK: - AddNewAccountDelegate

extension AccountsViewController: AddNewAccountDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationSegue = segue.destination as! AddNewAccountViewController
        destinationSegue.delegate = self
    }
    
    
    func newAccountCreated(account: Account) {
        accounts.append(account)
        loadAccountData()
    }
   
}

//MARK: - Compute account values

extension AccountsViewController {
    
    func loadAccountData(){
        accountsTableView.reloadData()
        computeTotalAccounts()
    }
    
    
    func computeTotalAccounts(){
        var total = 0.00
        
        for account in accounts {
            total += account.balance
        }
        
        totalAccounts.text = total.toCurrency()
    }
    
    
}
