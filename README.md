# Flutter Multimodule Architecture

A scalable and production-ready Flutter application architecture using a **multi-module approach** with **Clean Architecture**, **MVVM**, and **Flavor-driven development**.

This project demonstrates how to build enterprise-level applications with strictly separated layers, reactive state management, and a robust mocking system for offline development.

---

## 🚀 Key Features

- **Multi-Module Structure**: Decoupled packages for `core`, `domain`, `network`, and feature-specific modules (`login_module`).
- **Clean Architecture & MVVM**: Separation of concerns between UI (View), State/Logic (ViewModel), Business Rules (Domain), and Infrastructure (Data).
- **Advanced Flavor Support**: Native configuration for `dev`, `mock`, and `prod` environments on both Android and iOS.
- **Smart Mocking System**: A generic `MockInterceptor` that serves local JSON responses from assets based on API endpoints—ideal for offline development.
- **GraphQL Integration**: Built-in support for GraphQL Queries, Mutations, and **Reactive Subscriptions** (Streams).
- **Global Localization (l10n)**: Comprehensive support for English and **Arabic (RTL)** with automatic layout mirroring and parameterized translations.
- **Reusable Component Library**: Standardized `CustomText` and `CustomTextField` components in the `core` module.
- **Reactive Base ViewModels**: Specialized `BaseStreamViewModel` for handling real-time data streams with automatic memory management.
- **Robust Testing**: Comprehensive Unit and Widget testing suite using `mocktail` and JSON-driven test helpers.

---

## 🏗️ Architecture Overview

The project follows a strict dependency rule: **Dependencies point inwards.**

| Module | Responsibility |
| :--- | :--- |
| **`core`** | Foundation: Shared widgets, Base ViewModels, Localization, Error Handling, and global entities. |
| **`domain`** | Business Logic: UseCases and Repository interfaces. Pure Dart, no dependencies on UI or Network. |
| **`network`** | Infrastructure: Dio implementation, GraphQL service, DTOs, Mappers, and Interceptors. |
| **`login_module`** | Feature: Specific UI implementation and ViewModels for authentication. |

---

## 📦 Project Structure

```bash
lib/
├── di/                # Global Service Locator (GetIt)
├── providers/         # Global Provider registration
└── main_*.dart        # Entry points for flavors (Dev, Mock, Prod)

packages/
├── core/              # Shared logic, widgets, and localization
├── domain/            # UseCases and Repository contracts
├── network/           # API Implementation (Dio, GraphQL, Mappers)
└── features/
    └── login_module/  # Encapsulated Login feature
```

---

## 🎨 Flavors & Environments

This project uses native product flavors. Each flavor can have its own unique Application ID, Suffix, and Entry point.

| Flavor | Purpose | Entry Point | API Source |
| :--- | :--- | :--- | :--- |
| **Dev** | Development | `main.dart` | Real Backend API |
| **Mock** | Offline/Demo | `main_mock.dart` | Local JSON Assets |
| **Prod** | App Store | `main_prod.dart` | Production Server |

### How to Run:
```bash
# Run Dev flavor
flutter run --flavor dev

# Run Mock flavor (Uses local JSON)
flutter run --flavor mock

# Run Prod flavor
flutter run --flavor prod -t lib/main_prod.dart
```

---

## 🌍 Localization

The app supports **English** and **Arabic**.
1. Add strings to `packages/core/lib/l10n/*.arb`.
2. Generate Dart code:
   ```bash
   cd packages/core
   flutter gen-l10n
   ```
3. Use in UI: `AppLocalizations.of(context)!.yourString`.

---

## 🧪 Testing

The project uses `mocktail` for dependency-free mocking and includes a `TestHelper` that uses the same JSON assets as the Mock flavor.

```bash
# Run all tests
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
