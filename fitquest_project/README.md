# Project Title

FitQuest

## Overview

FitQuest is a Flutter fitness habit tracker that helps users create challenges and complete goals day by day.

Each challenge has a numeric goal (for example, 10 days). Users mark daily progress using day circles until all required days are completed.

## Features

- Create, edit, and delete challenges
- Set a positive numeric goal for each challenge
- Sequential day-based progress tracking (Day 1 to Day N)
- Completed challenges view in the progress tab
- Local persistence using SQLite
- Theme preference persistence using shared preferences

## Getting Started

Follow the setup steps below to run FitQuest locally.

## Prerequisites

- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio or VS Code with Flutter and Dart extensions
- Android emulator or physical Android device

## Installation

1. Clone the repository.
2. Navigate to the project folder.
3. Install dependencies:

```bash
flutter pub get
```

## Running the Project

Run on the default connected device:

```bash
flutter run
```

Run on a specific device:

```bash
flutter run -d <device_id>
```

## Usage

1. Open the app and create a challenge.
2. Enter title, description, and goal.
3. Open challenge details and check day circles in order.
4. Complete all day circles to mark a challenge as completed.
5. View completed challenges in the Progress tab.

## Project Structure

- `lib/main.dart`: app entry point and app-level theme configuration
- `lib/database/database_helper.dart`: challenge database operations
- `lib/models/challenge.dart`: challenge data model
- `lib/screens/home_dashboard.dart`: dashboard and bottom navigation
- `lib/screens/create_challenge.dart`: create and edit challenge form
- `lib/screens/challenge_details.dart`: day-by-day challenge tracker
- `lib/screens/progress_screen.dart`: completed challenges list
- `lib/screens/settings_screen.dart`: settings and theme toggle

## API Documentation

This project currently uses local database access and does not expose a public REST API.

Internal data model highlights:

- `goal`: total number of required days
- `progress`: number of completed days

## Tech Stack

- Flutter
- Dart
- sqflite
- sqflite_common_ffi
- sqflite_common_ffi_web
- shared_preferences

## Contributing

Contributions are welcome.

Contributors:

- Prosper Olusegun-Joseph
- Jabril Jeylani

## License

No license file is currently defined in this repository.

If needed, add a `LICENSE` file (for example MIT) and update this section.

## Roadmap

- Add challenge categories and tags
- Add reminders and notifications
- Improve analytics and streak visualization
- Add cloud backup and sync
- Add unit and widget test coverage

## Acknowledgments

- Flutter documentation and ecosystem
- sqflite maintainers and contributors
- Android emulator tooling support
