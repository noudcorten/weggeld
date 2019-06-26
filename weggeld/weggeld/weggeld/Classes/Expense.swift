//
//  Expense.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import Foundation

/* Structure of an expense. Stores all the important information about the
 expense. */
struct Expense: Codable {
    var dueDate: Date
    var amount: Float
    var category: String
    var notes: String?
    
    init(dueDate: Date, amount: Float, category: String, notes: String?) {
        self.dueDate = dueDate
        self.amount = amount
        self.category = category
        self.notes = notes
    }
    
    // Returns the number of the saved date (e.g. '01')
    func getMonthNumber() -> Int {
        return Int(DateFormatter.getMonthNumber.string(from: self.dueDate))!
    }
    
    // Returns the year of the saved date (e.g. '2019')
    func getYear() -> String {
        return DateFormatter.getYear.string(from: self.dueDate)
    }
}

