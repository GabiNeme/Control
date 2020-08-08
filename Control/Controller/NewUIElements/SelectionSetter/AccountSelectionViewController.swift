//
//  HorizontalSelectCollectionView.swift
//  Control
//
//  Created by Gabriela Neme on 30/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectAccountDelegate {
    func accountSelected(account: Account?)
}

class AccountSelectionViewController: UIViewController {
    let realm = try! Realm()
    
    var selectedAccount: Account?
    var accounts: Results<Account>?
    
    var delegate: SelectAccountDelegate!
    
    var accountCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        accounts = realm.objects(Account.self).sorted(byKeyPath: "listPosition")
        
        accountCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 150, height: 10), collectionViewLayout: UICollectionViewFlowLayout())
        accountCollectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        accountCollectionView.delegate = self as UICollectionViewDelegate
        accountCollectionView.dataSource = self as UICollectionViewDataSource
        
        self.view.addSubview(accountCollectionView)

        setCollectionViewProperties()
        
    }
    
    func setCollectionViewProperties(){
        
        accountCollectionView.backgroundColor = UIColor(named: "BoxesBackgroundColor")

        accountCollectionView.translatesAutoresizingMaskIntoConstraints = false
        accountCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        accountCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        accountCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        accountCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        if let flowLayout = accountCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        

    }
    
    func selectCurrentAccount(){
        if let account = selectedAccount, let index = accounts?.index(of: account) {
            let indexPath = IndexPath(row: index, section: 0)
            
            accountCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
}

//MARK: - Collection view Layout

extension AccountSelectionViewController: UICollectionViewDelegateFlowLayout {
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

extension AccountSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (accounts?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        if indexPath.row == accounts?.count { //last cell
            cell.iconColorImageView.image = UIImage(systemName: "plus.circle")
            cell.iconImageView.image = nil
            cell.iconColorImageView.backgroundColor = nil
            cell.categoryNameLabel.text = "Nova"
            cell.deselect()
            return cell
        }
        
        if let account = accounts?[indexPath.row]{
            cell.categoryNameLabel.text = account.name
            
            cell.iconImageView.image = IconImage(typeString: account.iconType, name: account.iconImage).getImage()
            cell.iconColorImageView.image = nil
            cell.iconColorImageView.backgroundColor = UIColor(named: account.iconColor)
            
            if selectedAccount?.name == accounts?[indexPath.row].name {
                cell.select()
            }else{
                cell.deselect()
            }
        }
        
        return cell
    }
    
}

//MARK: - Collection View Delegate

extension AccountSelectionViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == accounts?.count{
            addNewAccountPressed()
            return
        }
        selectedAccount = accounts?[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell{
            cell.select()
        }
        delegate.accountSelected(account: selectedAccount)
        collectionView.reloadData()
    }

}


//MARK: - Add new Account

extension AccountSelectionViewController: setAccountDelegate {
    
    func addNewAccountPressed(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setAccountViewController = storyboard.instantiateViewController(identifier: "setAccountViewController") as! SetAccountViewController
        
        setAccountViewController.delegate = self
        
        self.present(setAccountViewController, animated: true, completion: nil)
    }
    
    
    func accountDataChaged() {
        accountCollectionView.reloadData()
    }
    
    
}
