# DESIGN

## Design doc
### Advanced sketch
<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/advanced_sketch_1-1.png" width="1000" height="500"/>
</p>
</body>

### Diagram
#### Utility Models
Class Name | View Controllers 
---------- | ----------------
Uitgave | GeldViewController
AppData | WegViewController 
. | StatistiekViewController
. | UitgaveViewController

#### Classes
Uitgave | AppData
------- | -------
get_details() | get_total_value()
. | save_data()
. | add_item()
. | delete_item()
. | all_items[]

#### View Controllers
GeldViewController | WegViewController | StatistiekViewController | UitgaveViewController
------------------ | ----------------- | ------------------------ | ---------------------
geldLabel | datePicker | datePicker | bedragLabel
progressBar | sortBySelector | graphImage | categoryPicker
uitgaveList | uitgaveList | categoryLegenda | datePicker
addItemButton | addItemButton | . | descriptionTextBox
. | . | . | saveButton
