# Auth Feature

## Overview
Handles authentication via email/password and Facebook using Firebase.

## Layers
- Presentation: UI screens and `AuthProvider` state management.
- Domain: Entities, repository contracts, and use cases.
- Data: Firebase/Facebook data sources and repository implementation.

## Data Flow
UI -> Provider -> UseCase -> Repository -> DataSource -> Firebase/Facebook.

## Dependency Injection
Registered in [lib/app/injection_container.dart](../../app/injection_container.dart).
