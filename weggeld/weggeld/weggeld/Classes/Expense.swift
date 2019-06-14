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
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    static let getMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    static let getMonthNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        return formatter
    }()
    
    static let getYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    func getMonth() -> String {
        return Expense.getMonth.string(from: self.dueDate)
    }
    
    func getMonthNumber() -> Int {
        return Int(Expense.getMonthNumber.string(from: self.dueDate))!
    }
    
    func getYear() -> String {
        return Expense.getYear.string(from: self.dueDate)
    }
}
