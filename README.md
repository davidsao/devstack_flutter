# DevStack Tools 🛠️

A cross-platform "Swiss Army knife" for developers, built entirely with Flutter. Inspired by the popular [DevToys](https://github.com/DevToys-app/DevToys) app, DevStack provides a suite of offline, lightweight, and essential tools to help developers with daily tasks—ranging from JSON formatting and JWT decoding to Regex testing and Code-to-Image generation.

## 🚀 Download & Web Access

DevStack is designed to be accessible wherever you work. Access it instantly on the web, or download the native desktop and mobile apps:

* **Web:** [Run DevStack in your browser](https://david-ng.dev/devstack)
* **macOS:** [Download on the Mac App Store](https://apps.apple.com/app/devstack-tools/id6773667344)
* **Windows:** [Download on the Microsoft Store](https://apps.microsoft.com/store/detail/9P579GMLT35Q?cid=DevShareMCLPCS)
* **iOS:** [Download on the App Store](https://apps.apple.com/app/devstack-tools/id6773667344)
* **Android:** *Coming Soon!*

---

## ✨ Features

DevStack is packed with tools designed to handle everyday developer friction without relying on potentially insecure online web apps. Your data stays on your device—all tools work **entirely offline**.

### 🔄 Converters
* **JSON <> YAML:** Instantly convert between JSON and YAML formats.
* **Number Base:** Convert numbers across Binary, Octal, Decimal, and Hexadecimal.
* **Date & Time:** Quickly parse and convert UNIX timestamps and ISO 8601 dates.

### 🔠 Encoders / Decoders
* **HTML & URL:** Safely encode or decode strings for web transfer.
* **Base64 Text & Image:** Encode and decode text or images to Base64 strings.
* **JWT Decoder:** Inspect the header, payload, and signature of JSON Web Tokens.

### 📝 Formatters & Minifiers
* **JSON & XML:** Pretty-print and format nested data structures.
* **SQL Formatter:** Beautify messy SQL queries.
* **JavaScript Minifier:** Compress JS code instantly (powered by Terser).

### 🎲 Generators
* **Hash:** Generate MD5, SHA1, SHA256, and SHA512 hashes from text.
* **UUID:** Generate completely random Version 1 and Version 4 UUIDs.
* **Lorem Ipsum:** Generate placeholder text for UI mockups.
* **QR Code:** Create scannable QR codes from any text or URL.

### 🛠️ Other Utilities
* **Regex Tester:** Test and evaluate Regular Expressions in real-time.
* **Color Picker:** Extract and convert colors between HEX, RGB, HSL, and HSV.
* **Markdown Preview:** Write and render GitHub-flavored Markdown.
* **Text Inspector:** Analyze string lengths, word counts, and byte sizes.
* **Code to Image:** Export beautiful, syntax-highlighted snippets of your code as shareable images.

---

## 💻 UI / UX Highlights

* **True Cross-Platform:** A single Flutter codebase seamlessly powering Desktop, Mobile, and Web experiences.
* **Advanced Window Management:** Features a responsive multi-pane/split-screen layout on desktop and tablet, allowing you to run tools side-by-side.
* **Smart Navigation:** Pin your favorite tools to the top of the menu, use the unified search bar to find what you need, and enjoy a browser-like tab history.
* **Theme Aware:** First-class support for your system's Light and Dark mode preferences.
* **Dynamic JS Execution:** Uses conditional imports to seamlessly run heavy JavaScript libraries (like SQL formatters and Terser) via `flutter_js` on native platforms, and direct browser execution on the web.

---

## 🛠️ Getting Started (For Contributors)

To build and run this project locally, ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.

1. Clone the repository:
   ```bash
   git clone [https://github.com/your-username/devstack.git](https://github.com/your-username/devstack.git)
2. Navigate to the project directory:
   ```bash
   cd devstack
3. Install dependencies:
   ```bash
   flutter pub get
4. Run the app:
   ```bash
   flutter run

---
## Privacy Policy
Please refer to [PRIVACY POLICY](https://github.com/davidsao/devstack_flutter/blob/main/privacy_policy.md) readme file