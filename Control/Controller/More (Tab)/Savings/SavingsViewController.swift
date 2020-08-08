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
    
    var savingModifyType: ObjectModifyType = .add
    var savingIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        savingsTableView.dataSource = self
        savingsTableView.delegate = self
        
        savingsTableView.register(SavingTableViewCell.nib(), forCellReuseIdentifier: SavingTableViewCell.identifier)
        savingsTableView.rowHeight = 70

        savings = realm.objects(Saving.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavingsData()
    }

    
    @IBAction func addSavingPressed(_ sender: UIBarButtonItem) {
        savingModifyType = .add
        performSegue(withIdentifier: "setSaving", sender: self)
    }
        
}

//MARK: - UITableViewDataSource

extension SavingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let savingCell = savingsTableView.dequeueReusableCell(withIdentifier: SavingTableViewCell.identifier, for: indexPath) as! SavingTableViewCell

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "viewSaving", sender: self)
    }
    
}

//MARK: - Swipe tableview methods

extension SavingsViewController {
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return TrailingSwipeForEditAndDelete().get(
            editHandler: { (_, _, complete) in
                complete(true)
                self.editSaving(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_, _, complete) in
                complete(true)
                self.deleteSaving(indexPathRow: indexPath.row)
            })
    
    }
    

}

//MARK: - Haptic/Force Touch menu

extension SavingsViewController {

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return HepticTouchForEditAndDelete().get(
            editHandler: { (_) in
                self.editSaving(indexPathRow: indexPath.row)
            }, deleteHandler:  { (_) in
                self.deleteSaving(indexPathRow: indexPath.row)
            })
        
    }
    
}


//MARK: - Add new account

extension SavingsViewController: setSavingDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setSaving" {
            let setSavingViewController = segue.destination as! SetSavingViewController
            setSavingViewController.delegate = self
            
            if savingModifyType == .edit {
                if let index = savingIndexToEdit, let saving = savings?[index] {
                    setSavingViewController.editingSaving = saving
                }
            }

        }
        else if segue.identifier == "viewSaving" {
            let savingViewController = segue.destination as! SavingViewController

            if let indexPath = savingsTableView.indexPathForSelectedRow, let saving = savings?[indexPath.row] {
                savingViewController.saving = saving
            }


        }
    }
    
    func savingDataChaged() {
        loadSavingsData()
    }

}


extension SavingsViewController {
    //MARK: - Edit saving
    func editSaving(indexPathRow: Int){
        savingModifyType = .edit
        savingIndexToEdit = indexPathRow
        
        performSegue(withIdentifier: "setSaving", sender: self)
    }
    
    
    
    //MARK: - Delete saving
    
    func deleteSaving(indexPathRow: Int) {
        if let saving = savings?[indexPathRow] {
            saving.delete()
        }
        savingsTableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .automatic)
        computeTotalSaving()
    }
    
    
}

//MARK: - Compute account values

extension SavingsViewController {
    
    func loadSavingsData(){
        savingsTableView.reloadData()
        computeTotalSaving()
    }
    
    
    func computeTotalSaving(){
        var total = 0.00
        
        if let existingSavings = savings {
            for saving in existingSavings {

                total += saving.saved
            }
        }

        savingsValue.text = total.toCurrency()
    }
    
    
}

