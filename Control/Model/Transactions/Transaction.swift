//
//  Transaction.swift
//  Control
//
//  Created by Gabriela Neme on 29/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//
import Foundation
import RealmSwift

enum TransactionType: String {
    case expense
    case income
    case saving
    case creditCardExpense
    case creditCardPayment
    case transfer
}


class Transaction: Object {
    
    private dynamic var privateType: String = ""
    var type: TransactionType {
        get{
            if let transactionType = TransactionType(rawValue: privateType){
                return transactionType
            } else {
                return .expense
            }
        }
        set{
            privateType = newValue.rawValue
        }
    }
    
    @objc dynamic var value: Double = 0.00
    @objc dynamic var transactionDate: Date = Date()
    
    @objc dynamic var fromAccount: Account? = nil
    @objc dynamic var toAccount: Account? = nil
    
    @objc dynamic var name: String = ""
    @objc dynamic var details: String = ""
    
    @objc dynamic var category: String? = nil
    @objc dynamic var subcategory: String? = nil
    
    @objc dynamic var automaticPost: Bool = true
    @objc dynamic var posted: Bool = true
    
    //credit card variables
    @objc dynamic var paymentDate: Date = Date()
    @objc dynamic var inInstallments: Bool = false
    dynamic var currentInstallment: Int? = nil
    dynamic var numberOfInstallments: Int? = nil
    dynamic var inInstallmentPurchaseID: Int? = nil
    

    

    
    func edit(changeTo creditCard: CreditCard){
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                //self.name = creditCard.name
                
            }
        }catch{
            print("Error saving new account: \(error)")
        }
        
    }
    
}
