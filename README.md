<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A flutter package that allows programmatic access to the International Classification of Diseases (ICD) API.

## Features

This package allows you to search through the ICD database.

## Getting started

First, visit the [ICD API website](https://icd.who.int/icdapi), create or login into your acccount to get your "ClientID" and "ClientSecret" keys.

## Usage
1. Add this package to your pubspec.yaml
2. Import the package where neccessary
3. VERY IMPORTANT: Initialize the plugin preferably in the initState of your widget by passing your "ClientID" and "ClientSecret" keys.

```dart
ICD().initializeICDAPI(
    clientID:'your clientID',  
    clientScretKey:'your clientSecret',
);
```
4. Then you use the "searchICD" callback to search through the ICD Database. 

```dart
final List<ICDResult> results = ICD().searchICD(keyWord:'your search keyword');
```

## Additional information
- Visit the [ICD API website](https://icd.who.int/icdapi) for more info. 
- Feel free to lay your complaints, bugs or suggestions.
- If you want any feature, do let me know.

## TODO:
To improve on this ReadMe doc.
