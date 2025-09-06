# Elecktro E-Commerce App

A modern e-commerce application built with Flutter and GetX for state management. This app provides a seamless shopping experience with features like product browsing, cart management, and user profiles.

## 🚀 Features

- **Home Screen**: Browse featured products and categories
- **Product Catalog**: View products with images, prices, and descriptions
- **Shopping Cart**: Add/remove items and manage quantities
- **User Profile**: View order history and manage account settings
- **Responsive Design**: Works on both mobile and tablet devices
- **Dark/Light Theme**: Built-in theme support

## 🛠 Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Navigation**: GetX Navigation
- **UI Components**: Custom widgets with Material Design 3
- **Localization**: Multi-language support
- **Dependency Injection**: GetX for dependency management

## 📱 Screens

### Home Screen
- Featured products carousel
- Category navigation
- Search functionality
- Quick add to cart

### Cart Screen
- Product list with quantities
- Item removal
- Total calculation
- Checkout process

### Profile Screen
- User information
- Order history
- Settings and preferences
- Logout functionality

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Atik-hridoy/elecktro-ecommerce.git
   cd elecktro-ecommerce
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 🏗 Project Structure

```
lib/
├── app/
│   ├── core/
│   │   └── navigation/     # Navigation services
│   │
│   └── modules/
│       ├── cart/           # Cart feature
│       ├── home/           # Home feature
│       └── profile/        # Profile feature
│
├── assets/
│   ├── images/            # App images
│   └── icons/             # App icons
│
└── main.dart              # App entry point
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter Team
- GetX Community
- All contributors
