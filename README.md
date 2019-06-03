# WegGeld
Weggeld is **de** app voor het bijhouden van de maandelijke uitgaves. In deze app is het mogelijk om bij te houden waar al je geld elke maand naar toe gaat en waar er misschien bespaart kan worden. Elke maand kies je een bedrag wat je wilt gaan uitgeven en deze app houdt bij in hoeverre dit bedrag al gehaald is. De app zal voorzien zijn van een makkelijk maandelijks overzicht en mooie statistieken waarin je jouw uitgaves kan bekijken.

## Student Information
Naam: Noud Corten
Studentnummer: 11349948
Platform: iOS (Swift)

## Problem Statement
Iedereen kent het probleem van te weinig geld hebben op je bankrekening. Elke maand wordt er een bedrag gestort op je rekening, maar op magische wijze is dit bedrag binnen een paar weken weg. Deze app is **de** oplossing voor het goed bijhouden van je uitgaves, waardoor je precies in de gaten hebt als je ergens te veel geld aan uitgeeft. Het zorgt voor veel overzicht op financieel vlak en zorgt ervoor dat je precies weet wanneer je moet stoppen met geld uitgeven. 

## Solution
### Description 
Een app waarin de gebruiker zijn/haar maandelijkse kosten kan bijhouden.

### Visual Sketch
<body>
<p float="left">
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/app_screen_1.png" width="280" height="500"/>
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/app_screen_2.png" width="280" height="500"/> 
  <img src="https://github.com/noudcorten/weggeld/blob/master/doc/app_screen_3.png" width="280" height="500"/> 
</p>
</body>

### Main Features
* Bijhouden van bedrag dat nog mag worden uitgegeven.
* Toevoegen van kosten met daarbij extra informatie (categorie, datum, beschrijving, etc.)
* Progress bar die vertelt welk percentage van het totale bedrag er is uitgegeven.
* Het zien van alle uitgaves van de gekozen maand.
* Weergeven van statistieken van de uitgaves.

### MVP
* Totaal bedrag dat verandert na het toevoegen van een uitgave.
* Het toevoegen van een uitgave.
* Een opsomming van uitgaves.
* Een cirkeldiagram die de kosten per categorie weergeeft in een cirkeldiagram.

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
    
### Similar
* De apps die vergelijkbaar zijn met deze app beschikken vooral over de mogelijkheid om kosten toe te voegen en te zien wat er totaal is uitgegeven.
* In deze apps is het niet mogelijk om een bepaald bedrag per maand aan te geven wat je maximaal wilt uitgeven.
* De uitgaves zijn in de apps niet overzichtelijk weergegeven.
* Er worden in deze apps geen duidelijke statistieken weergegeven van de data.

### Hardest Parts
* Het lokaal opslaan van de data.
* Het toevoegen van een uitgave en deze weer te geven.
* Het meteen updaten van het model na het toevoegen van een uitgave.
* Het weergeven van de data in statistieken.
