# Algorytm genetyczny dla problemu komiwojażera (TSP)

Implementacja algorytmu genetycznego rozwiązującego problem komiwojażera w języku R.

Projekt wykorzystuje dane geograficzne z bazy GeoNames oraz optymalizuje trasę pomiędzy polskimi miastami przy użyciu:

* selekcji ruletkowej,
* krzyżowania Order Crossover (OX),
* mutacji swap,
* metryki Haversine.

## Pliki

### `data_loader.R`

Plik odpowiedzialny za wczytanie i przygotowanie danych.

Skrypt:

* wczytuje dane z pliku `PL.txt`,
* filtruje miejscowości,
* pozostawia:

  * nazwę miasta,
  * długość geograficzną,
  * szerokość geograficzną.

### `genetic_algorithm.R`

Główna implementacja algorytmu genetycznego dla problemu komiwojażera.

Skrypt:

* generuje początkową populację tras,
* oblicza długości tras,
* wykonuje selekcję, krzyżowanie i mutację,
* znajduje najkrótszą trasę pomiędzy miastami.

## Źródło danych

GeoNames geographical database:

https://download.geonames.org/export/dump/

## Wymagania

* R
* pakiet `geosphere`
