# WeatherAppIOS

## Context

The application will be made of 2 modules:
* A component part that collects weather information from an API
* A User Interface Application that displays the informations from the componenents

## Features

* As a User I should be able  to add a list of towns to follow their weather by searching the suitable one using the Mapkit search.

* As a User I should see the results as a list. One town per row.

* As a User I should be able to consult a town weather details(current Weather, daily Weather...). 

* As a User I  can add my current location to the list of towns. 

* As a User I  can  delete a town from the list. 


## General principles


**Principle of cache management**


Each time a webservice consumed, the application looks for the latest version of the data from the server and saves it in a local cache.

When the user goes offline, the application uses cache data until the connection is restored.


## Web Services

To get the weather information for each favourite town , you'll need to use the following API : 

URL : ```https://openweathermap.org/api/one-call-api```

## Usage

To run the example project, you need just to clone the repo.

