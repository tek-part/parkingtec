// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(amount) =>
      "The daily session will be ended with balance ${amount}";

  static String m1(error) => "Login failed: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "active": MessageLookupByLibrary.simpleMessage("Active"),
    "activeInvoices": MessageLookupByLibrary.simpleMessage("Active Invoices"),
    "additionalOptions": MessageLookupByLibrary.simpleMessage(
      "Additional Options",
    ),
    "allInvoices": MessageLookupByLibrary.simpleMessage("All Invoices"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountMismatch": MessageLookupByLibrary.simpleMessage(
      "Entered amount does not match required amount",
    ),
    "amountRequired": MessageLookupByLibrary.simpleMessage(
      "Amount is required",
    ),
    "appConfig": MessageLookupByLibrary.simpleMessage("App Configuration"),
    "appSubtitle": MessageLookupByLibrary.simpleMessage(
      "Smart Parking Solutions",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("WAFY PARK"),
    "areYouSureLogout": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "areYouSureYouWantToLogout": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "areYouSureYouWantToTerminateTheDaily":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to terminate the daily?",
        ),
    "barcodeEnabled": MessageLookupByLibrary.simpleMessage("Barcode Enabled"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "carColor": MessageLookupByLibrary.simpleMessage("Car Color"),
    "carModel": MessageLookupByLibrary.simpleMessage("Car Model"),
    "carNumber": MessageLookupByLibrary.simpleMessage("Car Number"),
    "carRequested": MessageLookupByLibrary.simpleMessage("Car requested"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearHistory": MessageLookupByLibrary.simpleMessage("Clear History"),
    "clearHistoryConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear all invoices?",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Clear search"),
    "completeInvoice": MessageLookupByLibrary.simpleMessage("Complete Invoice"),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "configError": MessageLookupByLibrary.simpleMessage(
      "Error loading configuration",
    ),
    "configLoading": MessageLookupByLibrary.simpleMessage(
      "Loading configuration...",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmEndSession": MessageLookupByLibrary.simpleMessage(
      "Confirm End Session",
    ),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm Logout"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createInvoice": MessageLookupByLibrary.simpleMessage("Create Invoice"),
    "currency": MessageLookupByLibrary.simpleMessage("EGP"),
    "currencySymbol": MessageLookupByLibrary.simpleMessage("Currency Symbol"),
    "currentAmount": MessageLookupByLibrary.simpleMessage("Current Amount"),
    "customerName": MessageLookupByLibrary.simpleMessage("Customer Name"),
    "dailyAlreadyOpen": MessageLookupByLibrary.simpleMessage(
      "A daily is already open",
    ),
    "dailyStartedSuccess": MessageLookupByLibrary.simpleMessage(
      "Daily started successfully",
    ),
    "dailyTerminatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Daily terminated successfully",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "defaultFixedPrice": MessageLookupByLibrary.simpleMessage(
      "Default Fixed Price",
    ),
    "defaultHourlyRate": MessageLookupByLibrary.simpleMessage(
      "Default Hourly Rate",
    ),
    "disabled": MessageLookupByLibrary.simpleMessage("Disabled"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "duration": MessageLookupByLibrary.simpleMessage("Duration"),
    "enabled": MessageLookupByLibrary.simpleMessage("Enabled"),
    "endBalance": MessageLookupByLibrary.simpleMessage("End balance"),
    "endBalanceDescription": MessageLookupByLibrary.simpleMessage(
      "Enter the final balance for your daily operations",
    ),
    "endBalanceRequired": MessageLookupByLibrary.simpleMessage(
      "End balance is required",
    ),
    "endInvoice": MessageLookupByLibrary.simpleMessage("End Invoice"),
    "endSession": MessageLookupByLibrary.simpleMessage("End Session"),
    "endSessionConfirmationMessage": m0,
    "endSessionDialogTitle": MessageLookupByLibrary.simpleMessage(
      "End Daily Session",
    ),
    "endSessionSuccess": MessageLookupByLibrary.simpleMessage(
      "Session ended successfully",
    ),
    "endTime": MessageLookupByLibrary.simpleMessage("End Time"),
    "endYourDailyShift": MessageLookupByLibrary.simpleMessage(
      "End your daily shift",
    ),
    "endingSession": MessageLookupByLibrary.simpleMessage(
      "Ending active session...",
    ),
    "enterAnyNotes": MessageLookupByLibrary.simpleMessage("Enter any notes..."),
    "enterCarNumber": MessageLookupByLibrary.simpleMessage("Enter car number"),
    "enterEndBalance": MessageLookupByLibrary.simpleMessage(
      "Enter end balance",
    ),
    "enterNotes": MessageLookupByLibrary.simpleMessage(
      "Enter notes (optional)",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorTerminatingDaily": MessageLookupByLibrary.simpleMessage(
      "Error terminating daily",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "finalAmount": MessageLookupByLibrary.simpleMessage("Final Amount"),
    "findParking": MessageLookupByLibrary.simpleMessage("Find Parking"),
    "fixedPricing": MessageLookupByLibrary.simpleMessage("Fixed"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "historyCleared": MessageLookupByLibrary.simpleMessage("History cleared"),
    "hourlyPricing": MessageLookupByLibrary.simpleMessage("Hourly"),
    "hourlyRate": MessageLookupByLibrary.simpleMessage("Hourly Rate"),
    "hours": MessageLookupByLibrary.simpleMessage("hours"),
    "invalidAmount": MessageLookupByLibrary.simpleMessage("Invalid amount"),
    "invalidAmountFormat": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid amount",
    ),
    "invalidEndBalance": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid end balance",
    ),
    "invalidQrCode": MessageLookupByLibrary.simpleMessage("Invalid QR Code"),
    "invalidStartBalance": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid start balance",
    ),
    "invoiceCompleted": MessageLookupByLibrary.simpleMessage(
      "Invoice completed successfully",
    ),
    "invoiceCompletedError": MessageLookupByLibrary.simpleMessage(
      "Error completing invoice",
    ),
    "invoiceCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Invoice created successfully",
    ),
    "invoiceDataNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Invoice data not available",
    ),
    "invoiceDetails": MessageLookupByLibrary.simpleMessage("Invoice Details"),
    "invoiceError": MessageLookupByLibrary.simpleMessage(
      "Error loading invoices",
    ),
    "invoiceHistory": MessageLookupByLibrary.simpleMessage("Invoice History"),
    "invoiceId": MessageLookupByLibrary.simpleMessage("Invoice ID"),
    "invoiceNotFound": MessageLookupByLibrary.simpleMessage(
      "Invoice not found",
    ),
    "invoicePaid": MessageLookupByLibrary.simpleMessage(
      "Invoice paid successfully",
    ),
    "invoicePaidError": MessageLookupByLibrary.simpleMessage(
      "Error paying invoice",
    ),
    "invoicePickedUp": MessageLookupByLibrary.simpleMessage(
      "Invoice picked up successfully",
    ),
    "invoicePickedUpError": MessageLookupByLibrary.simpleMessage(
      "Error picking up invoice",
    ),
    "invoicePrintedSuccess": MessageLookupByLibrary.simpleMessage(
      "Invoice printed successfully",
    ),
    "invoiceRemoved": MessageLookupByLibrary.simpleMessage("Invoice removed"),
    "invoiceStatus": MessageLookupByLibrary.simpleMessage("Invoice Status"),
    "invoices": MessageLookupByLibrary.simpleMessage("Invoices"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "loadingInvoices": MessageLookupByLibrary.simpleMessage(
      "Loading invoices...",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
    "loginFailed": m1,
    "loginTitle": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Logout Confirmation",
    ),
    "logoutError": MessageLookupByLibrary.simpleMessage(
      "An error occurred during logout",
    ),
    "logoutSuccess": MessageLookupByLibrary.simpleMessage(
      "Logged out successfully",
    ),
    "logoutWarning": MessageLookupByLibrary.simpleMessage(
      "This action will end your current session and log you out of the application.",
    ),
    "moreOptions": MessageLookupByLibrary.simpleMessage("More Options"),
    "moreOptionsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Native, preview, share, and more",
    ),
    "mustTerminateDailyBeforeLogout": MessageLookupByLibrary.simpleMessage(
      "You must terminate the daily before logging out",
    ),
    "noActiveInvoices": MessageLookupByLibrary.simpleMessage(
      "No active invoices",
    ),
    "noConfigFound": MessageLookupByLibrary.simpleMessage(
      "No configuration found",
    ),
    "noInvoices": MessageLookupByLibrary.simpleMessage("No invoices"),
    "noInvoicesFound": MessageLookupByLibrary.simpleMessage(
      "No invoices found",
    ),
    "noPendingInvoices": MessageLookupByLibrary.simpleMessage(
      "No pending invoices",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "notesDescription": MessageLookupByLibrary.simpleMessage(
      "Add any additional notes or comments (optional)",
    ),
    "notesOptional": MessageLookupByLibrary.simpleMessage("Notes (optional)"),
    "openInBrowser": MessageLookupByLibrary.simpleMessage("Open in Browser"),
    "openInBrowserSubtitle": MessageLookupByLibrary.simpleMessage(
      "View in external browser",
    ),
    "optionalField": MessageLookupByLibrary.simpleMessage(
      "This field is optional",
    ),
    "paid": MessageLookupByLibrary.simpleMessage("Paid"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "payInvoice": MessageLookupByLibrary.simpleMessage("Pay Invoice"),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "pendingInvoices": MessageLookupByLibrary.simpleMessage("Pending Invoices"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "pickupInvoice": MessageLookupByLibrary.simpleMessage("Pickup Invoice"),
    "pleaseEnterEndBalance": MessageLookupByLibrary.simpleMessage(
      "Please enter the end balance",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "pleaseEnterPhone": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number",
    ),
    "pleaseEnterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number",
    ),
    "pleaseEnterValidAmount": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid amount",
    ),
    "previewPdf": MessageLookupByLibrary.simpleMessage("Preview PDF"),
    "previewPdfSubtitle": MessageLookupByLibrary.simpleMessage(
      "Open in PDF viewer",
    ),
    "pricingType": MessageLookupByLibrary.simpleMessage("Pricing Type"),
    "print": MessageLookupByLibrary.simpleMessage("Print"),
    "printError": MessageLookupByLibrary.simpleMessage("Print Error"),
    "printFailed": MessageLookupByLibrary.simpleMessage("Print failed"),
    "printInvoice": MessageLookupByLibrary.simpleMessage("Print Invoice"),
    "printNative": MessageLookupByLibrary.simpleMessage("Print Native"),
    "printNativeOnSunmi": MessageLookupByLibrary.simpleMessage(
      "Print Native on Sunmi",
    ),
    "printNativeOnSunmiSubtitle": MessageLookupByLibrary.simpleMessage(
      "Print receipt directly without PDF",
    ),
    "printOptions": MessageLookupByLibrary.simpleMessage("Print Options"),
    "printPdf": MessageLookupByLibrary.simpleMessage("Print PDF"),
    "printPdfOnSunmi": MessageLookupByLibrary.simpleMessage(
      "Print PDF on Sunmi",
    ),
    "printPdfOnSunmiSubtitle": MessageLookupByLibrary.simpleMessage(
      "Print PDF directly on thermal printer",
    ),
    "printPreview": MessageLookupByLibrary.simpleMessage("Print Preview"),
    "printSuccessful": MessageLookupByLibrary.simpleMessage(
      "Print successful!",
    ),
    "printing": MessageLookupByLibrary.simpleMessage("Printing..."),
    "processingLogout": MessageLookupByLibrary.simpleMessage(
      "Processing logout...",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "pullToRefresh": MessageLookupByLibrary.simpleMessage("Pull to refresh"),
    "qrCode": MessageLookupByLibrary.simpleMessage("QR Code"),
    "qrCodeRequired": MessageLookupByLibrary.simpleMessage(
      "QR Code is required to complete this invoice",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "requestCar": MessageLookupByLibrary.simpleMessage("Request Car"),
    "requiredField": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "scanQrCode": MessageLookupByLibrary.simpleMessage("Scan QR Code"),
    "scanQrCodeInstructions": MessageLookupByLibrary.simpleMessage(
      "Position QR Code within the frame to scan",
    ),
    "scanQrToComplete": MessageLookupByLibrary.simpleMessage(
      "You must scan QR Code to complete the invoice",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchByCarNumber": MessageLookupByLibrary.simpleMessage(
      "Search by car number",
    ),
    "sessionEndError": MessageLookupByLibrary.simpleMessage(
      "Error ending active session",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "shareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Share via other apps",
    ),
    "showPrices": MessageLookupByLibrary.simpleMessage("Show Prices"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "signInToContinue": MessageLookupByLibrary.simpleMessage(
      "Sign in to continue",
    ),
    "simpleLogout": MessageLookupByLibrary.simpleMessage("Logout"),
    "startBalance": MessageLookupByLibrary.simpleMessage("Start balance"),
    "startBalanceRequired": MessageLookupByLibrary.simpleMessage(
      "Start balance is required",
    ),
    "startDaily": MessageLookupByLibrary.simpleMessage("Start Daily"),
    "startDailySession": MessageLookupByLibrary.simpleMessage(
      "Start Daily Session",
    ),
    "startSession": MessageLookupByLibrary.simpleMessage("Start Session"),
    "startTime": MessageLookupByLibrary.simpleMessage("Start Time"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "systemName": MessageLookupByLibrary.simpleMessage("System Name"),
    "terminate": MessageLookupByLibrary.simpleMessage("Terminate Daily"),
    "terminateDaily": MessageLookupByLibrary.simpleMessage("Terminate Daily"),
    "terminateDailyAndLogout": MessageLookupByLibrary.simpleMessage(
      "Terminate Daily and Logout",
    ),
    "timeElapsed": MessageLookupByLibrary.simpleMessage("Time Elapsed"),
    "unpaid": MessageLookupByLibrary.simpleMessage("Unpaid"),
    "userNotAuthenticated": MessageLookupByLibrary.simpleMessage(
      "User not authenticated",
    ),
    "viewDetails": MessageLookupByLibrary.simpleMessage("View Details"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
  };
}
