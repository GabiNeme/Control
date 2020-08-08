//
//  SubcategorySelectionViewController.swift
//  Control
//
//  Created by Gabriela Neme on 30/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

protocol SelectSubcategoryDelegate {
    func subcategorySelected(category: String)
}

class SubcategorySelectionViewController: UIViewController {
    let realm = try! Realm()
    
    var parentCategory: Category!
    var selectedSubcategoryName: String = ""
    var subcategories: Results<Subcategory>?
    
    var delegate: SelectSubcategoryDelegate!
    
    var subcategoriesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subcategories = parentCategory?.subcategories.sorted(byKeyPath: "name", ascending: true)
        
        subcategoriesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 150, height: 10), collectionViewLayout: UICollectionViewFlowLayout())
        subcategoriesCollectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        subcategoriesCollectionView.delegate = self as UICollectionViewDelegate
        subcategoriesCollectionView.dataSource = self as UICollectionViewDataSource
        
        self.view.addSubview(subcategoriesCollectionView)

        setCollectionViewProperties()
        
    }
    
    func setCollectionViewProperties(){
        
        subcategoriesCollectionView.backgroundColor = UIColor(named: "BoxesBackgroundColor")

        subcategoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        subcategoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        subcategoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        subcategoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        subcategoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        if let flowLayout = subcategoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        

    }
    
}

//MARK: - Collection view Layout

extension SubcategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 85)
    }
    
}

//MARK: - Collection View Data Source

extension SubcategorySelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (subcategories?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        if indexPath.row == subcategories?.count { //last cell
            cell.iconColorImageView.image = UIImage(systemName: "plus.circle")
            cell.iconImageView.image = nil
            cell.iconColorImageView.backgroundColor = nil
            cell.categoryNameLabel.text = "Nova"
            cell.deselect()
            return cell
        }
        
        if let category = subcategories?[indexPath.row]{
            cell.categoryNameLabel.text = category.name
            
            cell.iconImageView.image = IconImage(typeString: category.iconType, name: category.iconImage).getImage()
            cell.iconColorImageView.image = nil
            cell.iconColorImageView.backgroundColor = UIColor(named: parentCategory.iconColor)
            
            if selectedSubcategoryName == subcategories?[indexPath.row].name {
                cell.select()
            }else{
                cell.deselect()
            }
        }
        
        return cell
    }
    
}

//MARK: - Collection View Delegate

extension SubcategorySelectionViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == subcategories?.count{
            addNewAccountPressed()
            return
        }
        if let subcategoryName = subcategories?[indexPath.row].name {
            selectedSubcategoryName = subcategoryName
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell{
            cell.select()
        }
        delegate.subcategorySelected(category: selectedSubcategoryName)
        collectionView.reloadData()
    }
    
}


//MARK: - Add new Subcategory

extension SubcategorySelectionViewController: setSubcategoryDelegate {
    func addNewAccountPressed(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setSubcategoryViewController = storyboard.instantiateViewController(identifier: "setSubcategoryViewController") as! SetSubcategoryViewController
        
        setSubcategoryViewController.delegate = self
        setSubcategoryViewController.parentCategory = parentCategory
        
        self.present(setSubcategoryViewController, animated: true, completion: nil)
    }
    
    func subcategoryDataChaged() {
        subcategoriesCollectionView.reloadData()
    }
    
    
}

