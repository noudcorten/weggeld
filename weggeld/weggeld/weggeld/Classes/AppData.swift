//
//  AppData.swift
//  WegGeld
//
//  Created by Noud on 6/7/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import Foundation

struct AppData: Codable {
    var isEmpty = Bool()
    var expenses = [Expense]()
    var maxAmount = Float()
    
    var categories = [String]()
    var category_dict = [String: Int]()
    
    var months = [String]()
    var month_dict = [String: Int]()
    
    init() {
        self.reset()
    }
    
    mutating func createCategories() {
        self.categories = ["Eten", "Vervoer", "Kleding", "Wonen", "Onderwijs", "Gezondheid", "Vakantie", "Liefdadigheid", "Vermaak", "Sparen"]
        self.category_dict = ["Eten" : 0, "Vervoer" : 1, "Kleding" : 2, "Wonen" : 3, "Onderwijs" : 4, "Gezondheid" : 5, "Vakantie" : 6, "Liefdadigheid" : 7, "Vermaak" : 8, "Sparen" : 9]
    }
    
    mutating func createMonths() {
        self.months = ["Januari", "Februari", "Maart", "April", "Mei", "Juni", "Juli", "Augustus", "September", "Oktober", "November", "December"]
        self.month_dict = ["Januari" : 1, "Februari" : 2, "Maart" : 3, "April" : 4, "Mei" : 5, "Juni" : 6, "Juli" : 7, "Augustus" : 8, "September" : 9, "Oktober" : 10, "November" : 11, "December" : 12]
    }
    
    mutating func reset() {
        self.isEmpty = true
        self.expenses = []
        self.maxAmount = 100
        self.createCategories()
        self.createMonths()
    }
    
    mutating func addExpense(_ expense: Expense) {
        self.isEmpty = false
        self.expenses.append(expense)
        self.expenses = sortExpenses(expenses: self.expenses)
    }
    
    mutating func newExpensesList(expenses: [Expense]) {
        self.expenses = sortExpenses(expenses: expenses)
        if self.expenses.count > 0 {
            self.isEmpty = false
        } else {
            self.isEmpty = true
        }
    }
    
    mutating func removeExpense(_ expense: Expense) {
        for (i, posExpens) in self.expenses.enumerated() {
            if posExpens.dueDate == expense.dueDate {
                self.expenses.remove(at: i)
                if self.expenses.count == 0 {
                    self.isEmpty = true
                }
            }
        }
    }
    
    mutating func sortExpenses(expenses: [Expense]) -> [Expense] {
        return expenses.sorted(by: { $0.dueDate.compare($1.dueDate) == .orderedDescending })
    }
    
    mutating func newCategoryList(categories newList: [String]) {
        self.categories = newList
    }
    
    mutating func removeCategory(category: String) {
        if let index = self.categories.index(of: category) {
            self.categories.remove(at: index)
        }
        self.category_dict.removeValue(forKey: category)
        
        for expense in self.expenses {
            if expense.category == category {
                self.removeExpense(expense)
            }
        }
    }
    
    mutating func addCategory(category: String, color: Int) {
        if !(self.categories.contains(category)) {
            self.categories.append(category)
        }
        self.category_dict[category] = color
    }
    
    mutating func changeCategory(newName: String, prevName: String, color: Int) {
        if let index = self.categories.firstIndex(of: prevName) {
            self.categories[index] = newName
        }
        self.category_dict.removeValue(forKey: prevName)
        self.category_dict[newName] = color
        self.replaceCategoryInExpense(newName, prevName)
    }
    
    mutating func replaceCategoryInExpense(_ newName: String, _ prevName: String) {
        for prevExpense in self.expenses {
            if prevExpense.category == prevName {
                let newExpense = Expense(dueDate: prevExpense.dueDate, amount: prevExpense.amount, category: newName, notes: prevExpense.notes)
                self.replaceExpense(prevExpense, newExpense)
            }
        }
    }
    
    mutating func replaceExpense(_ prevExpense: Expense, _ newExpense: Expense) {
        let index = self.findIndexOfExpense(prevExpense)!
        self.expenses[index] = newExpense
    }
    
    func findIndexOfExpense(_ expense: Expense) -> Int? {
        for (i, possibleExpense) in self.expenses.enumerated() {
            if expense.dueDate == possibleExpense.dueDate {
                return i
            }
        }
        return nil
    }
    
    func hasCategory(_ category: String) -> Bool {
        for expense in self.expenses {
            if expense.category == category {
                return true
            }
        }
        return false
    }
    
    func getUsedMonths(year: String) -> [String]? {
        let dateDict = getDateDict()
        var monthArray = [String]()
        
        if let dict = dateDict[year] {
            for i in 1...self.month_dict.count {
                for month in Array(dict.keys) {
                    if month_dict[month] == i {
                        monthArray.append(month)
                        break
                    }
                }
            }
        }
        if monthArray.count > 0 {
            return monthArray
        }
        return nil
    }
    
    func getUsedYears() -> [String]? {
        let dateDict = getDateDict()
        
        var yearArray = [Int]()
        for (year, _) in dateDict {
            yearArray.append(Int(year)!)
        }
        
        if yearArray.count > 0 {
            yearArray.sort(by: {(year1, year2) -> Bool in
                return year1 < year2
            })
            
            var stringYearArray = [String]()
            for year in yearArray {
                stringYearArray.append(String(year))
            }
            
            return stringYearArray
        }
        return nil
        
    }
    
//    func getUsedMonthNumber(year: String) -> String {
//        let usedMonths = self.getUsedMonths(year: year)!.reversed()
//        let monthNumber = Expense.getMonthNumber.string(from: Date())
//        let monthString = appData.months[Int(monthNumber)!-1]
//        let monthString = appData.getMonthNumber(year: pickedYear)
//    }
    
    
    // Creates a dictionary with the dates of the expenses in correct chronological
    // order.
    func getAllUsedMonthsString() -> [Int: String] {
        var allUsedMonths = [Int: String]()
        var monthYearString = String()
        var index = 0
        
        for year in self.getUsedYears()!.reversed() {
            for month in getUsedMonths(year: year)!.reversed() {
                monthYearString = month + " (" + year + ")"
                allUsedMonths[index] = monthYearString
                index += 1
            }
        }
        return allUsedMonths
    }
    
    
    func getAllExpensesList() -> [[Expense]]? {
        var allExpensesList = [[Expense]]()
        let dateDict = self.getDateDict()
        
        if let usedYears = self.getUsedYears() {
            for year in usedYears {
                if let monthDict = dateDict[year] {
                    for month in self.getUsedMonths(year: year)! {
                        if let expenses = monthDict[month] {
                            allExpensesList.append(expenses)
                        }
                    }
                }
            }
        }
        return Array(allExpensesList.reversed())
    }
    
    func getDateDict() -> [String: [String: [Expense]]] {
        var dateDict = [String: [String: [Expense]]]()
        
        for expense in self.expenses {
            let year = expense.getYear()
            let month = self.months[expense.getMonthNumber() - 1]
            
            if var monthDict = dateDict[year] {
                if var expenseList = monthDict[month] {
                    expenseList.append(expense)
                    monthDict[month] = expenseList
                    dateDict[year] = monthDict
                } else {
                    monthDict[month] = [expense]
                    dateDict[year] = monthDict
                }
            } else {
                var monthDict = [String: [Expense]]()
                monthDict[month] = [expense]
                dateDict[year] = monthDict
            }
        }
        return dateDict
    }
    
    func getCategoryMonthMoneyDict(year: String, month: String) -> [String: Float]? {
        var categoryMonthMoneyDict = [String: Float]()
        let dateDict = self.getDateDict()
        if let monthDict = dateDict[year] {
            if let expenseList = monthDict[month] {
                for expense in expenseList {
                    if var value = categoryMonthMoneyDict[expense.category] {
                        value += expense.amount
                        categoryMonthMoneyDict[expense.category] = value
                    } else {
                        categoryMonthMoneyDict[expense.category] = expense.amount
                    }
                }
            }
        }
        return categoryMonthMoneyDict
    }
    
    func getCategoryYearMoneyDict(year: String) -> [String: Float]? {
        var categoryYearMoneyDict = [String: Float]()
        let dateDict = self.getDateDict()
        
        if let monthDict = dateDict[year] {
            for (_, expenses) in monthDict {
                for expense in expenses {
                    if var categoryValue = categoryYearMoneyDict[expense.category] {
                        categoryValue += expense.amount
                        categoryYearMoneyDict[expense.category] = categoryValue
                    } else {
                        categoryYearMoneyDict[expense.category] = expense.amount
                    }
                }
            }
        }
        return categoryYearMoneyDict
    }
    
    func getYearMoneyDict(year: String) -> [String: Float]? {
        var yearMoneyDict = [String: Float]()
        let dateDict = self.getDateDict()
        
        if let monthDict = dateDict[year] {
            for month in self.getUsedMonths(year: year)! {
                if let expenses = monthDict[month] {
                    var totalAmount: Float = 0.0
                    
                    for expense in expenses {
                        totalAmount += expense.amount
                    }
                    yearMoneyDict[month] = totalAmount
                }
            }
        }
        return yearMoneyDict
    }
    
    mutating func getCategoryDict() -> [String: [Expense]]? {
        var categoryDict = [String: [Expense]]()
        
        for expense in self.expenses {
            if var categoryList = categoryDict[expense.category] {
                categoryList.append(expense)
                let sortedCategoryList = sortExpenses(expenses: categoryList)
                categoryDict[expense.category] = sortedCategoryList
            } else {
                categoryDict[expense.category] = [expense]
            }
        }
        return categoryDict
    }
    
    mutating func getCategoryMoneyDict() -> [String: Float]? {
        var categoryMoneyDict = [String: Float]()
        let categoryDict = self.getCategoryDict()!
        
        for category in self.categories {
            if let categoryList = categoryDict[category] {
                var totalAmount: Float = 0.0
                
                for expense in categoryList {
                    totalAmount += expense.amount
                }
                categoryMoneyDict[category] = totalAmount
            }
        }
        return categoryMoneyDict
    }
    
    func totalExpense() -> Float {
        let allExpenses = self.getAllExpensesList()!
        
        var expenseSum: Float = 0.0
        if allExpenses.count > 0 {
            for expenseList in allExpenses {
                for expense in expenseList {
                    if DateFormatter.getMonthYear.string(from: expense.dueDate) == DateFormatter.getMonthYear.string(from: Date()) {
                        expenseSum += expense.amount
                    } else {
                        break
                    }
                }
            }
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
