# REPORT - WegGeld
Weggeld is **the** app for keeping track of your monthly expenses. This app has the ability to show you where all your money is going to every month and shows you where you in which category you can maybe save some money. Every month you choose a certain amount which you want to spend and this app will show you the extent tho which you have reached this amount. The app has a very easy to read view of the expenses and beautiful statistics where you can see your monthly expenses.

<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/WegScreen.png" width="280" height="500"/>
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/StatistiekenScreen.png" width="280" height="500"/>
</p>
</body>

## Student Information
* Name: Noud Corten
* Studentnumber: 11349948
* Platform: iOS (Swift)

## Technical Design
#### High Level Overview
<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/advanced_sketch_2-1.png" width="1000" height="500"/>
</p>
</body>

#### ViewControllers
View Controller | Has Segues To | Embed In TabBarController | Functionality
--------------- | ------------- | ------------------------- | -------------
MoneyViewController | ExpenseTableViewController | Yes | Controls the view in which te user can see his/her total expense.
AwayTableViewController | ExpenseTableViewController | Yes | Shows the expenses the user has made.
StatisticsViewController | None | Yes | Shows statistics about the expenses the user has made.
SettingsTableViewController | AddCategoryViewController | Yes | Let's the user edit total monthly expense, edit categories and option to download .csv file.
ExpenseTableViewController | MoneyViewController, AwayTableViewController | No | Let's the user add/edit information of expense.
AddCategoryViewController | SettingsTableViewController | No | Let's the user add/edit information of category.

#### ViewCells
View Cell | Connected TableViewController | Functionality
--------- | ----------------------------- | -------------
ExpenseInputCell | ExpenseTableViewController | Cell used to enter the expense amount.
ExpenseDateCell| ExpenseTableViewController | Cell used to enter the date of the expense.
ExpenseCategoryCell | ExpenseTableViewController | Cell used to select the category of the expense.
ExpenseInfoCell  | ExpenseTableViewController | Cell used to add extra information to the expense.
ExpenseCell | AwayTableViewController | Cell used to represent the important information of an expense in the TableView.

#### Classes
Class | Information Stored | Functionality
----- | ------------------ | -------------
AppData | Expenses, Maximum Amount, Categories, Category Colors, Months | Most important class in the app. This class stores all the information that the app needs with the most important information being the expenses done by the user.
Expense | Date, Amount, Category, Extra Info | Class which stores all the important information about an expense. The class 'AppData' has a list of expenses, in which every expense is the class 'Expense'.

#### Extensions / Pods / Extra Classes
Type | Extension Of | Used In | Functionality
---- | ------------ | ------- | -------------
Extension | UIColor | **Every** ViewController | Adds extra colors to the UIColor database which are used for coloring of the categories and the pink UI.
Extension | UIViewController | ExpenseTableViewController, SettingsTableViewController, AddCategoryViewController | Used in ViewControllers which use textfields. Allows to user to click somewhere on the screen to let the keyboard disappeared.
Extension | String | ExpenseTableViewController, SettingsTableViewController, AddCategoryViewController | Used to add functionality to string manipulation. Checking if strings are correct floats/ints and writing names in one way (e.g. "Name").
Extension | DateFormatter | AwayTableViewController, ExpenseTableViewController, StatisticsViewController, SettingsTableViewController | Used to manipulate the date of an expense. Used write the date in a certain way or used for comparing different dates.
Pod | XCode | StatisticsViewController | Pod used to create nice graphs in the Statistics Screen.
Class | UILabel | MoneyViewController | Creates an animation for the percentage label counting up.
CABasicAnimation | . | MoneyViewController | Creates a pullsating circle and a circle which represents expense percentage.
CAShapeLayer | . | MoneyViewController | Creates circles which are used for the CABasicAnimations.
