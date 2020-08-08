//
//  CreditCardsViewController.swift
//  Control
//
//  Created by Gabriela Neme on 27/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

class CreditCardsViewController: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var creditCardsTableView: UITableView!
    
    
    let realm = try! Realm()
    
    private var creditCards: Results<CreditCard>?
    
    private var creditCardModifyType: ObjectModifyType = .add
    private var creditCardIndexToEdit: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        creditCardsTableView.dataSource = self
        creditCardsTableView.delegate = self
        
        creditCardsTableView.register(CreditCardTableViewCell.nib(), forCellReuseIdentifier: CreditCardTableViewCell.identifier)
        creditCardsTableView.rowHeight = 70
        
        creditCards = realm.objects(CreditCard.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        creditCardsTableView.reloadData()
    }

    
    @IBAction func addCreditCardPressed(_ sender: UIBarButtonItem) {
        creditCardModifyType = .add
        performSegue(withIdentifier: "setCreditCard", sender: self)
    }
    
    @IBAction func editCreditCardsPressed(_ sender: UIBarButtonItem) {
        reorderAndEditAccounts()
    }
    
}

//MARK: - UITableViewDataSource

extension CreditCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let creditCardCell = tableView.dequeueReusableCell(withIdentifier: CreditCardTableViewCell.identifier, for: indexPath) as! CreditCardTableViewCell
        
        
        if let card = creditCards?[indexPath.row] {
            creditCardCell.iconImageView.image = IconImage(typeString: card.iconType, name: card.iconImage).getImage()
            creditCardCell.iconColorImageView.tintColor = UIColor(named: card.iconColor)
            
            creditCardCell.nameLabel.text = card.name
            creditCardCell.invoiceValueLabel.text = (0.00).toCurrency() //TODO
            creditCardCell.payedValueLabel.text = (0.00).toCurrency() //TODO
        }
        
        return creditCardCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - UITableViewDelegate

extension CreditCardsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

//        if let account1 = creditCards?[sourceIndexPath.row], let account2 = creditCards?[destinationIndexPath.row] {
//            AccountsModel().swapAccounts(account1: account1, account2: account2)
//        }


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "viewCreditCard", sender: self)
    }
    
}


//MARK: - Swipe tableview methods

extension CreditCardsViewController {
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return TrailingSwipeForEditAndDelete().get(
            editHandler: { (_, _, complete) in
                complete(true)
                self.editCreditCard(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_, _, complete) in
                complete(true)
                self.deleteCreditCard(indexPathRow: indexPath.row)
            })

    }
    
}

//MARK: - Haptic/Force Touch menu

extension CreditCardsViewController {

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return HepticTouchForEditAndDelete().get(
            editHandler: { (_) in
                self.editCreditCard(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_) in
                self.deleteCreditCard(indexPathRow: indexPath.row)
            })
        
    }
    
    
}


extension CreditCardsViewController {
    //MARK: - Delete account
    
    func deleteCreditCard(indexPathRow: Int){
        let alert = UIAlertController(title: "Tem certeza que deseja apagar esse cartão?", message: "?????.", preferredStyle: .alert) //TODO

        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { (action) in
            if let account = self.creditCards?[indexPathRow]{
                account.delete()
                self.creditCardsTableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .automatic)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    
    //MARK: - Edit account
    
    func editCreditCard(indexPathRow: Int) {
        self.creditCardIndexToEdit = indexPathRow
        creditCardModifyType = .edit
        performSegue(withIdentifier: "setCreditCard", sender: self)
    }
    
    func reorderAndEditAccounts(){
        creditCardsTableView.setEditing(!creditCardsTableView.isEditing, animated: true)

        addButton.isEnabled = !addButton.isEnabled

        if creditCardsTableView.isEditing {
            editButton.image = nil
        } else {
            editButton.image = UIImage(systemName: "square.and.pencil")
        }
    }
    
}


//MARK: - Add new account

extension CreditCardsViewController: setCreditCardDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setCreditCard" {
            let setCreditCardViewController = segue.destination as! SetCreditCardViewController
            setCreditCardViewController.delegate = self

            if creditCardModifyType == .edit {
                if let index = self.creditCardIndexToEdit,
                    let creditCard = creditCards?[index] {
                    setCreditCardViewController.editingCreditCard = creditCard
                }
            }

        }//else if segue.identifier == "viewAccount" {
//            let accountViewController = segue.destination as! AccountViewController
//
//            if let indexPath = creditCardsTableView.indexPathForSelectedRow, let account = creditCards?[indexPath.row] {
//                accountViewController.account = account
//            }
//
//
//        }
    }
    
    
    func creditCardDataChaged() {
        creditCardsTableView.reloadData()
    }

}

