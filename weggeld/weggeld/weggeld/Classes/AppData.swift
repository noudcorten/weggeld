//
//  AppData.swift
//  WegGeld
//
//  Created by Noud on 6/7/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import Foundation

struct AppData: Codable {
    var expenses: [Expense]
    var maxAmount: Float
    var categories: [String] = ["Eten", "Vervoer", "Kleding", "Wonen", "Onderwijs", "Gezondheid", "Vakantie", "Liefdadigheid", "Vermaak", "Sparen"]
    
    init(expenses: [Expense], maxAmount: Float) {
        self.expenses = expenses
        self.maxAmount = maxAmount
    }
    
    mutating func addExpense(expense: Expense) {
        self.expenses.append(expense)
        self.expenses = sortExpenses(expenses: self.expenses)
    }
    
    mutating func newExpensesList(expenses: [Expense]) {
        self.expenses = sortExpenses(expenses: expenses)
    }
    
    mutating func sortExpenses(expenses: [Expense]) -> [Expense] {
        return expenses.sorted(by: { $0.dueDate.compare($1.dueDate) == .orderedDescending })
    }
    
    mutating func addCategory(category: String) {
        self.categories.append(category)
    }
    
    func totalExpense() -> Float {
        var expenseSum: Float = 0.0
        for expense in expenses {
            expenseSum = expenseSum + expense.amount
        }
        return expenseSum
    }
    
    static var DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("appdata")
    
    static func loadAppData() -> AppData? {
        guard let codedAppData = try? Data(contentsOf: ArchiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(AppData.self, from: codedAppData)
    }
    
    static func saveAppData(_ appData: AppData) {
        let propertyListEncoder = PropertyListEncoder()
        let codedAppData = try? propertyListEncoder.encode(appData)
        try? codedAppData?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    
}
