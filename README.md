# Meter Reading Application (MRA) – Flutter & PHP

## 📱 Overview

This is a **Meter Reading Application** built using **Flutter** for the frontend and **PHP** as the backend. It is designed for utility field agents to capture meter readings, submit them to the backend, and optionally print spot bills. The app supports real-time OCR, a red theme UI, and integration with SAP OData APIs.

---

## ⚙️ Technologies Used

- **Frontend:** Flutter (Dart)
- **Backend:** PHP (REST APIs)
- **Authentication:** Basic Auth + Bearer Token + x-csrf-token (SAP)
- **OCR:** Custom OCR (non-Google ML Kit)
- **Printing:** Integrated spot billing with printing support

---

## 🗂️ Project Structure

```
MRA_Prototype/
│
├── lib/                 # Flutter code
│   ├── screens/         # Login, Home, Meter List, Details, etc.
│   ├── widgets/         # Reusable UI components
│   └── main.dart        # App entry point
│
├── backend/             # PHP API code (admin/vendor portals)
│
├── assets/              # Images, PDFs, Fonts
│
├── pubspec.yaml         # Flutter dependencies
└── README.md
```

---

## 🚀 Setup Instructions

Before you begine to start this application,
please visit https://docs.flutter.dev/get-started/install/windows for instructions on how to install flutter and android studio and run an emilator.
If you want, you can skip the emulator part and use your android/ios device to run the application.
Once your device is set up in debug mode, you can then follow the steps below.

lib/services/api_service.dart

lib/constants/api_constants.dart

🛠️ Development Notes:
Uses Riverpod for state management

Ensure internet connectivity for API calls

Test on real devices for camera + printing features

Printing uses native integration (requires physical printer support)

### 🔧 Prerequisites

- Flutter SDK (3.x or above)
- PHP 7.x or above
- Android Studio / VSCode
- Emulator or physical Android device

### 🔌 SAP API Credentials

Ensure you have access to the following SAP APIs:

1. **Meter List API**
   ` 'https://mra3.onebrain.me/api/get_assigned_meters.php';`

2. **Submit Meter Reading**
   `'https://mra3.onebrain.me/api/submit_reading.php'; `

3. **Spot Billing**
   `http GET http://is1:50000/sap/opu/odata/sap/ZMRA_BILLDETAILS_SRV/ZstOdataSpotSet(Invoicedate=datetime'2025-02-01T00:00:00',Accountnumber='000000001428') `

4. **Login API**  
   `'https://mra3.onebrain.me/api/login.php'; `

### 🧪 Step-by-Step: Flutter Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/BrontobyteMRA/MRA_Prototype.git
   cd MRA_Prototype
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

4. **APK build (optional)**
   ```bash
   flutter build apk --release
   ```

### 🌐 Backend (PHP)

1. Place the contents of `/backend` on a PHP server (e.g., XAMPP, Apache)
2. Ensure the server can access your SAP system for API relay
3. Configure any `.env` or config files (API base URLs, tokens)

---

## 🧠 Key Features

- Login with token-based auth
- View meter list filtered by date & route (MRU)
- Capture readings with live OCR
- Submit readings securely via SAP API
- Spot Billing with invoice fetch + printing
- Navigation drawer + intuitive red UI

---

## 🧾 Admin & Vendor Portals

- Developed in PHP for web-based control
- Functionality:
  - User role management
  - Vendor-specific data access
  - Reading logs & reporting

---

## 🧑‍💻 Developer Notes

- This app is designed to be extended. Add modules for inventory, account mapping, analytics, etc.
- For any integration with new SAP services, replicate structure in existing `services/` folder.

---

## 🤝 Contributions

Maintained by **Mubashir Hussain** and the Brontobyte Technologies.

---
