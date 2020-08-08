//
//  Expense.swift
//  Control
//
//  Created by Gabriela Neme on 29/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation

extension Transaction {
    
    func initExpense(value: Double, transactionDate: Date, fromAccount: Account, name: String, details: String, category: String?, subcategory: String?, automaticPost: Bool = true, posted: Bool = true){

        self.type = .expense
        self.value = value
        
        self.transactionDate = transactionDate
        self.paymentDate = transactionDate
    
        self.fromAccount = fromAccount
    
        self.name = name
        self.details = details
    
        self.category = category
        self.subcategory = subcategory
        
        
        self.automaticPost = automaticPost
        self.posted = true
    }
    
    
}
