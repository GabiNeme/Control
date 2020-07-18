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
   
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var transactionTableViewHeight: NSLayoutConstraint!
    
    let realm = try! Realm()
    
    var account: Account?{
        didSet{
            loadAccount()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        transactionTableViewHeight.constant = CGFloat(44.5 * 40.0)
    }


    func loadAccount(){
        if let currentAccount = account {
            title = currentAccount.name
            
        }
    }

}

extension AccountViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transactionCell")
        
        cell?.textLabel?.text = "Teste"
        return cell!
    }
    
}

extension AccountViewController: UITableViewDelegate{
    
}
