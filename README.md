# WegGeld
Weggeld is **de** app voor het bijhouden van de maandelijke uitgaves. In deze app is het mogelijk om bij te houden waar al je geld elke maand naar toe gaat en waar er misschien bespaart kan worden. Elke maand kies je een bedrag wat je wilt gaan uitgeven en deze app houdt bij in hoeverre dit bedrag al gehaald is. De app zal voorzien zijn van een makkelijk maandelijks overzicht en mooie statistieken waarin je jouw uitgaves kan bekijken.

## Student Information
* Naam: Noud Corten
* Studentnummer: 11349948
* Platform: iOS (Swift)

## Problem Statement
Iedereen kent het probleem van te weinig geld hebben op je bankrekening. Elke maand wordt er een bedrag gestort op je rekening, maar op magische wijze is dit bedrag binnen een paar weken weg. Deze app is **de** oplossing voor het goed bijhouden van je uitgaves, waardoor je precies in de gaten hebt als je ergens te veel geld aan uitgeeft. Het zorgt voor veel overzicht op financieel vlak en zorgt ervoor dat je precies weet wanneer je moet stoppen met geld uitgeven. 

## Solution
### Description 
Een app waarin de gebruiker zijn/haar maandelijkse kosten kan bijhouden.

### Visual Sketch
<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/GeldScreen.png" width="280" height="500"/>
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/WegScreen.png" width="280" height="500"/> 
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/StatistiekenScreen.png" width="280" height="500"/> 
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/InstellingenScreen.png" width="280" height="500"/> 
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/UitgaveScreen.png" width="280" height="500"/> 
  <img src="https://github.com/noudcorten/weggeld/blob/master/docs/CategorieScreen.png" width="280" height="500"/> 
</p>
</body>

### Main Features
* Bijhouden van bedrag dat nog mag worden uitgegeven.
* Toevoegen van kosten met daarbij extra informatie (categorie, datum en extra informatie)
* Progress cirkel die vertelt welk percentage van het totale bedrag er is uitgegeven.
* Het zien van alle uitgaves per maand.
* Weergeven van statistieken van de uitgaves.
* Het zelf toevoegen/aanpassen van de categorieën (naam en kleur)
* Het downloaden van alle uitgaves als een .csv bestand.

### Product Video
* https://youtu.be/oRmRVtpcyb4

## Prerequisites
### Data Sources
* Deze app maakt geen gebruik van Data Sources

### External Components
* CAShapeLayer
    * Wordt gebruikt voor het visualiseren van de progress-bar en statistieken.
* CABasicAnimation
    * Wordt gebruikt voor het toevoegen van effecten tijdens het weergeven van de data.
* PropertyListEncoder
    * Wordt gebruikt voor het lokaal opslaan van de data.
* Charts
    * Pod die wordt gebruikt voor het maken van de grafieken.
