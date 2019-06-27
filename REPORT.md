# REPORT - WegGeld
Weggeld is **the** app for keeping track of your monthly expenses. This app has the ability to show you where all your money is going to every month and shows you where you in which category you can maybe save some money. Every month you choose a certain amount which you want to spend and this app will show you the extent tho which you have reached this amount. The app has a very easy to read view of the expenses and beautiful statistics where you can see your monthly expenses.

**Screenshots:**
<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/WegScreen.png" width="280" height="500"/>
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/StatistiekenScreen.png" width="280" height="500"/>
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
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/advanced_sketch_2-1.png" width="1000" height="500"/>
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

#### Important Dictionaries
Dictionary | Requestable From | Format | Parameters | Functionality
---------- | ---------------- | ---------------------------------------- | ------------- | -------------
DateDict | AppData | DateDict[year][month] = [Expense] | None | Returns all the expenses by month and year
categoryMonthMoneyDict | AppData | categoryMonthMoneyDict[category] = Float | Year, Month | Returns amount of expense per category
categoryYearMoneyDict | AppData | categoryYearMoneyDict[category] = Float | Year | Returns amount of expense per category
yearMoneyDict | AppData | yearMoneyDict[month] = Float | Year | Returns amount of expense per month
categoryDict | AppData | categoryDict[category] = [Expense] | None | Returns all the expenses per category
categoryMoneyDict | AppData | categoryMoneyDict[category] = Float| None | Returns amount of expense per category

#### Extensions / Pods / Extra Classes
Type | Extension Of | Used In | Functionality
---- | ------------ | ------- | -------------
Extension | UIColor | **Every** ViewController | Adds extra colors to the UIColor database which are used for coloring of the categories and the pink UI.
Extension | UIViewController | ExpenseTableViewController, SettingsTableViewController, AddCategoryViewController | Used in ViewControllers which use textfields. Allows to user to click somewhere on the screen to let the keyboard disappeared.
Extension | String | ExpenseTableViewController, SettingsTableViewController, AddCategoryViewController | Used to add functionality to string manipulation. Checking if strings are correct floats/ints and writing names in one way (e.g. "Name").
Extension | DateFormatter | AwayTableViewController, ExpenseTableViewController, StatisticsViewController, SettingsTableViewController | Used to manipulate the date of an expense. Used write the date in a certain way or used for comparing different dates.
Pod | Xcode | StatisticsViewController | Pod used to create nice graphs in the Statistics Screen.
Class | UILabel | MoneyViewController | Creates an animation for the percentage label counting up.
CABasicAnimation | . | MoneyViewController | Creates a pullsating circle and a circle which represents expense percentage.
CAShapeLayer | . | MoneyViewController | Creates circles which are used for the CABasicAnimations.

## Challenges during design
#### Changes in amount of controllers
When I started building the app I realised that I deffinately needed more screens to the controller. The most important screen to add was the 'Settings Screen'. This screen was really important because the feature that a user could enter it's own monthly expense was one of the main features in the PROPOSAL.md, so I needed a screen in which this could be done. During the design process I also came to the realisation that the categories needed to be edited as well. So the 'Settings Screen' could be used for that as well. But for adding and editing these categories another ViewController was needed. These decisions resulted in the addition of two Controller: 'SettingsTableViewController' and 'AddCategoryViewController'.

#### Adding colors to categories
Because of the previous named changes in the amount of ViewControllers, it was no also able to edit categories. This opened a whole new world to the app. Adding a color to a category would give the UI a much more proffesional look. So in the 'AddCategoryViewController' a nice CollectionView was added to choose a color of the user's liking.

#### Saving class and not list
In my first proposal I decided that I would just save the list of expenses (list of 'Expense'-Classes) and then retrieve the important information just from the 'Expense'-Class. After starting to work on the app I managed that I needed to save a lot more important information and needed this to be easily accesable in the entire app. So I changed the list of expenses to an entire class named 'AppData'. In this class it was much more easy to save all the important data and add functions which would make accesing of the data a lot easier. I then updated my PROPOSAL.md with this idea.

#### Creation of graphs
For making the 'Statistics Screen' I needed a plug-in which could handle data and make nice looking graphs. Online I found the pod 'Charts' which stated on their GitHub that it could create beautiful charts and was really easy to use. After finding a lot of information online I was able to understand the framework of 'Charts'. The problem I ran into was that I needed to create a framework which would represent the information of the expenses in easy to use lists or dictionaries. I needed information like: amount of expense per category, amount of expense per category per month, amount of expense per year, etc. To get this information in a easy to use format I created six dictionaries in the AppData class in which all this information was stored and easily extractable (See 'Important Dictionaries').

## Defending Decisions
#### Changes in amount of controllers
The reason I made this decision was that it would drastically improve the User Interface. The user needed to have the option to edit the monthly expense amount (because this was a main feature) and making the categories editable would give the app much more depth in terms of personalizing the interface. It would also make the app much more easy to understand as a 'Settings Screen' has all the options in terms of 'editing' the app, which is always the main use of a 'Settings Screen'.

#### Adding colors to categories
This feature was suggested from the team standups. After is decided to add more controllers (aka making a 'Settings Screen') the choice to add colors to the categories was quite logical. The first basic idea of editing a category only consisted of editing the name, but this functionality seemed quite dull on empty. Adding colors to the category would give the interface a much more readable look and made the 'Away Screen' and 'Statistics Screen' much more personal. **IF MORE TIME:** I would have chosen to also add small icons to the categories. This would create a lot more diversity and options for the categories and would also improve the readability of the app.

#### Saving class and not list
This idea was mainly because saving only a list would be much more difficult to extract information from. Also there was a lot of other information (like Dutch month names, categories (because of added controller), etc.) which needed to be stored as well. So programming whise saving a class instead of a list seemed the most logical option.

#### Creation of graphs
Because the graphs needed quite specific information from the expenses, adding all these extractable dictionaries in the AppData-Class seemed quite logical as well. This because it would keep the 'StatisticsViewController' more clean (it was already full of a lot of code because of the ChartsPod) and it would give the other ViewController also the option to extract this data. So programming whise this also was a logical decision for me.
