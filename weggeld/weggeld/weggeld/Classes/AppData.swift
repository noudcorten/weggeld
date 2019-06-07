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
    var maxMoney: Float
    
    static let getMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    
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
