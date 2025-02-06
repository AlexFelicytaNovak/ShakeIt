<p align="center">
    <img width="150" alt="ShakeIt Logo" src="https://github.com/user-attachments/assets/5ea55a9c-d357-4a6c-88e0-e6d51014ace6">
</p>

# 🍸 ShakeIt 
**ShakeIt** is a mobile app for searching and creating cocktails. The app's logic is written in **Swift**, while its UI is built using **SwiftUI**. The [TheCocktailDB](https://www.thecocktaildb.com/api.php) API is used as the source for predefined cocktails and available ingredients.

Once a day, the user can randomly draw the "Drink of the Day" by shaking their phone, triggering a fun animation with haptic feedback. Cocktails can be saved to favourites and easily shared. The application schedules notifications to inform users about new "Drink of the Day" cocktails.

Unit Tests and automated UI testing are performed via the XCTest framework. The application supports Polish 🇵🇱 and English 🇬🇧 languages via localizations. 

## 🏗️ Application Architecture
This application follows Model-View-ViewModel architecture, where *Models* are the API responses, as well as the favourite cocktails stored in CoreData. *Views* are the SwiftUI views responsible for displaying content, while *ViewModels* hold the current state of the Views and perform actions in response to UI events.

## 🔨 Installation
In order to install the application you need a Mac with **Xcode 14 or later** installed.

1. Open `ShakeIt.xcodeproj` in Xcode.
2. Select ShakeIt build target. 
3. Build and Run on your chosen device (such as an iPhone 14 Pro simulator).

## 📸 Screenshots
<img width="350" alt="shakeItHome" src="https://github.com/user-attachments/assets/2aefa410-6122-4fa1-9800-e771224d3499">

<br>

<img width="300" alt="favourite" src="https://github.com/user-attachments/assets/781e6404-d8f4-40a4-ada7-d3dd439a905c">
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;

<img width="300" alt="drinkShake" src="https://github.com/user-attachments/assets/05148edb-3050-4ab2-b0e0-0bd2e4b968f3">

## 📄 Credits
ShakeIt was developed as part of the **Mobile Application Development with Swift** at **Technical University of Denmark**.

### Contributors
- **Zofia Łągiewka** - [zosialagiewka](https://github.com/zosialagiewka)
