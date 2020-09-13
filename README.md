# ExchangeRates

## by Roland Lariotte


This Xcode project is part of an assessment test for the IOS developer position at IronFX.


contact: roland.lariotte@gmail.com



### Starter

● Start the project using Xcode 11.

● Add your Apple team membership in the Signing & Capabilities for the ExchangeRates, ExchangeRatesTests and ExchangeRatesUITests targets.

● Add your API key of the https://currencylayer.com/ website in the Xcode project following this path: 

- ExchangeRates project folder
- SupportingFiles
- NetworkIronFX.plist
- Root
- apiKey
- currencylayer

Your api key must be added to the empty value of the currencylayer key.

You can always change the api baseURL to a https if your currencylayer subscription plan allows it.

(My api key has been hidden using .gitignore, if you need it, send me a message via my contact details)

The application was set to trigger api calls every 65 seconds regarding the currencylayer documentation.
It is set for a business plan subscription.
https://currencylayer.com/plan



### Introduction

ExchangeRates is an iPhone application with a minimum target of iOS13. It had been written using mostly the SwiftUI, Combine and CoreData frameworks in a MVVM architecture. 



### Discussion


#### 1. UI/UX

This application is set with two tabs on version 1.0 with an UI/UX matching the Apple Human Interface Guideline at its best.

There is also a Documentation folder in the root project with a .sketch file inside that contains: 

- the app icon 
- the logo and background images used in the launchscreen
- a custom symbol file that is used for the tab bar image
- iPhone mockups with screenshots for the AppStore


#### 2. Code Design

As it is a MVVM architecture, the SwiftUI views are being manipulates by two view models that handles the app logic and the models. Each tab has its corresponding view models to be able to expand more logic and views in furure releases. 

The RatesViewModel handles the RatesView and the DetailsView.

The FavoritesViewModel handles the FavoritesView.

CoreData was used to enable the user to save his/her favorite rates. This action of saving can be done via the details view by clicking on the star. To delete the favorites rates, the user can, via the FavoritesView, swiping the cell to delete or clicking on the edit button in the navigation bar. He/She can also delete the favorite rate by clicking again on the star presented in the DetailsView.

There is a Timer Publisher tool that handles the api calls intervals.

The localizables folder in the project handles the app translations for as many languages as needed for a release.


#### 3. Tests

XCTestPlan was used for the Unit and UI Tests. It is better to use, as many configurations can be made for different tests cases.

As for the screenshots, a Pre-actions and Post-action was added to the Test scheme for the simulator to show a status bar with the regular App Store screenshots settings.


#### 4. Third-party libraries

No cocoapods or swift libraries where used in this project. I personally try to avoid them as much as possible for a better maintenance of the application. They are used as a very last option.


![ExchangeRates App](/ExchangeRates/Documentation/Mockups/RatesView.png)
