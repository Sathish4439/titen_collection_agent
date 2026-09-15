# Apple App Store Release & Submission Guidelines
### App: **NestPilot - PG Collector** (TitanStay Collection Agent)
**Bundle Identifier (`PRODUCT_BUNDLE_IDENTIFIER`):** `com.titanstay.collector`  
**Platform:** iOS 14.0+ (Flutter Engine 3.44+)

---

## Table of Contents
1. [Backend Root Cause: Why `curl` returned 405 Not Allowed](#1-backend-root-cause-why-curl-returned-405-not-allowed)
2. [Pre-Flight iOS Technical Fixes Applied](#2-pre-flight-ios-technical-fixes-applied)
3. [Apple Developer Program Prerequisites](#3-apple-developer-program-prerequisites)
4. [Building and Archiving the iOS App (.ipa)](#4-building-and-archiving-the-ios-app-ipa)
5. [Critical App Store Review Guidelines & Rejection Traps](#5-critical-app-store-review-guidelines--rejection-traps)
6. [App Store Listing Copy & Metadata (Ready-to-Paste)](#6-app-store-listing-copy--metadata-ready-to-paste)
7. [App Store Graphic Asset & Screenshot Specifications](#7-app-store-graphic-asset--screenshot-specifications)
8. [App Privacy Nutrition Labels (Mandatory)](#8-app-privacy-nutrition-labels-mandatory)
9. [TestFlight & App Store Phased Rollout](#9-testflight--app-store-phased-rollout)

---

## 1. Backend Root Cause: Why `curl` returned 405 Not Allowed

When you ran:
```bash
curl -X POST 'https://pg-admin.titanstay.com/api/v1/collector/auth/verify-otp' ...
```
and received:
```html
<center><h1>405 Not Allowed</h1></center>
<hr><center>nginx/1.27.5</center>
```

### The Explanation:
- `pg-admin.titanstay.com` is an **Nginx server hosting the static frontend Web Dashboard** (built with React/Vite).
- In Nginx, any HTTP `POST`, `PUT`, or `DELETE` sent to a directory configured for static file serving returns **`405 Not Allowed`** because static file servers do not process incoming POST payloads.
- **The Solution:** The server's Nginx configuration (`/etc/nginx/sites-available/pg-admin.titanstay.com`) needs a reverse-proxy block routing `/api/` traffic to the Node.js backend port (e.g., `3000`):
  ```nginx
  location /api/ {
      proxy_pass http://127.0.0.1:3000;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache_bypass $http_upgrade;
  }
  ```
- Alternatively, if your backend runs on a distinct subdomain (e.g. `api.titanstay.com` or `pg-api.titanstay.com`), update `collection_agent/lib/core/network/api_endpoints.dart` to point to that API host.

---

## 2. Pre-Flight iOS Technical Fixes Applied

The following critical iOS configurations have been fixed in the codebase:

| Component | File | Status | Description |
| :--- | :--- | :--- | :--- |
| **Bundle Identifier** | `project.pbxproj` | ✅ Fixed | Changed from `com.example.collectionAgent` to `com.titanstay.collector`. (*Apple Developer portal strictly forbids registering `com.example` App IDs*). |
| **Display Name** | `Info.plist` | ✅ Fixed | Set `<key>CFBundleDisplayName</key>` to `"NestPilot"` (was raw `"Collection Agent"`). |
| **Bundle Name** | `Info.plist` | ✅ Fixed | Set `<key>CFBundleName</key>` to `"NestPilot"`. |
| **Export Compliance** | `Info.plist` | ✅ Configured | Added `<key>ITSAppUsesNonExemptEncryption</key><false/>`. (*Without this, App Store Connect blocks every TestFlight build asking manual encryption questions*). |
| **App Transport Security** | Native | ✅ Ready | Secure HTTPS endpoints used for network calls. |

---

## 3. Apple Developer Program Prerequisites

1. **Apple Developer Account ($99/year)**:
   - An active membership at [developer.apple.com](https://developer.apple.com).
   - If an Organization account, your organization's legal entity and D-U-N-S number are verified.
2. **App ID Registration**:
   - Go to **Certificates, Identifiers & Profiles** ➔ **Identifiers** ➔ **+**.
   - Select **App IDs** ➔ Description: `NestPilot Collector` ➔ Bundle ID: `Explicit` ➔ `com.titanstay.collector`.
3. **Distribution Certificate & Provisioning Profile**:
   - Create an **Apple Distribution Certificate** (or allow Xcode automatic signing).
   - Create an **App Store Distribution Provisioning Profile** linked to `com.titanstay.collector`.
4. **App Record in App Store Connect**:
   - Navigate to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) ➔ **My Apps** ➔ **+ (New App)**.
   - Platform: **iOS**.
   - Name: **NestPilot - PG Collector**.
   - Primary Language: **English (US)** (or English UK/India).
   - Bundle ID: Select `com.titanstay.collector`.
   - SKU: `NESTPILOT-COLLECTOR-01`.
   - User Access: **Full Access**.

---

## 4. Building and Archiving the iOS App (.ipa)

On a macOS machine (or via CI/CD like Codemagic, GitHub Actions macOS runner, or Xcode Cloud):

### Step 4.1: Sync Version with `pubspec.yaml`
Ensure `version: 1.0.0+1` is set in `collection_agent/pubspec.yaml`.
- iOS uses `1.0.0` as `CFBundleShortVersionString` (marketing version).
- iOS uses `1` as `CFBundleVersion` (build number).
- Every TestFlight build upload must have a **higher build number** (`+2`, `+3`, etc.).

### Step 4.2: Build the Release Archive
Run the Flutter build command with symbol splitting:
```bash
flutter build ipa --release --obfuscate --split-debug-info=build/ios/outputs/symbols
```

### Step 4.3: Upload via Xcode or Transporter
- **Option A (Xcode)**:
  1. Open the iOS project: `open ios/Runner.xcworkspace`.
  2. Select target device **Any iOS Device (arm64)**.
  3. Go to **Product ➔ Archive**.
  4. Once archiving finishes, the **Organizer** window appears.
  5. Click **Distribute App ➔ App Store Connect ➔ Upload**.
- **Option B (Transporter / CLI)**:
  Upload the generated `.ipa` file located in `build/ios/archive/Runner.xcarchive` or `build/ios/ipa/` using Apple's **Transporter** app.

---

## 5. Critical App Store Review Guidelines & Rejection Traps

### Traps & Solutions

| Guideline | Common Rejection Reason | Solution for NestPilot |
| :--- | :--- | :--- |
| **Guideline 2.1: App Completeness** | Apple reviewers test on real iPads/iPhones. If login fails or network shows an error, they reject with *"Guideline 2.1 - Performance - App Completeness"*. | In App Store Connect ➔ **App Review Information**, provide active test credentials:<br>• **Phone:** `6374662089`<br>• **Passcode:** `1234`<br>• **Notes:** Include instructions explaining that the app connects to the property PG Admin backend to record rent collections. |
| **Guideline 3.1.1: In-App Purchases (IAP)** | Reviewers might mistakenly think rent payments require Apple's 30% In-App Purchase commission. | Clarify in App Review Notes: *"NestPilot is a B2B property management tool used exclusively by authorized on-ground collection staff to record offline cash and direct UPI rent payments for physical accommodation (PG rooms/beds). It qualifies as a multi-platform service under Guideline 3.1.3(e) and physical goods/services outside digital goods."* |
| **Guideline 5.1.1: Account Deletion** | Apple **strictly mandates** that apps with account login must allow users to initiate account deletion within the app or provide a public deletion request link. | In app settings / profile screen, provide an *"Account Deletion Request"* option or support link (`https://titanstay.com/delete-account`). |
| **Guideline 5.1.2: Data Collection & Privacy** | Collecting tenant names and phone numbers without disclosing them in App Privacy results in immediate rejection. | Fill out App Privacy Nutrition Labels completely (see Section 8). |

---

## 6. App Store Listing Copy & Metadata (Ready-to-Paste)

### App Name (Max 30 characters)
```
NestPilot - PG Collector
```

### Subtitle (Max 30 characters)
```
Property Rent & Bed Management
```

### Primary Category
`Business` (Secondary: `Productivity`)

### Keywords (Max 100 characters, comma-separated, no spaces)
```
pg,hostel,rent collection,property management,collector,paying guest,nestpilot,titanstay,rent book
```

### Promotional Text (Max 170 characters)
```
Easily record tenant rent payments, monitor room and bed occupancy, and reconcile daily cash collections with NestPilot.
```

### Description (Up to 4,000 characters)
```text
NestPilot is a specialized property management and rent collection tool built for Paying Guest (PG) managers, hostel operators, and field collection agents.

Empower your property collection team with immediate visibility into room occupancy, outstanding rent dues, and seamless collection records.

KEY FEATURES:

🏢 Room & Bed Allocation
• Instant overview of property blocks, floors, and rooms.
• Visual indicator of occupied vs. vacant beds.
• Quick tenant directory with emergency contacts and room details.

💰 Swift Rent Collection
• Record tenant payments in seconds with flexible Full or Partial options.
• Supports multiple collection channels: Cash, UPI, Card, Net Banking, and Bank Transfer.
• Instant calculation of remaining tenant balance.

📊 Daily Collection History & Auditing
• Chronological transaction logs grouped by date (Today, Yesterday, Custom).
• Filter transactions by payment mode for transparent reconciliation.
• Real-time synchronization with TitanStay PG Admin.

🔒 Business-Grade Security
• Role-based agent access protected with 4-digit PIN authentication.
• Secure data transmission over encrypted HTTPS channels.
• Zero personal data sharing with third parties.

Note: NestPilot is an internal business application for authorized property collection agents and managers. Contact your property administrator for login credentials.
```

### URLs
- **Support URL:** `https://titanstay.com/support`
- **Marketing URL:** `https://titanstay.com`
- **Privacy Policy URL:** `https://titanstay.com/privacy-policy`

---

## 7. App Store Graphic Asset & Screenshot Specifications

Apple requires screenshots for at least the largest display sizes:

| Device Size | Screenshot Resolution | Requirement |
| :--- | :--- | :--- |
| **6.7" Super Retina (iPhone 16 Pro Max / 15 Pro Max)** | **1290 x 2796 pixels** (or 2796 x 1290) | **Mandatory** |
| **6.5" Super Retina (iPhone 11 Pro Max / XS Max)** | **1242 x 2688 pixels** | **Mandatory** |
| **12.9" iPad Pro (6th Gen)** | **2048 x 2732 pixels** | Mandatory if iPad destination is enabled |
| **App Store Icon** | **1024 x 1024 pixels** | PNG, 72 dpi, RGB, no transparency, no rounded corners |

### Recommended Screenshot Flow (4 Screens):
1. **Screen 1:** Agent Secure Login Screen (Branded with NestPilot logo and clean passcode input).
2. **Screen 2:** Room & Bed Occupancy Dashboard (Showing blocks, room numbers, and vacant/occupied badges).
3. **Screen 3:** Payment Collection Sheet (Displaying Amount Due, Full/Partial option, and Cash/UPI channels).
4. **Screen 4:** Collection History & Daily Reconciliation (Displaying transaction cards and channel totals).

---

## 8. App Privacy Nutrition Labels (Mandatory)

In App Store Connect ➔ **App Privacy**:

### Data Used to Track You
- Select **"No, we do not track users"**.

### Data Linked to You (Collected)
1. **Contact Info**:
   - **Name**: App Functionality (identifying collector and tenant).
   - **Phone Number**: App Functionality (authentication & tenant contact).
   - **Email Address**: Optional profile info.
2. **Financial Info**:
   - **Payment Info**: App Functionality (recording rent amounts and payment method).
3. **Diagnostics**:
   - **Crash Data**: App Functionality (performance monitoring).

*All data is linked to the user's account for property management functionality and is transmitted over encrypted connections.*

---

## 9. TestFlight & App Store Phased Rollout

```mermaid
graph LR
    A[Build & Archive .ipa] --> B[Upload to App Store Connect]
    B --> C[Internal TestFlight (Instant)]
    C --> D[External TestFlight (Quick Review)]
    D --> E[Submit for App Store Review]
    E --> F[7-Day Phased Release]
```

1. **Internal TestFlight**:
   - Add your internal development and QA team members. Available immediately without Apple Beta App Review.
2. **External TestFlight**:
   - Up to 10,000 external testers. Requires a quick 24-48 hour TestFlight beta review by Apple.
3. **App Store Review Submission**:
   - Attach test account credentials in Review Notes.
   - Normal review time is 24 to 48 hours.
4. **Phased Release (Recommended)**:
   - Enable **7-day phased release** for automatic updates to catch any edge-case crashes before reaching 100% of field collection agents:
     - Day 1: 1%
     - Day 2: 2%
     - Day 3: 5%
     - Day 4: 10%
     - Day 5: 20%
     - Day 6: 50%
     - Day 7: 100%
