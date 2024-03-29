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
    
    private var accounts: Results<Account>?
    
    private var accountModifyType: ObjectModifyType = .add
    private var accountIndexToEdit: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        accountsTableView.dataSource = self
        accountsTableView.delegate = self
        
        accountsTableView.register(AccountTableViewCell.nib(), forCellReuseIdentifier: AccountTableViewCell.identifier)
        accountsTableView.rowHeight = 70
        
        accounts = realm.objects(Account.self).sorted(byKeyPath: "listPosition")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAccountData()
    }

    
    @IBAction func addAccountPressed(_ sender: UIBarButtonItem) {
        accountModifyType = .add
        performSegue(withIdentifier: "addNewAccount", sender: self)
    }
    
    @IBAction func editAccountsPressed(_ sender: UIBarButtonItem) {
        reorderAndEditAccounts()
    }
    
}

//MARK: - UITableViewDataSource

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let accountCell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as! AccountTableViewCell
        
        
        if let account = accounts?[indexPath.row] {
            accountCell.iconImageView.image = IconImage(typeString: account.iconType, name: account.iconImage).getImage()
            accountCell.iconColorImageView.backgroundColor = UIColor(named: account.iconColor)
            
            if account.addToTotal {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewAccount", sender: self)
    }
    
}


//MARK: - Swipe tableview methods

extension AccountsViewController {
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return TrailingSwipeForEditAndDelete().get(
            editHandler: { (_, _, complete) in
                complete(true)
                self.editAccount(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_, _, complete) in
                complete(true)
                self.deleteAccount(indexPathRow: indexPath.row)
            })

    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actionTitle: String = ""
        if let account = accounts?[indexPath.row]{
            if account.addToTotal {
                actionTitle = "Remover do total"
            } else {
                actionTitle = "Adicionar ao total"
            }
        }
        
        let addToTotalAction = UIContextualAction(style: .normal, title: actionTitle) { (action, view, complete) in
            complete(true)
            if let account = self.accounts?[indexPath.row],
                let cell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell{
                
                account.invertAddToTotal()
                cell.addedToTotalIndicator.isHidden = !cell.addedToTotalIndicator.isHidden
                self.computeTotalAccounts()
            }

        }
        addToTotalAction.backgroundColor = UIColor(named: "BlueButtonColor")
        return UISwipeActionsConfiguration(actions: [addToTotalAction])
    }

}

//MARK: - Haptic/Force Touch menu

extension AccountsViewController {

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let reorderAction = UIAction(title: "Reordenar contas", image: UIImage(systemName: "arrow.up.arrow.down")) { _ in
            self.reorderAndEditAccounts()
        }
        
        var actionTitle: String = ""
        guard let account = accounts?[indexPath.row] else {
            fatalError("Account not set for haptic touch")
        }
        actionTitle = account.addToTotal ? "Remover do total" : "Adicionar ao total"
        let editIncludeInTotalAction = UIAction(title: actionTitle, image: UIImage(systemName: "checkmark.circle.fill")) { _ in
            account.invertAddToTotal()
            self.loadAccountData()
        }
        
        return HepticTouchForEditAndDelete().get(
            editHandler: { (_) in
                self.editAccount(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_) in
                self.deleteAccount(indexPathRow: indexPath.row)
            },
            extraActions: [reorderAction, editIncludeInTotalAction])
        
    }
    
    
}


extension AccountsViewController {
    //MARK: - Delete account
    
    func deleteAccount(indexPathRow: Int){
        let alert = UIAlertController(title: "Tem certeza que deseja apagar essa conta?", message: "Ao apagá-la, todas as transações serão mantidas, mas o saldo total será alterado.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { (action) in
            if let account = self.accounts?[indexPathRow]{
                account.delete()
                self.accountsTableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .automatic)
                self.computeTotalAccounts()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    
    //MARK: - Edit account
    
    func editAccount(indexPathRow: Int) {
        self.accountIndexToEdit = indexPathRow
        accountModifyType = .edit
        performSegue(withIdentifier: "addNewAccount", sender: self)
    }
    
    func reorderAndEditAccounts(){
        accountsTableView.setEditing(!accountsTableView.isEditing, animated: true)

        addButton.isEnabled = !addButton.isEnabled

        if accountsTableView.isEditing {
            editButton.image = nil
        } else {
            editButton.image = UIImage(systemName: "square.and.pencil")
        }
    }
    
}


//MARK: - Add new account

extension AccountsViewController: setAccountDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewAccount" {
            let addNewAccountViewController = segue.destination as! SetAccountViewController
            addNewAccountViewController.delegate = self
            
            if accountModifyType == .edit {
                if let index = self.accountIndexToEdit,
                    let account = accounts?[index] {
                    addNewAccountViewController.editingAccount = account
                }
            }
            
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
