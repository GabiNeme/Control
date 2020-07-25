//
//  SubcategoriesViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

class SubcategoriesViewController: UIViewController {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var subcategoriesTableView: UITableView!
    
    let realm = try! Realm()
    var category: Category!
    var subcategories: Results<Subcategory>?
    
    var subcategoryModifyType: ObjectModifyType = .add
    var subcategoryIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subcategoriesTableView.dataSource = self
        subcategoriesTableView.delegate = self
        
        subcategoriesTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        subcategoriesTableView.rowHeight = 50
        
        iconColorImageView.layer.cornerRadius = 25
        
        guard let _ = category else{
            fatalError("Parent category not set")
        }
        
        subcategories = category?.subcategories.sorted(byKeyPath: "name", ascending: true)
        
        loadCategory()
    }
    
    func loadCategory(){
        categoryNameLabel.text = category!.name
        iconImageView.image = IconImage(typeString: category!.iconType, name: category!.iconImage).getImage()
        iconColorImageView.backgroundColor = UIColor(named: category!.iconColor)
        
    }
    
    @IBAction func editCategoryButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "editCategory", sender: self)
    }
    

}

//MARK: - Prepare for segue, return from editing category

extension SubcategoriesViewController: setSubcategoryDelegate, setCategoryDelegate {

    @IBAction func addNewSubcategory(_ sender: UIBarButtonItem) {
        subcategoryModifyType = .add
        performSegue(withIdentifier: "editSubcategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSubcategory" {
            let destinationSegue = segue.destination as! SetSubcategoryViewController
            destinationSegue.delegate = self
            destinationSegue.parentCategory = category
            
            if subcategoryModifyType == .edit {
                if let indexPathRow = subcategoryIndexToEdit, let subcategory = subcategories?[indexPathRow] {
                    destinationSegue.editingSubcategory = subcategory
                }
            }
        } else if segue.identifier == "editCategory" {
            let destinationSegue = segue.destination as! SetCategoryViewController
            destinationSegue.delegate = self
            destinationSegue.editingCategory = category
            
        }
    }

    func subcategoryDataChaged() {
        subcategoriesTableView.reloadData()
    }
    
    
    func categoryDataChaged() {
        loadCategory()
        subcategoriesTableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource

extension SubcategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = subcategoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell

        if let subcategory = subcategories?[indexPath.row] {
            categoryCell.iconImageView.image = IconImage(typeString: subcategory.iconType, name: subcategory.iconImage).getImage()
            categoryCell.iconColorImageView.backgroundColor = UIColor(named: category.iconColor)

            categoryCell.categoryNameLabel.text = subcategory.name
            
            categoryCell.editCategoryImageView.isHidden = false
        }

        
        return categoryCell
    }
}

//MARK: - UITableViewDelegate

extension SubcategoriesViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editSubcategory(indexPathRow: indexPath.row)
    }
    
}

//MARK: - Swipe tableview methods

extension SubcategoriesViewController {
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return TrailingSwipeForEditAndDelete().get(
            editHandler: { (_, _, complete) in
                complete(true)
                self.editSubcategory(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_, _, complete) in
                complete(true)
                self.deleteSubcategory(indexPathRow: indexPath.row)
            })
        
    }
    

}

//MARK: - Haptic/Force Touch menu

extension SubcategoriesViewController {

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return HepticTouchForEditAndDelete().get(
            editHandler: { (_) in
                self.editSubcategory(indexPathRow: indexPath.row)
            }, deleteHandler:  { (_) in
                self.deleteSubcategory(indexPathRow: indexPath.row)
            })
        
    }
    
    
}


extension SubcategoriesViewController {
    //MARK: - Edit subcategory
    func editSubcategory(indexPathRow: Int){
        subcategoryModifyType = .edit
        subcategoryIndexToEdit = indexPathRow
        performSegue(withIdentifier: "editSubcategory", sender: self)
        
        if let indexPath = subcategoriesTableView.indexPathForSelectedRow {
            subcategoriesTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    func deleteSubcategory(indexPathRow: Int){
        if let subcategory = subcategories?[indexPathRow] {
            subcategory.delete()
        }
        subcategoriesTableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .automatic)
    }
    
}
