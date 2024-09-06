# EAMS - Employee Attendance Management System

## Login Credentials

### Super Admin
- **Email:** eamssih2024@gmail.com

### Admin
- **Email:** eamslocal@gmail.com

### Employee
- **Email:** eamsuser@gmail.com

---

## Prerequisites

### Windows

1. **Download the Required SDKs and Tools:**
   - **Flutter SDK:** [Download Flutter SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.0-stable.zip)
   - **Dart SDK (Optional):** [Download Dart SDK](https://storage.googleapis.com/dart-archive/channels/stable/release/2.17.0/sdk/dartsdk-windows-x64-release.zip)
   - **JDK 11.0.14:** [Download JDK](https://download.oracle.com/otn/java/jdk/11.0.14+8/7e5bbbfffe8b45e59d52a96aacab2f04/jdk-11.0.14_windows-x64_bin.exe) *(Oracle Account Required)*

2. **Install SDKs:**
   - **Flutter and Dart:**
     - Unzip the Flutter SDK to a directory of your choice, e.g., `C:/tools/flutter`.
     - Dart is bundled with Flutter; no need to install separately.
     - Add Flutter to the PATH environment variable:
       - Open **System Properties** > **Environment Variables**.
       - Under **System Variables**, find and edit `Path`.
       - Add a new entry: `C:\tools\flutter\bin`.

3. **Set Up JDK:**
   - **JDK Installation:**
     - Install JDK 11.0.14 and set up `JAVA_HOME`:
       - Open **System Properties** > **Environment Variables**.
       - Click **New** under **System Variables**:
         - Variable name: `JAVA_HOME`
         - Variable value: `C:\Program Files\Java\jdk-11.0.14`
       - Add `%JAVA_HOME%\bin` to the `Path` variable.

4. **Verify Installation:**
   - Open Command Prompt and run the following to verify installations:
     ```bash
     flutter --version
     java -version
     ```
   - Ensure both commands return the correct versions.

### macOS

1. **Download the Required SDKs and Tools:**
   - **Flutter SDK:** [Download Flutter SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.0.0-stable.zip)
   - **Dart SDK:** [Download Dart SDK](https://storage.googleapis.com/dart-archive/channels/stable/release/2.17.0/sdk/dartsdk-macos-x64-release.zip)
   - **JDK 11.0.14:** [Download JDK](https://www.oracle.com/in/java/technologies/javase/jdk11-archive-downloads.html#license-lightbox)

2. **Install SDKs:**
   - **Flutter:**
     - Unzip the Flutter SDK to `~/development`.
     - Add Flutter to the PATH by editing your shell profile (`~/.zshrc` or `~/.bash_profile`):
       ```bash
       export PATH="$PATH:$HOME/development/flutter/bin"
       ```
     - Reload your shell configuration:
       ```bash
       source ~/.zshrc  # or ~/.bash_profile
       ```

3. **Set Up JDK:**
   - **JDK Installation:**
     - Install JDK 11.0.14 and set `JAVA_HOME`:
       - Add to your shell profile:
         ```bash
         export JAVA_HOME=$(/usr/libexec/java_home -v 11)
         ```
       - Reload the shell configuration:
         ```bash
         source ~/.zshrc  # or ~/.bash_profile
         ```

4. **Verify Installation:**
   - Open Terminal and run the following to verify installations:
     ```bash
     flutter --version
     java -version
     ```
   - Ensure both commands return the correct versions.

---

## Installation

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/NinjaChunksBackup/eams.git
    cd eams
    ```

2. **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3. **Run the Application:**
   - Ensure a connected device via ADB (Android) or an Android Emulator is running.
    ```bash
    flutter run
    ```

---

## Common Errors and Solutions

### Error 1: Unresolved Dependencies
- **Solution:** Update dependencies:
    ```bash
    flutter pub get
    ```

### Error 2: Initialization SDK Error
- **Solution:** Uninstall the app from your device/emulator and reinstall using:
    ```bash
    flutter run
    ```

### Error 3: Plugin Errors
- **Solution:** Reset the plugin cache:
    ```bash
    flutter clean
    flutter pub get
    ```

### Error 4: Build Failed Errors
- **Solution:** Clean build and cache:
    ```bash
    flutter clean
    flutter pub cache clean
    flutter pub get
    ```

If the issues persist, please reach out for assistance. 😃

---

## License

This project is licensed under the MIT License.
