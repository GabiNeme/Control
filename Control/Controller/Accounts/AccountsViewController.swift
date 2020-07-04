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
    
    //temporary variable to store accounts
    //used while database is not implemented
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTableView.dataSource = self
        accountsTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        accountsTableView.rowHeight = 50
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
        accountCell.accountBalance.text = account.balanceString
        
        
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
        accountsTableView.reloadData()
    }
   
    
}
