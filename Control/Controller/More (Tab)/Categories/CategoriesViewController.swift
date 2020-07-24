//
//  CategoriesViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    let realm = try! Realm()
    var type: String = "expense"
    var categories: Results<Category>?
    
    var categoryModifyType: ObjectModifyType = .add
    var categoryIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        categoriesTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        categoriesTableView.rowHeight = 50
        
        categories = realm.objects(Category.self).filter(NSPredicate(format: "type = %@", type)).sorted(byKeyPath: "name")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoriesTableView.reloadData()
    }

}

//MARK: - Category Types - expense, income

extension CategoriesViewController {
    
    
    @IBAction func categoryTypeSegmentedControlPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            type = "expense"
        }else{
            type = "income"
        }
        categories = realm.objects(Category.self).filter(NSPredicate(format: "type = %@", type)).sorted(byKeyPath: "name")
        categoriesTableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        categoryCell.accessoryType = .disclosureIndicator

        if let category = categories?[indexPath.row] {
            categoryCell.iconImageView.image = IconImage(typeString: category.iconType, name: category.iconImage).getImage()
            categoryCell.iconColorImageView.backgroundColor = UIColor(named: category.iconColor)

            categoryCell.categoryNameLabel.text = category.name
        }

        return categoryCell
    }
}

//MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                category.delete()
            }
        }
        categoriesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "subcategories", sender: self)
    }
    
}

//MARK: - Swipe tableview methods

extension CategoriesViewController {
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, complete) in
            complete(true)
            self.editCategory(indexPathRow: indexPath.row)

        }
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complete) in
            complete(true)
            if let category = self.categories?[indexPath.row] {
                category.delete()
            }

        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    

}

//MARK: - Haptic/Force Touch menu

extension CategoriesViewController {

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let editAction = UIAction(title: "Editar", image: UIImage(systemName: "square.and.pencil")) { _ in
            self.editCategory(indexPathRow: indexPath.row)
        }

        let deleteAction = UIAction(title: "Apagar", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.deleteCategory(indexPathRow: indexPath.row)
        }

        let contextMenu = UIContextMenuConfiguration( identifier: nil, previewProvider: nil) { _ in

            return UIMenu(title: "", image: nil, children: [editAction, deleteAction])
        }

        return contextMenu
    }
    
    
}


//MARK: - Add new category

extension CategoriesViewController: setCategoryDelegate {


    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategory" {
            let destinationSegue = segue.destination as! SetCategoryViewController
            destinationSegue.delegate = self
            
            if categoryModifyType == .add {
                destinationSegue.categoryType = type
            }else{
                if let index = categoryIndexToEdit, let category = categories?[index] {
                    destinationSegue.editingCategory = category
                }
            }
        }else if segue.identifier == "subcategories"{
            let destinationSegue = segue.destination as! SubcategoriesViewController
            
            if let indexPath = categoriesTableView.indexPathForSelectedRow, let category = categories?[indexPath.row] {
                destinationSegue.category = category
            }
        }
    }
    
    func categoryDataChaged() {
        categoriesTableView.reloadData()

    }
    
}

extension CategoriesViewController {
    //MARK: - Edit category
    func editCategory(indexPathRow: Int){
        self.categoryIndexToEdit = indexPathRow
        self.categoryModifyType = .edit
        
        performSegue(withIdentifier: "editCategory", sender: self)
    }
    
    
    //MARK: - Delete category
    func deleteCategory(indexPathRow: Int){
        if let category = categories?[indexPathRow] {
            category.delete()
        }
        
        categoriesTableView.reloadData()
    }

    
}
