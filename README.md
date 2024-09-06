# EAMS - Employee Attendance Management System

## Super Admin Login
- **Email:** eamssih2024@gmail.com

## Admin Login
- **Email:** eamslocal@gmail.com

## Employee Login
- **Email:** eamsuser@gmail.com

---

## Prerequisites

1. **Download Requirements:**
   - Flutter SDK: 3.0.0 [Download here](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.0-stable.zip)
   - Dart: 2.17.0 [Download here](https://storage.googleapis.com/dart-archive/channels/stable/release/2.7.1/sdk/dartsdk-windows-x64-release.zip)
   - JDK: 11.0.14 [Download here](https://download.oracle.com/otn/java/jdk/11.0.14+8/7e5bbbfffe8b45e59d52a96aacab2f04/jdk-11.0.14_windows-x64_bin.exe) *(Requires Oracle Account)*

   Additionally, you can install the Dart plugin for VSCode.

2. **Unzip the Flutter and Dart SDKs** in a directory of your choice (generally located at `C:/tools`).

3. **Add the Flutter and Dart SDKs to your PATH environment variable**:
   - Example: `C:\tools\flutter\bin` and `C:\tools\dart\bin`.

4. **Install JDK 11.0.14** and create a new system variable `JAVA_HOME` and add JDK path:
   - Example: `JAVA_HOME: C:\Program Files\Java\jdk-11.0.14`
   - Add `JAVA_HOME` to the PATH environment variable:
   - Example: `%JAVA_HOME%\bin`

---

## Installation

1. **Download or clone this repo** by using the following commands:

    ```bash
    git clone https://github.com/NinjaChunksBackup/eams.git
    cd eams
    ```

2. **Get the required dependencies** by running the following command:

    ```bash
    flutter pub get
    ```

3. **Connect a device using ADB** or use Android Emulator, then run the app:

    ```bash
    flutter run
    ```

---

## Common Errors

- **Error 1:** If you see red lines or a lot of problems in the debug/problems tab, just run:
  
    ```bash
    flutter pub get
    ```

- **Error 2:** If you see init SDK (number) error during debugging, uninstall and reinstall the app.

- **Error 3:** If you encounter weird plugin errors, reset the plugin cache by running:

    ```bash
    flutter clean
    flutter pub get
    ```
- **Error 4:** Still you get build failed errors:

    ```bash
    flutter clean 
    flutter pub cache clean
    flutter pub get

    ```

If this doesn’t help, feel free to contact us with the issue 😃.

---

## License

This project is licensed under the MIT License.
