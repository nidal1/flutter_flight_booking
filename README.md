# Flutter Flight Booking App

A modern and clean flight booking application built with Flutter. This project demonstrates a feature-rich mobile app, including user authentication, flight search, seat selection, and ticket generation, all built using modern Flutter practices.

## ✨ Features

- **Onboarding:** A smooth introduction for first-time users.
- **User Authentication:** Secure login and user management using Firebase.
- **Dynamic Home Screen:** Displays a personalized greeting and a list of recent flights.
- **Flight Search:** Search for flights with filters for departure/arrival locations, dates, and number of passengers.
- **Interactive Seat Selection:** A visual seat map to choose available seats.
- **Passenger Details:** A form to enter information for all passengers.
- **Ticket Generation:** Generates and displays a detailed flight ticket with a QR code.
- **State Management:** Clean and scalable state management using **Riverpod**.
- **Navigation:** Type-safe routing handled by **GoRouter**.
- **Localization:** Supports multiple languages using the `intl` package.

## 🛠️ Tech Stack & Packages

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Flutter Riverpod
- **Navigation:** GoRouter
- **Backend & Auth:** Firebase
- **Localization:** intl
- **Secure Storage:** flutter_secure_storage

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK (version 3.x or higher)
- A code editor like VS Code or Android Studio
- A configured emulator or a physical device to run the app.

### Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/flutter_flight_booking.git
    cd flutter_flight_booking
    ```

2.  **Install dependencies:**

    ```sh
    flutter pub get
    ```

3.  **Set up Firebase:**
    This project uses Firebase for authentication. You need to set up your own Firebase project.

    - Create a new project on the Firebase Console.
    - **For Android:** Add an Android app to your Firebase project. Follow the setup instructions and download the `google-services.json` file. Place it in the `android/app/` directory.
    - **For iOS:** Add an iOS app to your Firebase project. Follow the setup instructions and download the `GoogleService-Info.plist` file. Open `ios/Runner.xcworkspace` in Xcode and add the file to the `Runner` directory.

4.  **Run the app:**

    ```sh
    flutter run
    ```

5.  **get the app:**

    ```sh
    cd ./android-releases/app-release.apk

    ```
