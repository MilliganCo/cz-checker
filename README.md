# CZ Checker

## Setup

This project is a minimal Flutter project for Android + iOS with Flutter 3.22 / Dart 3.4 and null-safety enabled.

To get started, ensure you have the following installed:

*   Flutter SDK `>=3.22.0 <4.0.0`
*   Dart 3.4
*   Android Studio / VS Code (without specific plugins)

1.  **Clone the repository (if applicable) or navigate to the project directory.**

2.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **For iOS flavors, you need to configure Xcode manually:**
    *   Open `ios/Runner.xcworkspace` in Xcode.
    *   **Create Schemes:** Go to `Product > Scheme > New Scheme...` and create two schemes: `Dev` and `Prod`. Make sure they are `Shared`.
    *   **Create Configurations:** In the Project Navigator, select `Runner` (Project section), go to the `Info` tab. In the `Configurations` section, duplicate `Debug`, `Profile`, and `Release` configurations to create `Debug-dev`, `Debug-prod`, `Profile-dev`, `Profile-prod`, `Release-dev`, `Release-prod`.
    *   **Assign Configurations to Schemes:** Go to `Product > Scheme > Manage Schemes...`, select `Dev` and `Prod` schemes, and edit them to assign the corresponding `-dev` and `-prod` build configurations for `Run`, `Test`, `Profile`, `Analyze`, and `Archive`.
    *   **Set Display Names:** In `Runner` (TARGETS section), go to `Build Settings`. Add a `User-Defined Setting` called `BUNDLE_DISPLAY_NAME`. Set `Debug-dev`, `Profile-dev`, `Release-dev` to `CZ Checker Dev` and `Debug-prod`, `Profile-prod`, `Release-prod` to `CZ Checker`. Then, in the `Info` tab, set `Bundle display name` to `$(BUNDLE_DISPLAY_NAME)`.
    *   **Set Bundle Identifiers:** In `Runner` (TARGETS section), go to `Build Settings`. In `Packaging`, expand `Product Bundle Identifier`. Set `*-dev` configurations to `com.example.czchecker.dev` and `*-prod` (and default `Debug`, `Profile`, `Release`) configurations to `com.example.czchecker`.
    *   **Update Podfile:** Edit `ios/Podfile` to include: 
        ```ruby
        project 'Runner', {
          'Debug' => :debug,
          'Debug-dev' => :debug,
          'Debug-prod' => :debug,
          'Profile' => :release,
          'Profile-dev' => :release,
          'Profile-prod' => :release,
          'Release' => :release,
          'Release-dev' => :release,
          'Release-prod' => :release,
        }
        ```
    *   Run `pod install` from the `ios` directory: `cd ios && pod install`.

4.  **Place Icons:**
    *   Place your `icon_dev.png` and `icon_prod.png` (1024x1024 PNG) in the `assets/icons/` directory.

5.  **Generate Launcher Icons:**
    ```bash
    flutter pub run flutter_launcher_icons:main
    ```

## Flavors

This project is configured with two flavors: `dev` and `prod`.

*   **`dev` flavor:**
    *   Android Application ID: `com.example.czchecker.dev`
    *   Android Version Name Suffix: `-dev`
    *   iOS Bundle Identifier: `com.example.czchecker.dev`
    *   iOS Display Name: `CZ Checker Dev`
    *   Uses `assets/icons/icon_dev.png` for launcher icon.

*   **`prod` flavor:**
    *   Android Application ID: `com.example.czchecker`
    *   Android Version Name Suffix: (none)
    *   iOS Bundle Identifier: `com.example.czchecker`
    *   iOS Display Name: `CZ Checker`
    *   Uses `assets/icons/icon_prod.png` for launcher icon.

## Run

To run the application with a specific flavor:

*   **Run `dev` flavor:**
    ```bash
    flutter run --flavor dev -t lib/main_dev.dart
    ```

*   **Run `prod` flavor:**
    ```bash
    flutter run --flavor prod -t lib/main_prod.dart
    ```

## Build

To build the application for release:

*   **Build `dev` flavor (APK):**
    ```bash
    flutter build apk --flavor dev -t lib/main_dev.dart
    ```

*   **Build `dev` flavor (AAB):**
    ```bash
    flutter build appbundle --flavor dev -t lib/main_dev.dart
    ```

*   **Build `prod` flavor (APK):**
    ```bash
    flutter build apk --flavor prod -t lib/main_prod.dart
    ```

*   **Build `prod` flavor (AAB):**
    ```bash
    flutter build appbundle --flavor prod -t lib/main_prod.dart
    ```

## Code Generation

To generate code for models (e.g., JSON serialization):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## State Management

This project uses `flutter_riverpod` for state management.

*   `ScannedItemsNotifier`: Manages the list of scanned items, handles adding new items, fetching their status from `CrptApi`, and updating the items in the list. It also enforces a maximum list size of 500 items.
*   `scannedItemsProvider`: A `StateNotifierProvider` that exposes the `ScannedItemsNotifier`.

## UX

Карточки автоматически меняют цвет: зелёный — в обороте, оранжевый — нет,
красный — ошибка, серый — проверяется.

## CI / Анализ

`dart analyze --fatal-infos` — локальная проверка кода, CI вызывает ту же
команду. Ошибки и даже предупреждения (infos) считаются блокирующими.

## Сборка

```bash
# dev-APK
flutter build apk --flavor dev -t lib/main_dev.dart
# prod-APK
flutter build apk --flavor prod -t lib/main_prod.dart
# release AAB (prod)
flutter build appbundle --flavor prod -t lib/main_prod.dart
```
