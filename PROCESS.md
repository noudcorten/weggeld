# Process Book


## Personal Developments
### Week 1
#### Day 1
* Came up with new idea of the app
    * Previous app design was harder and not usable for all people (only members)
* Made a full proposal using the new app idea

#### Day 2
* Made the full design document.
* Starting designing the app (added all ViewControllers, added all classes and completed the storyboard).
    * During design of the storyboard I added two extra screens.
    * Screen was added for 'Add Expense' - Screen where you can edit all information about the expense.
    * Screen was added for 'Settings' - Screen where total expense amount and the different categories can be edited.
* Started programming the 'All Expenses' screen.

#### Day 3
* Created a working 'All Expenses' screen - Expenses can be added, edited and deleted.
    * Local storage is not yet implemented
    * Struggle with design of the datastructure (what is a logical way to pass information between the Controllers?)
* Created a working 'Add Expense' screen - All info of a expense can be changed and added to the all-expenses list.
    * Also added the option to edit the information of an existing entry.

#### Day 4
* Made a huge mistake by deleting the entire app as a consequence of a hard reset using GIT.
    * Mistakes made using pull-requests.
* Spend rest of the day rebuilding the app.
* Finished the day by completely rebuilding the app and also adding PList Encoder.
    * PList Encoder had to option to save the list of expenses.

#### Day 5
* Plan of the day was to make a prototype in which everything worked ('Geld-Screen', 'Weg-Screen', 'Instellingen-Screen').
    * I skipped making the 'Statistieken-Screen', because this would take a lot of programming time.
    * Focussed on completing the interface with everyhthing working (and bug free!).
* Changed the PList Encoder to saving a class instead of a list.
    * This because a class can store a lot more information and a lot more efficient.
* Finished all of the three screens and made it entirely bug free (couldn't find any more bugs myself).

### Week 2
#### Day 1
* TWEEDE PINKSTERDAG

#### Day 2
* Finished the 'Geld-Screen'.
   * Added a loading bar in the form of a circle.
   * Added an animation for the loading bar.
   * Added an animation at the back of the loading bar which is pulsating, because this added more diversity.
   * Added an animation for the percentage label.
   * Added two labels which give the "Can still spend"- and "Already spend"-amounts.
* Added an icon to the app.
   * I managed to install the app on my iPhone (this was a problem because XCode didn't compile for iOS 12.3).
   * Adding an icon to the app made it look a lot more professional.

#### Day 3
* Installed pods
   * This is used for the 'Statistieken-Screen'.
   * Imported the 'Charts'-pod.
* Started working on the 'Statistieken-Screen'.
   * Added a scroll view so multiple statistics can be seen.
   * Added the first pie-chart using the 'Charts'-pod.

#### Day 4
* Continued working on the 'Statistieken-Screen'.
   * Tried to add a nice looking bar plot, but took very long because of little documentation.
* Made a lot of changes to the 'AppData-class', which is the class that stores all the information.
   * Created DateDict - output: year->month->[expenses] (all time)
   * Created categoryMonthMoneyDict - input: month, output: category->amount (per month)
   * Created categoryYearMoneyDict - input: year, output: category->amount (per year)
   * Created yearMoneyDict - input: year, output: month->amount (per year)
   * Created categoryDict - output: category->[expenses] (all time)
   * Created categoryMonthDict - output: category->amount (all time)
   

#### Day 5
* Finished a prototype of the app
   * Included bar graphs to the 'Statistieken-Screen'
   * Changed some code in 'Statistieken-Screen' so the colours in the pie-chart and bar-chart lined up
   * Cleaned some of the code
   * Started working on the category-editing system in 'Instellingen-Screen'
   
### Week 3
#### Day 1
* Finished the 'Instellingen-Screen'
   * Managed to add the whole category-editing system
   * Able to add and edit categories
   * Added some exceptions to remove bugs (no duplicates, every word starts with capital letter, no empty textfield, etc.)
   
#### Day 2
* Added colors to categories
* Changed 'Instellingen-Screen' to show selected colors
* Changed 'Weg-Screen' to show selected colors

#### Day 3
* 'Statistieken-Screen'-colors now matches category colors
* Changed entire UI

#### Day 4
* Finished category editing
   * Able to change priority of category
* Removed bugs
   * Changing category name crashed 'Weg-Screen'
   * Removing category crashed 'Weg-Screen'
   * Deleting all categories crashed 'Uitgave-Screen'

#### Day 5
* Fixed total expense
* Added horizontal gesture recognizer
* Added .csv download option

### Week 4
#### Day 1
* Added functionality to add expenses in the future.
   * Made some changes in the UI to make the view more readable.
* Added more category colours.

#### Day 2
* Started cleaning code
   * Added some comments.
   * Splitted some functions into more smaller functions.

#### Day 3
* Same as day 2.

#### Day 4
* Created REPORT.md
* Added a LICENSE
* Updated GIT

#### Day 5
* Made the product video


## Daily Standup
### Week 1
#### Day 2
* The app is for all users.
* The app makes your life happier by tracking your money spending
* See in which category you can save money

#### Day 3
* Research how to improve the app design
  * Tip: Make the spending overview a list of month-dropdowns
* Local storage on the Device

#### Day 4
* App design
* Local storage
* Dropdown menu's
* Big clickable buttons
* Nice light colours

#### Day 5
* App worked perfect
* No bugs where found by testing
* App didn't break by doing weird things (all exceptions were covered)

### Week 2
#### Day 1
* TWEEDE PINKSTERDAG

#### Day 2
* Came up with more ideas for the app
   * Give every category it's own color 
   * Give every category it's own icon
* Made a planning for the week
   * Every day is scheduled to work on a particular screen
   * Day 1: Nothing (Hemelvaart)
   * Day 2: Work on the 'Geld-Screen'
   * Day 3: Work on the 'Statistieken-Screen'
   * Day 4: Work on the 'Instellingen-Screen'
   * Day 5: Work on the 'Weg-Screen' (optimalisation)

#### Day 3
* Made a basic Style Guide which can be found under 'STYLE.md'
   * https://github.com/noudcorten/weggeld/blob/master/STYLE.md

#### Day 4
* Not much to discuss with other style guides. Almost all requirements in the style guide were similar.

#### Day 5
* Presented alpha version of the app.
   

### Week 3
#### Day 1
* Finishing the app on friday.
* Focus on making the UI better.
* Removing all bugs.

#### Day 2
* Plan for changes in the UI were correct.
* Changes in category editing system were tested and approved.

#### Day 3
* Github was OK.
   * TIP: Change the amount of steps to get to the code (current: weggeld/weggeld/weggeld/weggeld - no joke.)
   * TIP: Update the README.md to fit the current app better (screenshots of current UI)

#### Day 4
* Plan for finalizing product was made.
   * Start cleaning and commenting code.
   * Remove all bugs.
   * Wanted to add few more features (weekly- and monthly expenses (automatic)). After discussion decided to cut these features.

#### Day 5
* App worked OK
   * Found a bug with adding big numbers (crash with numbers larger than 1 * 10^25).
   * Some small changes in the UI were suggested.

### Week 4
#### Day 1
* Finilazing the app.
   * Clean code.
   * UI completely optimal.
   * If time left: try to add optional features.

#### Day 2
* TIP: Focus mainly on cleaning the code.
* TIP: Extra features could result in more bugs which can't be fixed due to time issues.

#### Day 3
* Made a plan for what to show in the product video.
   * Explain all possible features.
   * Talk about the main idea of the app.
   * Keep the video short and informative.
