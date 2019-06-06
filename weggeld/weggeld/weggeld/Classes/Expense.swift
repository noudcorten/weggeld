//
//  Expense.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import Foundation

struct Expense: Codable {
    var amount: Float
    var dueDate: Date
    var notes: String?
    var category: String
    
    static var DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("expenses")
    
    static func loadExpenses() -> [Expense]? {
        guard let codedExpenses = try? Data(contentsOf: ArchiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Expense>.self, from: codedExpenses)
    }
    
    static func saveExpenses(_ expenses: [Expense]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedExpenses = try? propertyListEncoder.encode(expenses)
        try? codedExpenses?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    static func loadSampleExpenses() -> [Expense] {
        let expense1 = Expense(amount: 12, dueDate: Date(), notes: "Notes 1", category: "Auto")
        let expense2 = Expense(amount: 16, dueDate: Date(), notes: "Notes 2", category: "Kleding")
        return [expense1, expense2]
    }
    

    
    
    
}
