//
//  ExpenseIncomeSavingViewController.swift
//  Control
//
//  Created by Gabriela Neme on 30/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import RealmSwift


class SetExpenseIncomeSavingViewController: UIViewController {
    
    @IBOutlet weak var closeBarButton: UIButton!

    @IBOutlet weak var transactionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var valueTextField: CurrencyTextField!
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var subcategoryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var autoPostStackView: UIStackView!
    @IBOutlet weak var autoPostHeight: NSLayoutConstraint!
    @IBOutlet weak var autoPostSeparatorView: UIView!
    
    @IBOutlet weak var yesterdayButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var otherDateButton: UIButton!
    
    
    var transaction: Transaction = Transaction()
    var editingTransaction: Transaction?
    var selectedAccount: Account?
    let editingContentView = EditingContentView()
    

    let realm = try! Realm()
    var categories: Results<Category>?
    var selectedCategoryIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        closeBarButton.layer.cornerRadius = 2.5
        transactionTypeSegmentedControl.apportionsSegmentWidthsByContent = true

        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        valueTextField.inputAccessoryView = toolbar

        loadScreenAccordingToTransactionType()

    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }

    
}


//MARK: - Confirm button pressed

extension SetExpenseIncomeSavingViewController{

    @IBAction func saveSubcategoryPressed(_ sender: UIButton) {

//        guard let existingDelegate = delegate else {
//            fatalError("Category delegate not set")
//        }
//
//        guard let index = selectedCategoryIndex, let selectedCategory = categories?[index] else {
//            fatalError("Selected category doesnt exist")
//        }
//
//        if subcategoryNameTextField.text == nil || subcategoryNameTextField.text == "" {
//
//            let alert = Alert(title: "Preencher nome da subcategoria", message: "A subcategoria não pode ser criada sem um nome").get()
//            present(alert, animated: true, completion: nil)
//
//            return
//        }
//
//
//        let subcategoryName = subcategoryNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        let newSubcategory = Subcategory(name: subcategoryName, iconImage: iconImage)
//
//        //If editing category
//        if let subcategory = editingSubcategory {
//            if subcategoryName != subcategory.name && CategoryModel().subcategoryNameUsed(parentCategory: selectedCategory, subcategoryName: subcategoryName){
//                showRepeatedNameAlert()
//                return
//            } else {
//                if selectedCategory.name != parentCategory.name {
//                    CategoryModel().changeParentCategory(oldSubcategory: subcategory, newSubcategory: newSubcategory, to: selectedCategory)
//                }else{
//                    subcategory.edit(newSubcategory: newSubcategory)
//                }
//            }
//
//        //if new category
//        } else{
//            if CategoryModel().subcategoryNameUsed(parentCategory: selectedCategory, subcategoryName: subcategoryName){
//                showRepeatedNameAlert()
//                return
//            }else{
//                CategoryModel().addSubcategory(category: selectedCategory, subcategory: newSubcategory)
//            }
//        }
//
//        dismiss(animated: true, completion: nil)
//        existingDelegate.subcategoryDataChaged()
    }


    func showRepeatedNameAlert(){
        let alert = Alert(title: "Nome da subcategoria repetido", message: "Já existe uma subcategoria com esse nome nessa categoria. Por favor, escolha outro nome.").get()
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Transaction Type Segmented Control
extension SetExpenseIncomeSavingViewController {
    @IBAction func transactionTypeSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transaction.type = .expense
        case 1:
            transaction.type = .income
        case 2:
            transaction.type = .saving
        case 3:
            transaction.type = .transfer
        default:
            fatalError("Tried to load screen using wrong type of transaction")
        }

        transaction.category = nil
        transaction.subcategory = nil
        loadScreenAccordingToTransactionType()
    }
}

//MARK: - Account

extension SetExpenseIncomeSavingViewController: SelectAccountDelegate {
    func accountSelected(account: Account?) {
        //selectedAccount = account
    }
}



//MARK: - Category

extension SetExpenseIncomeSavingViewController: SelectCategoryDelegate {
    func categorySelected(category: String) {
        transaction.category = category

        let parentCategory = realm.objects(Category.self).filter(NSPredicate(format: "privateType = %@ && name = %@", transaction.type.rawValue, category)).sorted(byKeyPath: "name")[0]
        
        SelectionSetter().insertSubcategorySelection(viewController: self, originView: subcategoryView, parentCategory: parentCategory, subcategory: transaction.subcategory ?? "")
        
        showSubcategory()
    }
    
    func showSubcategory(){
        view.layoutIfNeeded()
        subcategoryHeight.constant = 85
        UIView.animate(withDuration: 0.3, animations: {
             
            self.view.layoutIfNeeded()
        })
    }
    
    func hideSubcategory(){
        subcategoryView.removeAllSubviews()
        
        view.layoutIfNeeded()
        subcategoryHeight.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
             
            self.view.layoutIfNeeded()
        })
    }
    
}

//MARK: - Subcategory
extension SetExpenseIncomeSavingViewController: SelectSubcategoryDelegate {

     func subcategorySelected(category: String) {
         //toodo
     }
     
    
}

//MARK: - Date
extension SetExpenseIncomeSavingViewController: FinishedEditingDate {
    
    
    @IBAction func dateButtonPressed(_ sender: UIButton) {
        
        unselectAllDateButtons()
        
        hideAutoPostView()
        sender.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
    }
    
    
    @IBAction func otherDateButtonPressed(_ sender: UIButton) {
        editingContentView.showCalendarSelector(viewController: self, daySelected: 1)
    }
    
    func finishedEditingDate(date: Date) {

        if Calendar.current.isDateInToday(date) {
            showDatesButtons(selectButton: todayButton)
        } else if Calendar.current.isDateInYesterday(date) {
            showDatesButtons(selectButton: yesterdayButton)
        } else {
            let stringDate = DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .none)
            otherDateButton.setTitle(stringDate, for: .normal)
            hideDatesButtons()
            
            if date > Date() {
                showAutoPostView()
            }
            return
        }

        hideAutoPostView()
    }
    
    func hideDatesButtons(){
        yesterdayButton.isHidden = true
        todayButton.isHidden = true
        otherDateButton.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
    }
    
    func showDatesButtons(selectButton: UIButton){
        yesterdayButton.isHidden = false
        todayButton.isHidden = false
        unselectAllDateButtons()
        selectButton.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
        otherDateButton.setTitle("Outro", for: .normal)
    }
    
    func unselectAllDateButtons(){
        yesterdayButton.setTitleColor(.placeholderText, for: .normal)
        todayButton.setTitleColor(.placeholderText, for: .normal)
        otherDateButton.setTitleColor(.placeholderText, for: .normal)
        
    }
}

//MARK: - Automatic post
extension SetExpenseIncomeSavingViewController {
    func hideAutoPostView(){
        view.layoutIfNeeded()
        autoPostHeight.constant = 0
        autoPostStackView.isHidden = true
        autoPostSeparatorView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func showAutoPostView(){
        view.layoutIfNeeded()
        autoPostHeight.constant = 45
        autoPostStackView.isHidden = false
        autoPostSeparatorView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}


//MARK: - Layout view according to Transaction Type

extension SetExpenseIncomeSavingViewController {
    
    func loadScreenAccordingToTransactionType(){
        accountView.removeAllSubviews()
        SelectionSetter().insertAccountSelection(viewController: self, originView: accountView, account: selectedAccount)
        
        hideSubcategory()
        hideAutoPostView()
        
        switch transaction.type {
        case .expense:
            loadExpense()
        case .income:
            loadIncome()
        default:
            fatalError("Tried to load screen using wrong type of transaction")
        }
        
        

    }
    
    func loadExpense(){
        valueTextField.textColor = UIColor.red
        SelectionSetter().insertCategorySelection(viewController: self, originView: categoryView, categoryType: .expense, categoryName: transaction.category ?? "")
    }
    
    func loadIncome(){
        
        valueTextField.textColor = UIColor.green
        SelectionSetter().insertCategorySelection(viewController: self, originView: categoryView, categoryType: .income, categoryName: transaction.category ?? "")
    }
    
}
