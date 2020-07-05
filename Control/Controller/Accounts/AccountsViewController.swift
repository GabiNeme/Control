//
//  FirstViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var accountsTableView: UITableView!
  
    @IBOutlet weak var totalAccounts: UILabel!
    
    //temporary variable to store accounts
    //used while database is not implemented
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTableView.dataSource = self
        accountsTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        accountsTableView.rowHeight = 50
        
        loadAccountData()
    }

    @IBAction func adicionarContaPressionoado(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewAccount", sender: self)
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
        
        print(account.name)
        return accountCell
        
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
