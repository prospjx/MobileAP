# FitQuest

## Overview
FitQuest is a Flutter mobile app for managing personal fitness challenges.
It lets users create goals, track progress, mark challenges complete, and manage basic preferences.

## Features
- Create, edit, and delete challenges
- Mark challenges as complete
- View challenge progress history
- Store challenge data locally with SQLite
- Store user preferences with SharedPreferences

## Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK compatible with `>=2.18.0 <3.0.0`
- Android Studio or VS Code with Flutter extension

### Installation
```bash
flutter pub get
```

### Running the Project
```bash
flutter run
```

## Usage
1. Open the app and wait for the splash screen.
2. Tap the add button on Home to create a challenge.
3. Fill in title, description, and numeric goal.
4. Save to store it in local SQLite.
5. Tap a challenge card to edit, complete, or delete.

## Project Structure
```text
lib/
	main.dart
	database/
		database_helper.dart
	models/
		challenge.dart
	screens/
		splash_screen.dart
		home_dashboard.dart
		create_challenge.dart
		challenge_details.dart
		progress_screen.dart
		settings_screen.dart
	utils/
		preferences.dart
	widgets/
		challenge_card.dart
```

## Local Data Design

### SQLite Table: `challenges`
- `id` INTEGER PRIMARY KEY AUTOINCREMENT
- `title` TEXT NOT NULL
- `description` TEXT
- `goal` INTEGER NOT NULL
- `progress` INTEGER NOT NULL
- `created_at` TEXT NOT NULL

CRUD methods are implemented in `lib/database/database_helper.dart`.

### SharedPreferences Keys
- `isDark` (bool)
- `streak` (int)

Preference access is implemented in `lib/utils/preferences.dart`.

## API Documentation
This project currently uses local storage only and does not consume external APIs.

## Tech Stack
- Flutter
- Dart
- sqflite
- shared_preferences
- path

## Contributing
1. Create a feature branch.
2. Keep changes focused and small.
3. Test affected flows before opening a PR.
4. Use clear commit messages.

## License
This project is for academic and educational use.

## Roadmap
- Add app-specific widget and integration tests
- Improve app-wide theme state synchronization
- Improve responsive behavior for landscape/tablet layouts
- Introduce scalable state management as the app grows

## Acknowledgments
- Flutter and package maintainers
- Instructors and teammates who supported project development
