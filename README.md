
# JU Express - Bus Ticket Booking Application

JU Express is a mobile application for booking bus tickets. The app offers users the ability to purchase tickets, download tickets, request ticket cancellations, and manage their account through secure login. It is built using Flutter with Clean Code architecture and BLoC for state management.

---

## Table of Contents

1. [Features](#features)
2. [Architecture](#architecture)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [Running the App](#running-the-app)
6. [Project Structure](#project-structure)
7. [License](#license)

---

## Features

- **Purchase Tickets:** Users can browse available bus routes and purchase tickets.
- **Download Tickets:** After booking, users can download their tickets for offline access.
- **Ticket Cancellation:** Users can request to cancel their tickets and get a refund.
- **User Login:** Secure user login and account management system.

---

## Architecture

JU Express follows the Clean Code Architecture principles. The app is organized into distinct layers to separate concerns:

- **Presentation Layer:** Handles the user interface and state management.
- **Domain Layer:** Contains business logic, entities, and use cases.
- **Data Layer:** Manages data sources, including API services and local storage.

BLoC (Business Logic Component) is used for managing state across the app, ensuring a clean separation of UI and business logic.

---

## Requirements

- Flutter SDK: 3.22.1
- Dart: >= 3.4.1
- IDE: Android Studio 
- Project Management: Azure Devops

---

## Installation

### 1. Clone the repository

\`\`\`bash
git clone https://github.com/bijoy-deb/ju_express.git
\`\`\`

### 2. Navigate to the project directory

\`\`\`bash
cd JUExpress
\`\`\`

### 3. Install dependencies

\`\`\`bash
flutter pub get
\`\`\`

### 4. Configure environment variables

Create two environments prod and beta. 

---

## Running the App

To run the app on an emulator or connected device:

\`\`\`bash
flutter run
\`\`\`

Specify platform:

- Android: \`flutter run -d android\`
- iOS: \`flutter run -d ios\`

---

## Project Structure


lib/
  ├── main.dart                     # Application entry point
  ├── core/                         # Core utilities, constants, and themes
  ├── features/                     # Organized by app feature modules
  │   ├── auth/                     # User authentication (login, signup)
  │   ├── ticket/                   # Ticket purchase, download, cancellation
  │   └── profile/                  # User profile and account management
  ├── data/                         # Data sources and repositories
  │   ├── models/                   # Data models (e.g., Ticket, User)
  │   ├── repositories/             # Repository interfaces and implementations
  └── blocs/                        # BLoC components for state management
      ├── auth_bloc/                # BLoC for authentication
      ├── ticket_bloc/              # BLoC for ticket management
      └── profile_bloc/             # BLoC for user profile management


\`\`\`
lib/
  ├── main.dart                     # Application entry point
  ├── config/                       # Environment configuration
  ├── core/                         # API client, error, network setup
  ├── di/                           # Dependency Injection setup
  ├── domain/                       # Use case setup
  ├── env/                          # Types of environment setup
  ├── l10n/                         # Multiple language files (Localization)
  ├── route/                        # Page route setup
  ├── source/                       # Model, data, UI layers
      ├── data/                     # Data sources and repositories
      │   ├── models/               # Data models 
      │   ├── repositories/         # Repository interfaces and implementations
      ├── presentation/             # UI, state, and widget
      │   ├── bloc/                 # State management using BLoC
      │   └── ui/                   # UI (Screens, Widgets)
      ├── utils/                    # Utilities, constants, helpers
\`\`\`

\`\`\`
lib/
  ├── main.dart                     # Application entry point
  ├─  config/                       # Environment configuration
  ├── core/                         # API client, error, network setup
  ├─  di/                           # Dependency Injection setup
  ├─  domain/                       # Use case setup, GraphQL queries, mutations
  ├─  env/                          # Types of environment setup
  ├─  l10n/                         # Multiple language files (Localization)
  ├─  route/                        # Page route setup
  ├─  source/                       # Model, data, UI layers
      ├── data/                     # Data sources and repositories
      │  ├── models/                # Data models 
      │  ├── repositories/          # Repository interfaces and implementations, GraphQL client interaction
      ├── presentation/             # UI, state, and widget
      │  └── bloc/                  # State management using BLoC
      │  └── UI/                    # UI (Screens, Widgets)
      ├── utils/                    # Utilities, constants, helpers
\`\`\`

---



## License

This project is licensed under the [MIT License](LICENSE).

---

## Contact

For any inquiries, feel free to contact [Bijoy Chandra Debnath] at [bijoycsepu@gmail.com].
