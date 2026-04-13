# Task Manager (Flutter + Firebase)

A simple task manager app built with Flutter and Cloud Firestore.

## Features

- Add task with input validation (ignores empty titles)
- Live Firestore task sync
- Toggle task completion
- Delete tasks
- Add/remove list animations using AnimatedList + fade/size transitions
- Dark mode support using ThemeMode.system

## Tech Stack

- Flutter
- Firebase Core
- Cloud Firestore

## Project Structure

- lib/main.dart: app entry point, Firebase initialization, theme setup
- lib/screens/task_list_screen.dart: task UI and Firestore list logic
- lib/model/task.dart: Task data model with Firestore mapping
- lib/firebase_options.dart: generated FlutterFire config

## Prerequisites

- Flutter SDK installed
- Firebase project configured
- FlutterFire CLI run for target platforms

## Run Locally

1. Install dependencies:

```bash
flutter pub get
```

2. Run the app:

```bash
flutter run
```

## Firebase Notes

- This project currently includes Firebase options for Android.
- If running on other platforms, regenerate firebase_options.dart with FlutterFire:

```bash
flutterfire configure
```

## Validation Commands

```bash
flutter analyze
flutter test
```

If tests fail, update widget tests to match the current Firestore-based UI or mock Firebase.
