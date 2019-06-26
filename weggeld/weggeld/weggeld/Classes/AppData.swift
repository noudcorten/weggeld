//
//  AppData.swift
//  WegGeld
//
//  Created by Noud on 6/7/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import Foundation

/* Structure of AppData. Stores all the information used in the app: all
 expenses, maximum monthly amount, categories (with selected color), etc. */

// AppData is Codable because PListEncoder is used to save this class to device.
struct AppData: Codable {
    var isEmpty = Bool()
    var expenses = [Expense]()
    var maxAmount = Float()
    var categories = [String]()
    var category_dict = [String: Int]()
    var months = [String]()
    var month_dict = [String: Int]()
    
    /// Initializer uses function 'reset()' to set the default information.
    init() {
        self.reset()
    }
    
    /// Creates list with standard categories and creates a dictionary in which
    /// the selected color is stored (based on UIColor.categoryColors()).
    mutating func createCategories() {
        self.categories = ["Eten", "Vervoer", "Kleding", "Wonen", "Onderwijs", "Gezondheid", "Vakantie", "Liefdadigheid", "Vermaak", "Sparen"]
        self.category_dict = ["Eten" : 0, "Vervoer" : 1, "Kleding" : 2,
                              "Wonen" : 3, "Onderwijs" : 4, "Gezondheid" : 5,
                              "Vakantie" : 6, "Liefdadigheid" : 7,
                              "Vermaak" : 8, "Sparen" : 9]
    }
    
    /// Creates list with all months and creates dictionary with the key being
    /// the month and value being the month number (used for sorting).
    mutating func createMonths() {
        self.months = ["Januari", "Februari", "Maart", "April", "Mei", "Juni",
                       "Juli", "Augustus", "September", "Oktober", "November",
                       "December"]
        self.month_dict = ["Januari" : 1, "Februari" : 2, "Maart" : 3,
                           "April" : 4, "Mei" : 5, "Juni" : 6, "Juli" : 7,
                           "Augustus" : 8, "September" : 9, "Oktober" : 10,
                           "November" : 11, "December" : 12]
    }
    
    /// Sets all the information of the AppData class to default.
    mutating func reset() {
        self.isEmpty = true
        self.expenses = []
        self.maxAmount = 100
        self.createCategories()
        self.createMonths()
    }
    
    /// Adds an expense to the list of expenses and sorts it based on the date.
    mutating func addExpense(_ expense: Expense) {
        self.isEmpty = false
        self.expenses.append(expense)
        self.expenses = sortExpenses(expenses: self.expenses)
    }
    
    /// Sets the given list of expenses to be the new all expenses list.
    mutating func newExpensesList(expenses: [Expense]) {
        self.expenses = sortExpenses(expenses: expenses)
        if self.expenses.count > 0 {
            self.isEmpty = false
        } else {
            self.isEmpty = true
        }
    }
    
    /// Removes the given expense from the list of expenses.
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
    
    /// Sorts the list of expenses based on their dates.
    mutating func sortExpenses(expenses: [Expense]) -> [Expense] {
        return expenses.sorted(by: { $0.dueDate.compare($1.dueDate) == .orderedDescending })
    }
    
    /// Sets the given list of categories to be the new all categories list.
    mutating func newCategoryList(categories: [String]) {
        self.categories = categories
    }
    
    /// Removes given category from category list.
    mutating func removeCategory(category: String) {
        if let index = self.categories.index(of: category) {
            self.categories.remove(at: index)
        }
        self.category_dict.removeValue(forKey: category)
        
        // Removes all expenses with the 'removed'-category.
        for expense in self.expenses {
            if expense.category == category {
                self.removeExpense(expense)
            }
        }
    }
    
    /// Adds category to list of categories and saves selected color in dict.
    mutating func addCategory(category: String, color: Int) {
        if !(self.categories.contains(category)) {
            self.categories.append(category)
        }
        self.category_dict[category] = color
    }
    
    /// Changes the given previous name into the given new name.
    mutating func changeCategory(newName: String, prevName: String,
                                 color: Int) {
        if let index = self.categories.firstIndex(of: prevName) {
            self.categories[index] = newName
        }
        self.category_dict.removeValue(forKey: prevName)
        self.category_dict[newName] = color
        self.replaceCategoryInExpense(newName, prevName)
    }
    
    /// Finds all expenses which have the old category name, creates a new
    /// Expense-entry and changes the old Expense (class) into the new Expense.
    mutating func replaceCategoryInExpense(_ newName: String,
                                           _ prevName: String) {
        for prevExpense in self.expenses {
            if prevExpense.category == prevName {
                let newExpense = Expense(dueDate: prevExpense.dueDate, amount: prevExpense.amount, category: newName,
                                         notes: prevExpense.notes)
                self.replaceExpense(prevExpense, newExpense)
            }
        }
    }
    
    /// Replaces the old Expense (class) with the new Expense.
    mutating func replaceExpense(_ prevExpense: Expense,
                                 _ newExpense: Expense) {
        let index = self.findIndexOfExpense(prevExpense)!
        self.expenses[index] = newExpense
    }
    
    /// Finds the index of the given Expense in the list of all expenses.
    private func findIndexOfExpense(_ expense: Expense) -> Int? {
        for (i, possibleExpense) in self.expenses.enumerated() {
            if expense.dueDate == possibleExpense.dueDate {
                return i
            }
        }
        return nil
    }
    
    /// Checks if the given category exists in the list of categories.
    public func hasCategory(_ category: String) -> Bool {
        for expense in self.expenses {
            if expense.category == category {
                return true
            }
        }
        return false
    }
    
    /// Returns dictionary which stores all the expenses per month per year.
    /// - Format: dateDict["2019"]["Januari"] = [Expense]
    public func getDateDict() -> [String: [String: [Expense]]] {
        var dateDict = [String: [String: [Expense]]]()
        for expense in self.expenses {
            let year = expense.getYear()
            // Indexing -1 because e.g. Januari's monthNumber = 1, but the index
            // in the 'months'-list = 0, so correct index is monthNumber - 1.
            let month = self.months[expense.getMonthNumber() - 1]
            // If there exists a dictionary for the current year.
            if var monthDict = dateDict[year] {
                // If there exists a list of expenses for the current month.
                if var expenseList = monthDict[month] {
                    expenseList.append(expense)
                    monthDict[month] = expenseList
                    dateDict[year] = monthDict
                // Creates dictionary for current month.
                } else {
                    monthDict[month] = [expense]
                    dateDict[year] = monthDict
                }
            // Creates dictionary for the current year.
            } else {
                var monthDict = [String: [Expense]]()
                monthDict[month] = [expense]
                dateDict[year] = monthDict
            }
        }
        return dateDict
    }
    
    /// Creates dictionary which stores the expenseAmount per category per
    /// month.
    /// - Format: categoryMonthMoneyDict["Eten"] = 10
    public func getCategoryMonthMoneyDict(year: String, month: String) ->
        [String: Float]? {
        var categoryMonthMoneyDict = [String: Float]()
        let dateDict = self.getDateDict()
        if let monthDict = dateDict[year] {
            if let expenseList = monthDict[month] {
                for expense in expenseList {
                    // If the category is present in the dictionary
                    if var value = categoryMonthMoneyDict[expense.category] {
                        value += expense.amount
                        categoryMonthMoneyDict[expense.category] = value
                    // If the category is not present in the dictionary
                    } else {
                        categoryMonthMoneyDict[expense.category] =
                            expense.amount
                    }
                }
            }
        }
        return categoryMonthMoneyDict
    }
    
    /// Creates dictionary which stores the expenseAmount per category per year.
    /// - Format: categoryMonthMoneyDict["Eten"] = 10
    public func getCategoryYearMoneyDict(year: String) -> [String: Float]? {
        var categoryYearMoneyDict = [String: Float]()
        let dateDict = self.getDateDict()
        if let monthDict = dateDict[year] {
            for (_, expenses) in monthDict {
                for expense in expenses {
                    // If the category is present in the dictionary
                    if var value = categoryYearMoneyDict[expense.category] {
                        value += expense.amount
                        categoryYearMoneyDict[expense.category] = value
                    // If the category is not present in the dictionary
                    } else {
                        categoryYearMoneyDict[expense.category] = expense.amount
                    }
                }
            }
        }
        return categoryYearMoneyDict
    }
    
    /// Creates dictionary which stores the expenseAmount per month.
    /// - Format: categoryMonthMoneyDict["Januari"] = 10
    public func getYearMoneyDict(year: String) -> [String: Float]? {
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
    
    /// Creates dictionary which stores the expenses per category.
    /// - Format: categoryMonthMoneyDict["Eten"] = [Expense]
    mutating func getCategoryDict() -> [String: [Expense]]? {
        var categoryDict = [String: [Expense]]()
        for expense in self.expenses {
            // If the category is present in the dictionary.
            if var categoryList = categoryDict[expense.category] {
                categoryList.append(expense)
                let sortedCategoryList = sortExpenses(expenses: categoryList)
                categoryDict[expense.category] = sortedCategoryList
            // If the category is not present in the dictionary.
            } else {
                categoryDict[expense.category] = [expense]
            }
        }
        return categoryDict
    }
    
    /// Creates dictionary which stores the expenseAmount per category.
    /// - Format: categoryMonthMoneyDict["Eten"] = 10
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
    
    /// Returns the list of months that are used in the given year.
    public func getUsedMonths(year: String) -> [String]? {
        let dateDict = getDateDict()
        var monthArray = [String]()
        if let dict = dateDict[year] {
            // Sorts the months in the list based on the month_dict.
            for i in 1...self.month_dict.count {
                for month in Array(dict.keys) {
                    // Appends months chronological based on index (Jan. = 1,
                    // Feb. = 2, etc.).
                    if month_dict[month] == i {
                        monthArray.append(month)
                        break
                    }
                }
            }
        }
        // Check for empty list.
        if monthArray.count > 0 {
            return monthArray
        }
        return nil
    }
    
    /// Returns the list of years that are used.
    public func getUsedYears() -> [String]? {
        let dateDict = getDateDict()
        var yearArray = [Int]()
        for (year, _) in dateDict {
            // Appends it as Int because of sorting.
            yearArray.append(Int(year)!)
        }
        // Check for empty list.
        if yearArray.count > 0 {
            // Sorts the years in ascending order.
            yearArray.sort(by: {(year1, year2) -> Bool in
                return year1 < year2
            })
            // Converts sorted Int-array to String-array.
            var stringYearArray = [String]()
            for year in yearArray {
                stringYearArray.append(String(year))
            }
            return stringYearArray
        }
        return nil
        
    }
    
    /// Returns a list consisting of strings representing a month and a year.
    /// Used in the header in AwayTableViewController.
    public func getAllUsedMonthsString() -> [String] {
        var allUsedMonths = [String]()
        var monthYearString = String()
        // Reverses usedYears to get the latest years first.
        for year in self.getUsedYears()!.reversed() {
            // Reverses usedMonths to get the latest months first.
            for month in getUsedMonths(year: year)!.reversed() {
                monthYearString = month + " (" + year + ")"
                allUsedMonths.append(monthYearString)
            }
        }
        return allUsedMonths
    }
    
    /// Returns a big list consisting of smaller lists which hold all the
    /// the expenses of one month.
    public func getAllExpensesList() -> [[Expense]]? {
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
        // Reverses the list of allExpenses because the latest expense months
        // will then come first.
        return allExpensesList.reversed()
    }
    
    // Returns a float holding the total expense of the current month.
    public func totalExpense() -> Float {
        let allExpenses = self.getAllExpensesList()!
        var expenseSum: Float = 0.0
        if allExpenses.count > 0 {
            for expenseList in allExpenses {
                for expense in expenseList {
                    // Only increases the value of expenseSum when the selected
                    // expense is from the current month.
                    if DateFormatter.getMonthYear.string(from: expense.dueDate) == DateFormatter.getMonthYear.string(from: Date()) {
                        expenseSum += expense.amount
                    // Breaks from the loop if the expense date doesn't match
                    // the current date. All the expenses in this list will have
                    // the same date, so not 'continue' but 'break'.
                    } else {
                        break
                    }
                }
            }
        }
        return expenseSum
    }
    
    /// MARK: - Enables the class to be saved to and loaded from the device.
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
