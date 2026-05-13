# Flutter Multimodule Architecture

A scalable and production-ready Flutter application architecture using a **multi-module approach** with **Clean Architecture**, **MVVM**, and **Flavor-driven development**.

This project demonstrates how to build enterprise-level applications with strictly separated layers, reactive state management, and a robust infrastructure for both REST and GraphQL.

---

## 🚀 Key Features

- **Multi-Module Structure**: Decoupled packages for `core`, `domain`, `network`, and feature-specific modules (`login_module`).
- **Clean Architecture & MVVM**: Strict separation of concerns. The `domain` layer contains pure business logic and entities, completely isolated from infrastructure and UI.
- **Advanced Flavor Support**: Native configuration for `dev`, `mock`, and `prod` environments on both Android and iOS with unique Bundle IDs and Application IDs.
- **Zero-Config Play Button**: Optimized Gradle and XCConfig setup that allows team members to run the app using the standard IDE Play button with automatic fallback to the `dev` flavor.
- **Smart Mocking System**: A generic `MockInterceptor` for Dio that serves local JSON responses from assets based on API endpoints—perfect for offline development.
- **GraphQL & Streaming**: Built-in support for GraphQL Queries, Mutations, and **Subscriptions**.
- **Reactive Base ViewModels**: Specialized `BaseStreamViewModel` for handling real-time data streams (WebSockets/GraphQL) with built-in `connect()`, `disconnect()`, and automatic memory management.
- **Global Localization (l10n)**: Full support for English and **Arabic (RTL)** with automatic layout mirroring and **parameterized translations** for dynamic content.
- **Core Services**: Example implementations like `BatteryService` demonstrating how to provide platform-specific data through the `core` module.
- **Robust Testing**: Comprehensive Unit and Widget testing suite using `mocktail` and JSON-driven test helpers that verify mapping logic from raw assets.

---

## 🏗️ Architecture Overview

The project follows a strict dependency rule: **Dependencies point inwards.**

| Module | Responsibility |
| :--- | :--- |
| **`core`** | Foundation: Shared widgets, Base ViewModels, Localization, Error Handling, and Global Services (e.g., Battery). |
| **`domain`** | The Heart: Pure business logic. Contains **Entities**, UseCases, and Repository interfaces. No dependencies on Flutter or Network. |
| **`network`** | Infrastructure: Dio implementation, GraphQL service, DTOs, Mappers, and Interceptors. Implements Domain repositories. |
| **`login_module`** | Feature: Specific UI implementation (Pages) and ViewModels. Depends only on `core`, `domain`, and `network`. |

---

## 📦 Project Structure

```bash
lib/
├── di/                # Global Service Locator (GetIt)
├── providers/         # Global Provider registration (Locale, Auth, etc.)
└── main_*.dart        # Entry points for flavors (Dev, Mock, Prod)

packages/
├── core/              # Shared logic, widgets, localization, and base services
├── domain/            # Business rules and Entities (The "Truth")
├── network/           # API Implementation (Dio, GraphQL, Mappers, DTOs)
└── features/
    └── login_module/  # Encapsulated Login & Dashboard features
```

---

## 🎨 Flavors & Environments

Each flavor is configured at the native level (Gradle/Xcode) to ensure consistency.

| Flavor | Purpose | Entry Point | API Source | ID Suffix |
| :--- | :--- | :--- | :--- | :--- |
| **Dev** | Development | `main.dart` | Real Backend API | `.dev` |
| **Mock** | Offline/Demo | `main_mock.dart` | Local JSON Assets | `.mock` |
| **Prod** | App Store | `main_prod.dart` | Production Server | (None) |

### How to Run:
```bash
# Run Dev flavor (Default)
flutter run --flavor dev

# Run Mock flavor (Uses local JSON)
flutter run --flavor mock

# Run Prod flavor
flutter run --flavor prod -t lib/main_prod.dart
```

---

## 🌍 Localization

The app uses the official Flutter `intl` system.
1. Add/Edit strings in `packages/core/lib/l10n/*.arb`.
2. Generate Dart code:
   ```bash
   cd packages/core
   flutter gen-l10n
   ```
3. Use in UI: `AppLocalizations.of(context)!.yourKey`.
   - Supports parameters: `translations.welcomeMessage(userName)`
   - Supports RTL: Layouts automatically flip for Arabic.

---

## 🧪 Testing

The project emphasizes testing the data flow from raw JSON to the UI.

```bash
# Run all tests from root
flutter test

# Run specific module tests
cd packages/features/login_module
flutter test
```

---

## 👨‍💻 Author

**Hardik Patel**
- Android & Flutter Specialist
- [GitHub](https://github.com/hardikpatel679)

---

## 📄 License

This project is licensed under the MIT License.
