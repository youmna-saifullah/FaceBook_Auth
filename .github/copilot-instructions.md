# AI Rules for My Flutter Project

## 🔗 Model & IDE Integration
- This project will be connected with:
  - **Model Name:** Claude Sonnet 4.5
  - **IDE:** Visual Studio Code
- AI assistance must follow clean architecture, Flutter best practices,
  and null safety.
- All generated code must be production-ready and structured.

---

# 🎯 Project Overview

This is a Flutter application built using Clean Architecture and feature-based structure.

## Main Functionality

- Facebook Authentication using Firebase
- Fetch user profile data from Facebook
- Display user data on Home Screen
- Logout functionality
- Show success and error messages via SnackBar
- Push notifications using Firebase Messaging
- Secure local storage using Flutter Secure Storage
- Image selection using Image Picker
- Network calls handled using Dio
- Dependency injection using GetIt
- State management using Provider
- Navigation using GoRouter
- Fully responsive UI using device_preview
- Royal Blue & Royal Green themed UI
- Error handling at every step

---

# 🏗 Architecture

This project strictly follows Clean Architecture:

lib/
├── app/
├── core/
├── features/
└── main.dart

## Architecture Layers

### 1️⃣ Presentation Layer
- Screens
- Widgets
- Providers (State Management)
- GoRouter Navigation
- SnackBars & UI feedback

### 2️⃣ Domain Layer
- Entities
- Repositories (Abstract)
- UseCases

### 3️⃣ Data Layer
- Models
- Repository Implementations
- Data Sources (Firebase / Dio)

All layers must be independent and follow SOLID principles.

---

# 📂 Folder Structure Rules

## app/
- app_name.dart → Root MaterialApp.router
- injection_container.dart → GetIt setup

## core/
Contains reusable global modules:
- config → Environment & API keys
- constants → String & asset constants
- enums → LoadStatus, etc.
- router → GoRouter config
- services →
  - dio → Dio client & interceptors
  - logger → Logging service
  - network → Internet checker
  - notifications → Firebase messaging
  - local_storage → Secure storage
  - image_picker → Image selection
- theme → Royal Blue & Royal Green theme
- widgets → Reusable UI components

## features/auth/
Must follow:

auth/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
├── auth_di.dart
└── README.md

Each feature must be self-contained.

---

# 🎨 UI & Theming Rules

## Primary Colors
- Royal Blue
- Royal Green

Use `ColorScheme.fromSeed()`.

Must support:
- Light theme
- Dark theme

UI must:
- Be responsive on all devices
- Use device_preview
- Have shadows and elevation depth
- Follow accessibility contrast ratio

---

# 🔐 Authentication Rules

- Use Firebase Authentication
- Integrate Facebook login
- On successful login:
  - Fetch profile data
  - Store securely
  - Navigate to Home
  - Show success SnackBar
- On failure:
  - Show error SnackBar
  - Log error
  - Prevent navigation

Logout must:
- Clear secure storage
- Sign out from Firebase
- Navigate to login screen

---

# 🔔 Notifications

- Use Firebase Messaging
- Handle foreground & background
- Show SnackBar on notification received
- Log notification payload

---

# 🌐 Networking

- Use Dio
- Add:
  - Logging Interceptor
  - Error Interceptor
  - Token Interceptor
- Handle:
  - Timeout
  - No Internet
  - Unauthorized
  - Server Errors

---

# 🧠 State Management

- Use Provider
- Separate UI state & business logic
- Use ChangeNotifier for auth state
- Use ListenableBuilder where required

---

# 🧩 Dependency Injection

- Use GetIt
- Each feature has its own DI file
- Register:
  - Repositories
  - UseCases
  - Providers
  - Services

No global singletons outside DI container.

---

# ⚠️ Error Handling Rules

Every step must:
- Catch exceptions
- Log using custom logger
- Show user-friendly message
- Never crash silently

---

# 🧪 Code Quality Rules

- Follow Effective Dart
- No long functions (>20 lines)
- Null safety required
- Avoid force unwrap (!)
- Proper async/await handling
- Document public APIs
- Follow naming conventions

---

# 🧾 Logging

Use structured logging.
Do not use print().
Log:
- Auth success/failure
- Network requests
- Notification events
- Unexpected errors

---

# 📱 Responsiveness

- Use LayoutBuilder
- Use MediaQuery
- Avoid fixed sizes
- Support mobile & tablet
- device_preview enabled in debug mode

---

# 🧰 Required Packages

- firebase_core
- firebase_auth
- flutter_facebook_auth
- firebase_messaging
- dio
- get_it
- provider
- go_router
- flutter_secure_storage
- image_picker
- device_preview

---

# 🧱 Code Generation

If using json_serializable:
- Add build_runner
- Run:
  dart run build_runner build --delete-conflicting-outputs

---

# 📚 Documentation Rule

Each feature must contain:
- README.md
- DI documentation
- Explanation of data flow

---

# 🚀 Development Principles

- Composition over inheritance
- Small reusable widgets
- Business logic separated from UI
- Feature-first structure
- Clean & maintainable code

---

# 🧭 Navigation Rule

- Use GoRouter
- Protect Home route
- Redirect to login if not authenticated

---

# 🎯 Final Goal

A production-ready Flutter app with:

- Clean architecture
- Modular feature structure
- Firebase integration
- Facebook authentication
- Secure storage
- Push notifications
- Responsive premium UI
- Royal Blue & Royal Green theme
- Proper logging
- Full error handling
