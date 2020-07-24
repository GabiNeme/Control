//
//  DefaultCategories.swift
//  Control
//
//  Created by Gabriela Neme on 21/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

struct DefaultCategories {
    
    func setDefaultCategories(){
        if !categoriesExists(){
            createCategories()
        }
    }
    
    func categoriesExists() -> Bool{
        let realm = try! Realm()
        
        let categories = realm.objects(Category.self).count
        
        return categories > 0
    }
    
    func createCategories(){
        let incomeType = "income"
        let expenseType = "expense"
        
        //Receita
        let income1 = Category(
            type: incomeType,
            name: "Trabalho",
            iconImage: IconImage(type: .external, name: "work"),
            iconColor: "blue4")
        
        let s01 = Subcategory(
            name: "Salário",
            iconImage: IconImage(type: .SFSymbol, name: "dollarsign.circle"))
        income1.subcategories.append(s01)
        
        let s02 = Subcategory(
            name: "13º salário",
            iconImage: IconImage(type: .external, name: "christmas"))
        income1.subcategories.append(s02)
        
        let s03 = Subcategory(
            name: "Férias",
            iconImage: IconImage(type: .external, name: "beach"))
        income1.subcategories.append(s03)
        
        let income2 = Category(
            type: incomeType,
            name: "Vendas",
            iconImage: IconImage(type: .external, name: "store"),
            iconColor: "orange3")
        
        let income3 = Category(
            type: incomeType,
            name: "Rendimentos",
            iconImage: IconImage(type: .external, name: "investment"),
            iconColor: "red1")
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                realm.add(income1)
                realm.add(income2)
                realm.add(income3)
            }
        }catch{
            print("Error saving incomes: \(error)")
        }
        
        
        let expense1 = Category(
            type: expenseType,
            name: "Casa",
            iconImage: IconImage(type: .SFSymbol, name: "house"),
            iconColor: "green3")
        
        let s04 = Subcategory(
            name: "Água",
            iconImage: IconImage(type: .external, name: "drop"))
            expense1.subcategories.append(s04)
        
        let s05 = Subcategory(
            name: "Luz",
            iconImage: IconImage(type: .external, name: "power"))
            expense1.subcategories.append(s05)
        
        let s06 = Subcategory(
            name: "Condomínio",
            iconImage: IconImage(type: .external, name: "apartment"))
            expense1.subcategories.append(s06)
        
        let s07 = Subcategory(
            name: "Aluguel",
            iconImage: IconImage(type: .external, name: "key"))
            expense1.subcategories.append(s07)
        
        
        let expense2 = Category(
            type: expenseType,
            name: "Contas",
            iconImage: IconImage(type: .SFSymbol, name: "barcode"),
            iconColor: "red3")
        
        let s08 = Subcategory(
            name: "Telefone",
            iconImage: IconImage(type: .SFSymbol, name: "phone"))
        expense2.subcategories.append(s08)
        
        let s09 = Subcategory(
            name: "TV",
            iconImage: IconImage(type: .SFSymbol, name: "tv"))
        expense2.subcategories.append(s09)
        
        let s10 = Subcategory(
            name: "Celular",
            iconImage: IconImage(type: .external, name: "phone_iphone"))
        expense2.subcategories.append(s10)
        
        let s11 = Subcategory(
            name: "Internet",
            iconImage: IconImage(type: .SFSymbol, name: "wifi"))
        expense2.subcategories.append(s11)
        
        let expense3 = Category(
            type: expenseType,
            name: "Automóvel",
            iconImage: IconImage(type: .SFSymbol, name: "car"),
            iconColor: "dark-gray4")
    
        let s12 = Subcategory(
            name: "Combustível",
            iconImage: IconImage(type: .external, name: "gas_station"))
        expense3.subcategories.append(s12)
        
        let s13 = Subcategory(
            name: "IPVA",
            iconImage: IconImage(type: .external, name: "lion"))
        expense3.subcategories.append(s13)
        
        let s14 = Subcategory(
            name: "Lavagem",
            iconImage: IconImage(type: .external, name: "drop"))
        expense3.subcategories.append(s14)
        
        let s15 = Subcategory(
            name: "Manutenção",
            iconImage: IconImage(type: .SFSymbol, name: "wrench"))
        expense3.subcategories.append(s15)
        
        let s16 = Subcategory(
            name: "Seguro",
            iconImage: IconImage(type: .SFSymbol, name: "lock.shield"))
        expense3.subcategories.append(s16)
        
        
        let expense4 = Category(
            type: expenseType,
            name: "Alimentação",
            iconImage: IconImage(type: .external, name: "room_service"),
            iconColor: "orange4")
        
        let s17 = Subcategory(
            name: "Restaurante",
            iconImage: IconImage(type: .external, name: "dinning"))
        expense4.subcategories.append(s17)
        
        let s18 = Subcategory(
            name: "Supermercado",
            iconImage: IconImage(type: .SFSymbol, name: "cart"))
        expense4.subcategories.append(s18)
        
        let s19 = Subcategory(
            name: "Lanche",
            iconImage: IconImage(type: .external, name: "fast_food"))
        expense4.subcategories.append(s19)
        
        
        let expense5 = Category(
            type: expenseType,
            name: "Lazer",
            iconImage: IconImage(type: .external, name: "beach"),
            iconColor: "purple3")
        
        let s20 = Subcategory(
            name: "Cinema",
            iconImage: IconImage(type: .SFSymbol, name: "film"))
        expense5.subcategories.append(s20)
        
        let s21 = Subcategory(
            name: "Bar",
            iconImage: IconImage(type: .external, name: "martini"))
        expense5.subcategories.append(s21)
        
        let s22 = Subcategory(
            name: "Espetáculo",
            iconImage: IconImage(type: .external, name: "ticket"))
        expense5.subcategories.append(s22)
        
        let expense6 = Category(
            type: expenseType,
            name: "Educação",
            iconImage: IconImage(type: .external, name: "book"),
            iconColor: "yellow2")
        
        let s23 = Subcategory(
            name: "Material",
            iconImage: IconImage(type: .SFSymbol, name: "book"))
        expense6.subcategories.append(s23)
        
        let s24 = Subcategory(
            name: "Papelaria",
            iconImage: IconImage(type: .SFSymbol, name: "pencil"))
        expense6.subcategories.append(s24)
        
        let s25 = Subcategory(
            name: "Curso",
            iconImage: IconImage(type: .SFSymbol, name: "studentdesk"))
        expense6.subcategories.append(s25)
        
        let s26 = Subcategory(
            name: "Universidade",
            iconImage: IconImage(type: .external, name: "university"))
        expense6.subcategories.append(s26)
        
        
        let expense7 = Category(
            type: expenseType,
            name: "Transporte",
            iconImage: IconImage(type: .external, name: "transport"),
            iconColor: "orange1")
        
        let s27 = Subcategory(
            name: "Público",
            iconImage: IconImage(type: .SFSymbol, name: "tram.fill"))
        expense7.subcategories.append(s27)
        
        let s28 = Subcategory(
            name: "Particular",
            iconImage: IconImage(type: .external, name: "taxi"))
        expense7.subcategories.append(s28)
        
        
        let expense8 = Category(
            type: expenseType,
            name: "Saúde",
            iconImage: IconImage(type: .external, name: "hospital"),
            iconColor: "aqua2")
        
        let s29 = Subcategory(
            name: "Plano de saúde",
            iconImage: IconImage(type: .external, name: "bed"))
        expense8.subcategories.append(s29)
        
        let s30 = Subcategory(
            name: "Consulta",
            iconImage: IconImage(type: .SFSymbol, name: "person"))
        expense8.subcategories.append(s30)
        
        let s31 = Subcategory(
            name: "Medicação",
            iconImage: IconImage(type: .external, name: "pill"))
        expense8.subcategories.append(s31)
        
        let s32 = Subcategory(
            name: "Vacinas",
            iconImage: IconImage(type: .external, name: "needle"))
        expense8.subcategories.append(s32)
        
        let s32_1 = Subcategory(
            name: "Dentista",
            iconImage: IconImage(type: .external, name: "tooth"))
        expense8.subcategories.append(s32_1)
        
        let s32_2 = Subcategory(
            name: "Exame",
            iconImage: IconImage(type: .SFSymbol, name: "waveform.path.ecg"))
        expense8.subcategories.append(s32_2)
        
        
        let expense9 = Category(
            type: expenseType,
            name: "Beleza",
            iconImage: IconImage(type: .external, name: "beauty"),
            iconColor: "pink3")
        
        let s33 = Subcategory(
            name: "Salão",
            iconImage: IconImage(type: .external, name: "saloon"))
        expense9.subcategories.append(s33)

        let s34 = Subcategory(
            name: "Procedimento",
            iconImage: IconImage(type: .external, name: "needle"))
        expense9.subcategories.append(s34)

        let s35 = Subcategory(
            name: "Cosmético",
            iconImage: IconImage(type: .external, name: "lotion"))
        expense9.subcategories.append(s35)
        
        
        let expense10 = Category(
            type: expenseType,
            name: "Compras",
            iconImage: IconImage(type: .SFSymbol, name: "bag"),
            iconColor: "blue4")
        
        let s36 = Subcategory(
            name: "Roupa",
            iconImage: IconImage(type: .external, name: "hanger"))
        expense10.subcategories.append(s36)
        
        let s37 = Subcategory(
            name: "Tecnologia",
            iconImage: IconImage(type: .external, name: "notebook"))
        expense10.subcategories.append(s37)
        
        let s38 = Subcategory(
            name: "Utensílio",
            iconImage: IconImage(type: .external, name: "fridge"))
        expense10.subcategories.append(s38)
        
        let s39 = Subcategory(
            name: "Outros",
            iconImage: IconImage(type: .external, name: "other"))
        expense10.subcategories.append(s39)
        
        
        let expense11 = Category(
            type: expenseType,
            name: "Academia",
            iconImage: IconImage(type: .external, name: "fitness"),
            iconColor: "blue1")
        
        
        let expense12 = Category(
            type: expenseType,
            name: "Viagem",
            iconImage: IconImage(type: .SFSymbol, name: "globe"),
            iconColor: "aqua4")
        
        let s40 = Subcategory(
            name: "Hotel",
            iconImage: IconImage(type: .SFSymbol, name: "bed.double"))
        expense12.subcategories.append(s40)
        
        let s41 = Subcategory(
            name: "Passagem",
            iconImage: IconImage(type: .SFSymbol, name: "airplane"))
        expense12.subcategories.append(s41)
        
        
        
        let expense13 = Category(
            type: expenseType,
            name: "Encargos",
            iconImage: IconImage(type: .external, name: "calculator_2"),
            iconColor: "dark-gray1")
        
        let s42 = Subcategory(
            name: "Imposto",
            iconImage: IconImage(type: .external, name: "lion"))
        expense13.subcategories.append(s42)
        
        let s43 = Subcategory(
            name: "Multa",
            iconImage: IconImage(type: .external, name: "penalty"))
        expense13.subcategories.append(s43)
        
        let s44 = Subcategory(
            name: "Tarifa bancária",
            iconImage: IconImage(type: .SFSymbol, name: "flag"))
        expense13.subcategories.append(s44)
        
        let s45 = Subcategory(
            name: "Anuidade cartão",
            iconImage: IconImage(type: .SFSymbol, name: "creditcard"))
        expense13.subcategories.append(s45)
        
        
        do{
            try realm.write {
                realm.add(expense1)
                realm.add(expense2)
                realm.add(expense3)
                realm.add(expense4)
                realm.add(expense5)
                realm.add(expense6)
                realm.add(expense7)
                realm.add(expense8)
                realm.add(expense9)
                realm.add(expense10)
                realm.add(expense11)
                realm.add(expense12)
                realm.add(expense13)
            }
        }catch{
            print("Error saving incomes: \(error)")
        }
        
        
        let savingTest = Saving(name: "Celular", savingGoal: 3000, iconImage: IconImage(type: .external, name: "phone_iphone"), iconColor: "blue3")
        savingTest.saved = 2000
        savingTest.save()
        
        let savingTest2 = Saving(name: "Casa", savingGoal: 0, iconImage: IconImage(type: .SFSymbol, name: "house"), iconColor: "pink1")
        savingTest2.saved = 2000
        savingTest2.save()
        
        
    }
    
    
}
