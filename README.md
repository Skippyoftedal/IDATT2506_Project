# idatt2506_project


## Description
Cross-platform solution for the final task of idatt2506 (Applikasjonsutvikling for mobile enheter)




## Prerequisites

### Android
Android emulator: https://developer.android.com/studio/run/emulator

### Flutter
Make sure you download flutter for you platform, https://docs.flutter.dev/get-started/install/macos/mobile-android

### Setting ENV variables(Recommended for running in the terminal)

Make sure to set the ENV variables for both flutter and android to make the terminal commands below work better

On macOS, your env file should look something like this, depending on where flutter and android is downloaded:
```
export FLUTTER_HOME=/Users/Admin/Applications/flutter/flutter
export PATH="$FLUTTER_HOME/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```
### Separate Emulator (Optional)
If you do not want the whole IDE, it should also be possible to download it seperately by following this toturial: https://medium.com/@yohan.ardiansyah90/how-to-run-android-emulator-for-development-without-android-studio-f0e73682af3a

## Running the application from Android Studio (the easiest option):

1. Download the flutter plugin: https://plugins.jetbrains.com/plugin/9212-flutter
2. Start a device from the device manager located on the right side of the application
![image](https://github.com/user-attachments/assets/625bb818-3af1-4af1-ae6e-947ec01e431d)

3. Run the flutter app (main.dart) from the top menu by pressing the green play button


![image](https://github.com/user-attachments/assets/fffe6e83-b0f7-4ca1-9d4e-060bc6f71925)



## Running the application from the terminal:

1. Clone the project
```
    git clone https://github.com/Skippyoftedal/IDATT2506_Project.git
```

2. Check available devices:
```
    emulator -list-avds
```

3. Run the emulator with one of the available emulators from the last step:
```
    emulator @<name of an available emulator>
```

4. Launch flutter on all running devices
```
    flutter run
```
