# PB Authenticator

A modern, open-source two-factor authentication (2FA) app built with Flutter. PB Authenticator supports TOTP, QR code scanning, secure local storage, and a beautiful, customizable UI. Now with full Persian (Farsi) language support, RTL layout, and the Vazirmatn font for a seamless experience for Persian users.

---

## 🚀 Features

- **Time-based One-Time Passwords (TOTP)**: Securely generate 2FA codes for your accounts.
- **QR Code Scanning**: Quickly add accounts by scanning QR codes.
- **Manual Entry**: Add accounts manually if QR is not available.
- **Material Design**: Clean, modern, and responsive UI.
- **Icon Support**: Large collection of SVG icons for popular services.
- **Account Management**: Edit, remove, and organize your 2FA accounts.
- **Export/Import**: Transfer your accounts between devices securely.
- **Security**: PIN code and biometric authentication support.
- **Screen Capture Prevention**: Optional protection against screenshots.
- **Theme Support**: Light, dark, and system themes.
- **Localization**: 
  - English and Persian (Farsi) language support
  - Language switcher in settings
  - RTL layout and Vazirmatn font for Persian
- **Cross-Platform**: Runs on Android, iOS, and desktop (Flutter-supported platforms).

---

## 🌐 Localization & RTL

- **Persian (Farsi) Support**: All UI elements are fully translated.
- **RTL Layout**: The app automatically switches to right-to-left layout and uses the Vazirmatn font when Persian is selected.
- **Language Switcher**: Instantly change the app language from the settings menu.

---

## 🖼️ Icon & Asset Support

- Hundreds of SVG icons for popular services (see `graphics/aegis-icons-outline/SVG/`).
- Custom app icon included.

---

## 🔒 Security

- All data is stored **locally** on your device.
- PIN code and biometric authentication options.
- Optional prevention of screen capture for sensitive screens.

---

## 📦 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android/iOS device or emulator, or desktop (for supported platforms)

### Installation
```sh
flutter pub get
flutter run
```

### Directory Structure
- `lib/` — Main app code
- `lib/pages/` — UI pages (settings, add, import/export, etc.)
- `lib/l10n/` — Localization files (ARB, generated Dart)
- `graphics/` — App icons and SVG icon set
- `assets/fonts/` — Custom fonts (Vazirmatn)
- `test/`, `state/test/`, `totp/test/` — Unit and widget tests

---

## 🧪 Testing
Run all tests:
```sh
flutter test
```

---

## 🤝 Contributing
Contributions, issues, and feature requests are welcome!
- Fork the repo
- Create your feature branch (`git checkout -b feature/your-feature`)
- Commit your changes (`git commit -am 'Add new feature'`)
- Push to the branch (`git push origin feature/your-feature`)
- Open a pull request

---

## 📄 License
This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits
- [Vazirmatn Font](https://github.com/rastikerdar/vazirmatn) by [rastikerdar](https://github.com/rastikerdar)
- [Aegis Simple Icons Outlined](https://github.com/michaelschattgen/aegis-simple-icons-outlined) by [michaelschattgen](https://github.com/michaelschattgen)
- Flutter and the open-source community

---

## 📷 Screenshots

| Material Theme |
|----|
|<img src="./readme-assets/screenshot (1).jpg" alt="Import Accounts" height="450">|
|<img src="./readme-assets/screenshot (2).jpg" alt="Add Account with Manual Input" height="450">|
|<img src="./readme-assets/screenshot (3).jpg" alt="Main Page Code List" height="450">|
|<img src="./readme-assets/screenshot (4).jpg" alt="PB Authenticator Settins" height="450">|
|<img src="./readme-assets/screenshot (5).jpg" alt="How It Works" height="450">|

---

> **Disclaimer:** PB Authenticator is not ready for production. There may be bugs and upgrade issues. Use at your own risk.
