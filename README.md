**RShiny - Map data visualisation project :**
___
This project is a simple implementation of an RShiny application that displays the spread of the complaints issued by citizens in Paris by region, type and time.

The app provides many tools to navigate and personnalise the networks display.

The data used in this project is from the opensource <a href="https://opendata.paris.fr/explore/dataset/dans-ma-rue/information/?disjunctive.type&disjunctive.soustype&disjunctive.code_postal&disjunctive.ville&disjunctive.arrondissement&disjunctive.prefixe&disjunctive.conseilquartier" target="_top">Paris data</a>.

The app is executed through the <code> shiny::runApp(here("DeclarationsMappingApp/app.R")) </code> command on R.

> #### Requirements :
___
- R language v > 2.10 
- leaflet
- RShiny
- here
- tidyverse
- ggplot2

> #### Snapshots : 
___
 - Map display examples :
 
![Map-display-dots](examples\map-example-dots.PNG)
![Map-display-disks](examples\map-example-disks.PNG)

 - Statistics example :

![file-edit](examples\map-example-stats.PNG)

> #### Bibliography : 
___

- shiny documentation : https://shiny.rstudio.com/
___
___
> #### Author : Benhari Abdessalam
> #### Date : 01/02/2020

