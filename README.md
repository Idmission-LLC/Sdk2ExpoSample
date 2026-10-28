# Sdk2ExpoSample

Expo (SDK 58, React Native 0.88) sample app for the IDmission SDK 2.0. The app lives in `IDMExpo/`.

## Requirements

- Node.js 22, 24 or 26+
- Yarn 1.x
- Android: JDK 17 and the Android SDK
- iOS: Xcode and CocoaPods

## Setup

```sh
cd IDMExpo
yarn install
```

### Android: IDmission SDK repository token

The Android SDK (`com.idmission.sdk2:idmission-sdk`) is downloaded from IDmission's GitLab package
registry, which needs an access token. The token is **not** stored in this repo. Add it to your
user-level Gradle properties (`~/.gradle/gradle.properties`):

```properties
idmGitlabReadToken=<your token>
```

or set it as an environment variable (`export idmGitlabReadToken=<your token>`), for example in CI.

### iOS: IDmission SDK

The iOS SDK comes from CocoaPods (`IDentityMediumSDK2.0`, `IDentityMediumModels`). Install pods:

```sh
cd IDMExpo/ios
pod install
```

## Configure

Set your IDmission API base URL, auth URL, debug flag and access token at the top of `IDMExpo/App.js`.
The Android app uses the IDmission medium SDK (`idmission-mediumsdk`).

## Run

```sh
cd IDMExpo
yarn android   # build and run on a connected Android device or emulator
yarn ios       # build and run on iOS
```

## Native bridge

The JavaScript app calls the SDK through a native module named `IDMissionSDK`:

- Android: `IDMExpo/android/app/src/main/java/com/idmtest/IDMissionSDK.java` (registered in `MainApplication.kt`)
- iOS: `IDMExpo/ios/IDMExpo/IDMissionSDK.m` and `IDentitySDKHelper.swift`

Running `npx expo prebuild --clean` regenerates `android/` and `ios/` and **removes** this bridge code and
the SDK setup in the Gradle files and Podfile. Don't run it without re-applying those changes.
