# Flutter Cinematic

This app is a Flutter port of the native Android App [Cinematic](https://github.com/aaronoe/Cinematic).
My intention in creating this app was understanding the intricacies of building apps in Flutter.
Just like the native Android App this app does **not make any efforts in being a nicely architectured application**.
That being said the whole point is to showcase Flutter's capabilities for building simple apps 
and to understand key difference and advantages to native development.

## Overview

The app uses the [Movie DB Public API](https://www.themoviedb.org/documentation/api) as a data 
sources and uses the standard dart libraries for making network requests.

In terms of UI, the goal was replicating the Android design as closely as possible to understand
the possibilities that Flutter offers for crafting UIs.

## Building from Source

To build this app from source you will have to obtain an API-key from [TMDB right here](https://developers.themoviedb.org/3/getting-started/introduction).
Set this key to the constant `API_KEY` in `constants.dart` to run the app.
Additionally, the app now uses Dart2 which means that you should enable that in your IDE if you haven't done so yet.

## Video

![In App Experience](https://github.com/aaronoe/FlutterCinematic/blob/master/screenshots/flutter_cinematic_gif.gif?raw=true)

## Learnings

Creating this app and learning Flutter in general felt like a gift for developers.
It significantly increased development velocity by, amongst others, 
reducing development cycles and the ability to create reactive, modular components.
Coming from the realms of Android, those are the things that stood out to me:
- Creating beautiful UIs is easier with Flutter
- Avoiding to write boilerplate code (XML layouts, adapters etc.)
- Creating UIs in a declarative way without dealing with the shortcomings of Android's Databinding
- Hot Reload - this one is a **game-changer**
- Dart is not that bad of a language, but it doesn't get close to Kotlin. 
I think for the Usecase of Flutter Dart actually makes a lot of sense
- The ability to not worry about state changes in the UI. The Widget will take care of the rendering 
using it's properties or state

SIMPLE & USEFUL SETUP FOR FLUTTER DEV.
PC = i5, i3
RAM <= 8GB
If working with Andriod Studio Emulator/ Microsoft VSS and this slows down your PC and your work.
Don't Worry
Please use Vysor.
Step 1: Install the Vysor on your PC.
Step 2: Install Vysor on your Smartphone form Google Play Store.
Step 3:Turn the USB Debugging in Develop's Option to ON.
Step 4: Connect with the USB Cable with phone and PC
Step 5: Open  Vysor on PC after Plugging in your Smartphone.
Step 6: Let PC Vysor automatically detect your Smartphone.
Step 7: Automatic APK will get install on your Smartphone. Don't worry it will take 10 Seconds.

--Anytime you will connect ypur phone with PC , it will automatically connected--


AFTER ALL THIS , NOW YOU CAN VIEW YOUR FLUTTER UI AND THEIR OPERATION WITH BACKEND(IF ANY CONNECTED WITH DATABASE) ON YOUR SMARTPHONE.
ENJOY.......

```
## License

This project utilizes the [MIT License](https://github.com/aaronoe/FlutterCinematic/blob/master/LICENSE "Project License")
