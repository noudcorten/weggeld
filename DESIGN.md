# DESIGN

## Advanced sketch
<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/advanced_sketch_1-1.png" width="1000" height="500"/>
</p>
</body>

## Diagram
#### Utility Models
Class Name | View Controllers | Plug-ins
---------- | ---------------- | --------
Uitgave | GeldViewController | CAShapeLayer
AppData | WegViewController | CABasicAnimation
. | StatistiekViewController | PropertyListEncoder
. | UitgaveViewController | .

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

#### Databases
Uitgave | ***(Type)*** | AppData | ***(Type)***
------- | ------------ | ------- | ------------
bedrag | ***float*** | uitgaves[] | ***[Uitgave]***
categorie | ***string*** | total_amount | ***float***
datum | ***DateFormatter*** | current_amount | ***float***
omschrijving | ***string*** | . | .
