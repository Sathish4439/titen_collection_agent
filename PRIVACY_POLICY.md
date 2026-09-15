# Privacy Policy
### Application: **NestPilot - PG Collector**
**Operating Entity:** TitanStay / NestPilot (Dhigrowth)  
**Effective Date:** September 15, 2026  
**Last Updated:** September 15, 2026  
**Public Hosted URL:** `https://pg-admin.titanstay.com/privacy-policy` *(or `http://localhost:3000/privacy-policy`)*

---

## 1. Overview & Scope

This Privacy Policy describes how **TitanStay** and **NestPilot** ("we", "our", or "us") collect, process, store, and protect data through the **NestPilot - PG Collector** mobile application (for Android and iOS), the TitanStay PG Admin portal, and associated backend API services.

NestPilot is an internal business tool designed exclusively for Paying Guest (PG) and hostel accommodation operators, property managers, and authorized field collection agents to manage room occupancy and record rent collections. 

> [!NOTE]
> We do not sell, rent, monetize, or trade any personal data to third-party advertising companies, credit brokers, or marketing networks.

---

## 2. Information We Collect (Mapped to Backend Systems)

Our systems collect and process only the information strictly necessary for property operations, tenant safety, and rent accounting:

### A. Field Collection Agent Information
- **Account Data:** Agent Name, Phone Number, official Email Address.
- **Authentication Credentials:** 4-digit PIN Passcode and secure JSON Web Tokens (JWT) for authenticated sessions.
- **Assigned Scope:** Branch permissions (`assigned_admins`), assigned properties, blocks (`assigned_blocks`), and rooms (`assigned_rooms`).
- **Audit Logs:** Login timestamps, IP addresses, and transactional actions (`activityLogger.js`) to ensure accounting accountability.

### B. Tenant & Resident Information (Managed by PG Operators)
- **Personal Demographics:** Full Name, System Customer ID (e.g. `PG00123`), Contact Phone Number, Email Address, Gender, Date of Birth, and Blood Group.
- **Accommodation Records:** Assigned Property, Block Name, Room Number, Bed ID, Registration Status, and Joining Date.
- **Emergency Contacts:** Primary and Secondary Emergency Contact Names, Phone Numbers, and Relationship designations (for resident safety and welfare).
- **Identity Verification Proofs:** Digital copies of government identification documents (e.g., Aadhaar, Passport, Voter ID, Driving License) and resident profile photos, uploaded to fulfill statutory local PG register requirements.

### C. Financial & Payment Collection Records
- **Payment Line Items:** Rent amount collected, remaining balance due, payment date, and transaction status (`paid`, `partial`, `pending`).
- **Payment Method:** Channel of collection (`Cash`, `UPI`, `Card`, `Net Banking`, `Bank Transfer`, `Cheque`).
- **Transaction Identifiers:** Bank transaction reference numbers, UPI UTR numbers, or Cheque serial numbers.
- **Agent Attribution:** Collector ID and Agent Name recorded on each receipt (`collected_by_collector_id`).
- **Exclusion:** **We do NOT store or capture raw credit/debit card numbers, CVVs, or bank net banking passwords.** Digital payments are handled via external UPI transfers or RBI-authorized payment processors.

---

## 3. Purpose & Legal Basis of Processing

| Data Category | Purpose | Legal Basis |
| :--- | :--- | :--- |
| **Agent Authentication & Scope** | Verifying agent identity and restricting room/tenant visibility to assigned blocks. | Legitimate Business Operation |
| **Rent Collection & Receipts** | Recording cash/online rent collections, issuing digital receipts, and end-of-day cash handover reconciliation. | Contractual Performance & Accounting |
| **Tenant ID Proofs** | Complying with municipal and state guest house & PG tenant verification regulations. | Legal & Regulatory Compliance |
| **Emergency Contacts** | Emergency medical assistance or urgent security outreach. | Vital Interests of Residents |

---

## 4. Multi-Tenant Architecture & Data Security

1. **Multi-Tenant Database Isolation**:
   - Each property organization's data is isolated in separate tenant database schemas (`pg_master_tenants` / tenant-specific PostgreSQL databases). Cross-tenant queries are structurally prohibited.
2. **Encryption in Transit**:
   - 100% of network requests between mobile clients and the backend APIs use TLS/HTTPS encryption (Port 443). Cleartext HTTP traffic is blocked in production.
3. **Encrypted Cloud Storage**:
   - Tenant ID proofs and resident photographs are stored in private, encrypted Amazon Web Services (AWS) S3 buckets (`titanstay-assets`) accessible only through authenticated API routes.
4. **Device Security**:
   - Mobile application tokens are stored using hardware-backed secure storage (`flutter_secure_storage` utilizing Android Keystore and iOS Keychain).
   - Cloud automatic backups (`android:allowBackup="false"`) are disabled to prevent data leakage into personal Google Drive or iCloud backups.
5. **Concurrency & Idempotency Safeguards**:
   - Database row-level locking (`FOR UPDATE`) and 30-second idempotency windows prevent accidental double-collection of rent.

---

## 5. Third-Party Disclosures

We share information only with:
- **Authorized Property Staff**: Property owners and administrators managing the specific PG property where a resident stays.
- **Cloud Infrastructure Providers**: AWS (cloud storage) and PostgreSQL database infrastructure operating under strict data processing agreements.
- **Legal & Regulatory Authorities**: When legally obligated to comply with statutory law enforcement or court orders under Indian law.

---

## 6. Data Retention & Account Deletion Policy

### Retention
Tenant and agent records are retained for the duration of the resident's stay or agent's employment, plus any statutory retention periods required by Indian taxation and financial auditing laws.

### User Rights & Account Deletion Request
In compliance with Google Play Developer Policy and Apple App Store Review Guideline 5.1.1:
- Any user, agent, or resident has the right to access, rectify, or request deletion of their personal data.
- **How to Submit a Deletion Request:**
  1. **Email:** Send an email to [privacy@titanstay.com](mailto:privacy@titanstay.com) with the subject *"Account & Data Deletion Request"*.
  2. **Web Portal:** Submit a request through the web form at [https://titanstay.com/delete-account](https://titanstay.com/delete-account).
- Verified requests will result in account deactivation and data purging within **30 business days**, retaining only legally required financial transaction ledger entries.

---

## 7. Compliance Frameworks

- **India:** Digital Personal Data Protection (DPDP) Act, 2023.
- **Google Play:** Google Play Developer Policy (Financial Services & Data Safety Requirements).
- **Apple:** App Store Review Guidelines (Section 5.1 Privacy & Data Collection).

---

## 8. Grievance Officer & Contact Information

For any inquiries, questions, or data protection concerns:

- **Entity:** TitanStay / NestPilot (Dhigrowth)
- **Grievance Officer Email:** [privacy@titanstay.com](mailto:privacy@titanstay.com)
- **Technical Support:** [support@titanstay.com](mailto:support@titanstay.com)
- **Website:** [https://titanstay.com](https://titanstay.com)
- **Location:** Bengaluru, Karnataka, India
