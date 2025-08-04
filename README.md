# Android Base Template

A modern Android project template using Jetpack Compose, Kotlin, and following clean architecture principles. This template provides a solid foundation for building Android applications with best practices and modern libraries.

## Features

- **Jetpack Compose UI**: Modern declarative UI toolkit
- **Kotlin**: 100% Kotlin codebase with Kotlin DSL for Gradle
- **Clean Architecture**: Separation of concerns with proper layering
- **Dependency Injection**: Hilt for dependency injection
- **Navigation**: Jetpack Navigation Compose for navigation between screens
- **Kotlin Serialization**: For JSON parsing
- **Material 3 Design**: Modern Material Design components
- **Unit Testing**: Setup with MockK and JUnit
- **Java 21 Support**: Configured for the latest Java version
- **Gradle Version Catalog**: Centralized dependency management

## Project Structure

```
app/
├── src/
│   ├── main/
│   │   ├── java/com/blank/basetemplate/
│   │   │   ├── data/            # Data layer: repositories, data sources
│   │   │   ├── di/              # Dependency injection modules
│   │   │   ├── ui/              # UI layer: screens, components, themes
│   │   │   │   ├── home/        # Home screen components
│   │   │   │   ├── theme/       # Theme definitions
│   │   │   │   ├── MainNavGraph.kt    # Navigation graph
│   │   │   │   └── MainNavigation.kt  # Navigation routes
│   │   │   ├── MainActivity.kt  # Main activity
│   │   │   └── MainApp.kt       # Application class
│   │   └── res/                 # Resources
│   ├── androidTest/             # Android instrumentation tests
│   └── test/                    # Unit tests
└── build.gradle.kts             # App module build script
```

## Architecture

This template follows Clean Architecture principles with the following layers:

- **UI Layer**: Compose UI components, screens, and ViewModels
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Repositories and data sources

The architecture promotes:
- Separation of concerns
- Testability
- Maintainability
- Scalability

## Getting Started

### Using the Template

To create a new project from this template, use the provided script:

```bash
./android-copy-template.sh <target-folder> <package-name> <project-name>
```

For example:

```bash
./android-copy-template.sh ~/projects/MyNewApp com.example.mynewapp "My New App"
```

#### On Windows (using Git Bash)

```bash
./android-copy-template.sh /c/projects/MyNewApp com.example.mynewapp "My New App"
```

The script will:
1. Copy the template to the target folder
2. Update the package name in all relevant files
3. Update the application ID and namespace
4. Rename the project
5. Update the folder structure to match the new package name

### Development

1. Open the project in Android Studio
2. Sync Gradle files
3. Run the app on an emulator or device

## License

[MIT License](LICENSE)