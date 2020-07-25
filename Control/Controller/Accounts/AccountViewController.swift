//
//  AccountViewController.swift
//  Control
//
//  Created by Gabriela Neme on 18/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController {
   
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var addedToTotalIndicator: UIImageView!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var transactionTableViewHeight: NSLayoutConstraint!
    
    let realm = try! Realm()
    
    var account: Account?
    var existsAccountNotAddedToTotal: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        iconColorImageView.layer.cornerRadius = 25
        loadAccount()
    }

    override func updateViewConstraints() {
        
        transactionTableViewHeight.constant = transactionTableView.contentSize.height
        super.updateViewConstraints()
    }
    
    func loadAccount(){        
        if let currentAccount = account {
            title = currentAccount.name
            iconImageView.image = IconImage(typeString: currentAccount.iconType, name: currentAccount.iconImage).getImage()
            iconColorImageView.backgroundColor = UIColor(named: currentAccount.iconColor)
            
            if existsAccountNotAddedToTotal && currentAccount.addToTotal {
                addedToTotalIndicator.isHidden = false
            }else{
                addedToTotalIndicator.isHidden = true
            }
            
            
            balanceLabel.text = currentAccount.balance.toCurrency()
            savingsLabel.text = currentAccount.savings.toCurrency()
            availableLabel.text = currentAccount.available.toCurrency()
        }
    }


    
}

//MARK: - Edit account

extension AccountViewController: setAccountDelegate {
    
    
    @IBAction func editAccount(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editAccount", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAccount" {
            let destination = segue.destination as! SetAccountViewController
            destination.delegate = self
            destination.editingAccount = account
        }
    }
    
    
    func accountDataChaged() {
        loadAccount()
        
    }
    
}

extension AccountViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transactionCell")
        
        cell?.textLabel?.text = "Teste"
        return cell!
    }
    
}

extension AccountViewController: UITableViewDelegate{
    
}


