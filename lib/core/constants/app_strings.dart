/// Unified String Constants
/// STRICT RULE: All static user-facing text strings MUST be defined here.
/// Inline string literals in screens/widgets are strictly forbidden.
class AppStrings {
  AppStrings._();

  // App & Branding
  static const String appTitle = 'NestPilot';
  static const String appSubtitle = 'Collection Agent';
  static const String adminHeaderTitle = 'NestPilot PG ADMIN';

  // Auth Screen
  static const String welcomeBack = 'Welcome back!!';
  static const String pleaseSignIn = 'Please sign in to continue';
  static const String phoneLabel = 'PHONE NUMBER';
  static const String phonePlaceholder = '+91 96455 54566';
  static const String passcodeLabel = '4-DIGIT PASSCODE';
  static const String passcodePlaceholder = '1234';
  static const String logInButton = 'Log In';
  static const String phoneRequiredError = 'Please enter your phone number';
  static const String phoneInvalidError = 'Please enter a valid phone number';
  static const String passcodeRequiredError = 'Please enter your 4-digit passcode';
  static const String passcodeInvalidError = 'Passcode must be 4 digits';
  static const String tenantIdRequiredError = 'Tenant ID is required';

  // Room Management Screen
  static const String totalRooms = 'Total Rooms';
  static const String totalBeds = 'Total Beds';
  static const String allBlocks = 'All Blocks';
  static const String pay = 'PAY';
  static const String paid = 'PAID';
  static const String currencySymbol = '₹';
  static const String vacantLabel = 'vacant';
  static const String roomsCountSuffix = 'Rooms';
  static const String bedsCountPrefix = 'Beds:';

  // Payment Bottom Sheet
  static const String amountDue = 'Amount Due';
  static const String fullPartialPayment = 'Full / Partial Payment';
  static const String selectPayment = 'Select Payment';
  static const String fullPayment = 'Full Payment';
  static const String partialPayment = 'Partial Payment';
  static const String selectPaymentTypeError = 'Please select Full or Partial payment';
  static const String paymentOption = 'Payment Option';
  static const String selectPaymentOption = 'Select Payment Option';
  static const String amountLabel = 'Amount *';
  static const String cancel = 'Cancel';
  static const String submitPay = 'Pay';
  static const String paymentOptionCash = 'Cash';
  static const String paymentOptionUPI = 'UPI';
  static const String paymentOptionCard = 'Card';
  static const String paymentOptionNetBanking = 'Net Banking';
  static const String paymentSuccess = 'Payment recorded successfully!';
  static const String paymentInvalidAmount = 'Please enter a valid payment amount';
  static const String paymentExceedsDue = 'Amount cannot exceed amount due';
  static const String paymentSelectOptionError = 'Please select a payment option';

  // Tenant Details Bottom Sheet
  static const String customerDetailsPrefix = 'Customer Details : ';
  static const String labelName = 'Name';
  static const String labelCustomerId = 'Customer ID';
  static const String labelEmail = 'Email';
  static const String labelPhone = 'Phone';
  static const String labelDob = 'Date of Birth';
  static const String labelJoiningDate = 'Joining Date';
  static const String labelGender = 'Gender';
  static const String labelIdProofs = 'ID Proofs';
  static const String labelEmergencyContact1 = 'Emergency Contact 1';
  static const String labelEmergencyContact2 = 'Emergency Contact 2';
  static const String labelRoom = 'Room';
  static const String labelStatus = 'Status';
  static const String statusActive = 'Active';
  static const String statusInactive = 'Inactive';

  // Collection History Screen
  static const String collectionHistoryTitle = 'Collection History';
  static const String titanPg = 'Titan PG';
  static const String searchTransactionsHint = 'Search transactions';
  static const String paymentChannels = 'Payment Channels';
  static const String showingAll = 'Showing All';
  static const String todayGroup = 'TODAY';
  static const String yesterdayGroup = 'YESTERDAY';
  static const String channelAll = 'All';
  static const String channelCash = 'Cash';
  static const String channelUpi = 'UPI';
  static const String channelCard = 'Card';
  static const String channelBankTransfer = 'Bank Transfer';
  static const String channelCheque = 'Cheque';
  static const String noTransactionsFound = 'No transactions found';
}
