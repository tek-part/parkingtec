// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WAFY PARK`
  String get appTitle {
    return Intl.message('WAFY PARK', name: 'appTitle', desc: '', args: []);
  }

  /// `Smart Parking Solutions`
  String get appSubtitle {
    return Intl.message(
      'Smart Parking Solutions',
      name: 'appSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginTitle {
    return Intl.message('Login', name: 'loginTitle', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Find Parking`
  String get findParking {
    return Intl.message(
      'Find Parking',
      name: 'findParking',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Start Daily`
  String get startDaily {
    return Intl.message('Start Daily', name: 'startDaily', desc: '', args: []);
  }

  /// `Start Daily Session`
  String get startDailySession {
    return Intl.message(
      'Start Daily Session',
      name: 'startDailySession',
      desc: '',
      args: [],
    );
  }

  /// `Start Session`
  String get startSession {
    return Intl.message(
      'Start Session',
      name: 'startSession',
      desc: '',
      args: [],
    );
  }

  /// `Start balance`
  String get startBalance {
    return Intl.message(
      'Start balance',
      name: 'startBalance',
      desc: '',
      args: [],
    );
  }

  /// `Notes (optional)`
  String get notesOptional {
    return Intl.message(
      'Notes (optional)',
      name: 'notesOptional',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid start balance`
  String get invalidStartBalance {
    return Intl.message(
      'Please enter a valid start balance',
      name: 'invalidStartBalance',
      desc: '',
      args: [],
    );
  }

  /// `Daily started successfully`
  String get dailyStartedSuccess {
    return Intl.message(
      'Daily started successfully',
      name: 'dailyStartedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `A daily is already open`
  String get dailyAlreadyOpen {
    return Intl.message(
      'A daily is already open',
      name: 'dailyAlreadyOpen',
      desc: '',
      args: [],
    );
  }

  /// `Create Invoice`
  String get createInvoice {
    return Intl.message(
      'Create Invoice',
      name: 'createInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Terminate Daily`
  String get terminateDaily {
    return Intl.message(
      'Terminate Daily',
      name: 'terminateDaily',
      desc: '',
      args: [],
    );
  }

  /// `End balance`
  String get endBalance {
    return Intl.message('End balance', name: 'endBalance', desc: '', args: []);
  }

  /// `Please enter a valid end balance`
  String get invalidEndBalance {
    return Intl.message(
      'Please enter a valid end balance',
      name: 'invalidEndBalance',
      desc: '',
      args: [],
    );
  }

  /// `Daily terminated successfully`
  String get dailyTerminatedSuccess {
    return Intl.message(
      'Daily terminated successfully',
      name: 'dailyTerminatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to terminate the daily?`
  String get areYouSureYouWantToTerminateTheDaily {
    return Intl.message(
      'Are you sure you want to terminate the daily?',
      name: 'areYouSureYouWantToTerminateTheDaily',
      desc: '',
      args: [],
    );
  }

  /// `Terminate Daily`
  String get terminate {
    return Intl.message(
      'Terminate Daily',
      name: 'terminate',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Car Number`
  String get carNumber {
    return Intl.message('Car Number', name: 'carNumber', desc: '', args: []);
  }

  /// `Car number is required`
  String get carNumberRequired {
    return Intl.message(
      'Car number is required',
      name: 'carNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `Car Model`
  String get carModel {
    return Intl.message('Car Model', name: 'carModel', desc: '', args: []);
  }

  /// `Car Model (Optional)`
  String get carModelOptional {
    return Intl.message(
      'Car Model (Optional)',
      name: 'carModelOptional',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name (Optional)`
  String get customerNameOptional {
    return Intl.message(
      'Customer Name (Optional)',
      name: 'customerNameOptional',
      desc: '',
      args: [],
    );
  }

  /// `Car Color`
  String get carColor {
    return Intl.message('Car Color', name: 'carColor', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `EGP`
  String get currency {
    return Intl.message('EGP', name: 'currency', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Print Invoice`
  String get printInvoice {
    return Intl.message(
      'Print Invoice',
      name: 'printInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message('Print', name: 'print', desc: '', args: []);
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Invoice created successfully`
  String get invoiceCreatedSuccess {
    return Intl.message(
      'Invoice created successfully',
      name: 'invoiceCreatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Amount will be calculated based on hourly rate when invoice is completed`
  String get amountWillBeCalculated {
    return Intl.message(
      'Amount will be calculated based on hourly rate when invoice is completed',
      name: 'amountWillBeCalculated',
      desc: '',
      args: [],
    );
  }

  /// `Invoice printed successfully`
  String get invoicePrintedSuccess {
    return Intl.message(
      'Invoice printed successfully',
      name: 'invoicePrintedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Print failed`
  String get printFailed {
    return Intl.message(
      'Print failed',
      name: 'printFailed',
      desc: '',
      args: [],
    );
  }

  /// `Print error`
  String get printError {
    return Intl.message('Print error', name: 'printError', desc: '', args: []);
  }

  /// `Invoice History`
  String get invoiceHistory {
    return Intl.message(
      'Invoice History',
      name: 'invoiceHistory',
      desc: '',
      args: [],
    );
  }

  /// `No invoices found`
  String get noInvoicesFound {
    return Intl.message(
      'No invoices found',
      name: 'noInvoicesFound',
      desc: '',
      args: [],
    );
  }

  /// `Clear History`
  String get clearHistory {
    return Intl.message(
      'Clear History',
      name: 'clearHistory',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear all invoices?`
  String get clearHistoryConfirmation {
    return Intl.message(
      'Are you sure you want to clear all invoices?',
      name: 'clearHistoryConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Invoice removed`
  String get invoiceRemoved {
    return Intl.message(
      'Invoice removed',
      name: 'invoiceRemoved',
      desc: '',
      args: [],
    );
  }

  /// `History cleared`
  String get historyCleared {
    return Intl.message(
      'History cleared',
      name: 'historyCleared',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get areYouSureYouWantToLogout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'areYouSureYouWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the end balance`
  String get pleaseEnterEndBalance {
    return Intl.message(
      'Please enter the end balance',
      name: 'pleaseEnterEndBalance',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid amount`
  String get pleaseEnterValidAmount {
    return Intl.message(
      'Please enter a valid amount',
      name: 'pleaseEnterValidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Enter notes (optional)`
  String get enterNotes {
    return Intl.message(
      'Enter notes (optional)',
      name: 'enterNotes',
      desc: '',
      args: [],
    );
  }

  /// `Logout Confirmation`
  String get logoutConfirmation {
    return Intl.message(
      'Logout Confirmation',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `End balance is required`
  String get endBalanceRequired {
    return Intl.message(
      'End balance is required',
      name: 'endBalanceRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid amount`
  String get invalidAmountFormat {
    return Intl.message(
      'Please enter a valid amount',
      name: 'invalidAmountFormat',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during logout`
  String get logoutError {
    return Intl.message(
      'An error occurred during logout',
      name: 'logoutError',
      desc: '',
      args: [],
    );
  }

  /// `Error ending active session`
  String get sessionEndError {
    return Intl.message(
      'Error ending active session',
      name: 'sessionEndError',
      desc: '',
      args: [],
    );
  }

  /// `Processing logout...`
  String get processingLogout {
    return Intl.message(
      'Processing logout...',
      name: 'processingLogout',
      desc: '',
      args: [],
    );
  }

  /// `Ending active session...`
  String get endingSession {
    return Intl.message(
      'Ending active session...',
      name: 'endingSession',
      desc: '',
      args: [],
    );
  }

  /// `Logged out successfully`
  String get logoutSuccess {
    return Intl.message(
      'Logged out successfully',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Logout`
  String get confirmLogout {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `This action will end your current session and log you out of the application.`
  String get logoutWarning {
    return Intl.message(
      'This action will end your current session and log you out of the application.',
      name: 'logoutWarning',
      desc: '',
      args: [],
    );
  }

  /// `Enter the final balance for your daily operations`
  String get endBalanceDescription {
    return Intl.message(
      'Enter the final balance for your daily operations',
      name: 'endBalanceDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add any additional notes or comments (optional)`
  String get notesDescription {
    return Intl.message(
      'Add any additional notes or comments (optional)',
      name: 'notesDescription',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `This field is optional`
  String get optionalField {
    return Intl.message(
      'This field is optional',
      name: 'optionalField',
      desc: '',
      args: [],
    );
  }

  /// `Print Options`
  String get printOptions {
    return Intl.message(
      'Print Options',
      name: 'printOptions',
      desc: '',
      args: [],
    );
  }

  /// `Print PDF on Sunmi`
  String get printPdfOnSunmi {
    return Intl.message(
      'Print PDF on Sunmi',
      name: 'printPdfOnSunmi',
      desc: '',
      args: [],
    );
  }

  /// `Print PDF directly on thermal printer`
  String get printPdfOnSunmiSubtitle {
    return Intl.message(
      'Print PDF directly on thermal printer',
      name: 'printPdfOnSunmiSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Print Native on Sunmi`
  String get printNativeOnSunmi {
    return Intl.message(
      'Print Native on Sunmi',
      name: 'printNativeOnSunmi',
      desc: '',
      args: [],
    );
  }

  /// `Print receipt directly without PDF`
  String get printNativeOnSunmiSubtitle {
    return Intl.message(
      'Print receipt directly without PDF',
      name: 'printNativeOnSunmiSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Preview PDF`
  String get previewPdf {
    return Intl.message('Preview PDF', name: 'previewPdf', desc: '', args: []);
  }

  /// `Open in PDF viewer`
  String get previewPdfSubtitle {
    return Intl.message(
      'Open in PDF viewer',
      name: 'previewPdfSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Share via other apps`
  String get shareSubtitle {
    return Intl.message(
      'Share via other apps',
      name: 'shareSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Open in Browser`
  String get openInBrowser {
    return Intl.message(
      'Open in Browser',
      name: 'openInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `View in external browser`
  String get openInBrowserSubtitle {
    return Intl.message(
      'View in external browser',
      name: 'openInBrowserSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `More Options`
  String get moreOptions {
    return Intl.message(
      'More Options',
      name: 'moreOptions',
      desc: '',
      args: [],
    );
  }

  /// `Native, preview, share, and more`
  String get moreOptionsSubtitle {
    return Intl.message(
      'Native, preview, share, and more',
      name: 'moreOptionsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Print Preview`
  String get printPreview {
    return Intl.message(
      'Print Preview',
      name: 'printPreview',
      desc: '',
      args: [],
    );
  }

  /// `Print PDF`
  String get printPdf {
    return Intl.message('Print PDF', name: 'printPdf', desc: '', args: []);
  }

  /// `Print Native`
  String get printNative {
    return Intl.message(
      'Print Native',
      name: 'printNative',
      desc: '',
      args: [],
    );
  }

  /// `Printing...`
  String get printing {
    return Intl.message('Printing...', name: 'printing', desc: '', args: []);
  }

  /// `Print successful!`
  String get printSuccessful {
    return Intl.message(
      'Print successful!',
      name: 'printSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Invoice data not available`
  String get invoiceDataNotAvailable {
    return Intl.message(
      'Invoice data not available',
      name: 'invoiceDataNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Additional Options`
  String get additionalOptions {
    return Intl.message(
      'Additional Options',
      name: 'additionalOptions',
      desc: '',
      args: [],
    );
  }

  /// `You must terminate the daily before logging out`
  String get mustTerminateDailyBeforeLogout {
    return Intl.message(
      'You must terminate the daily before logging out',
      name: 'mustTerminateDailyBeforeLogout',
      desc: '',
      args: [],
    );
  }

  /// `Enter end balance`
  String get enterEndBalance {
    return Intl.message(
      'Enter end balance',
      name: 'enterEndBalance',
      desc: '',
      args: [],
    );
  }

  /// `Enter any notes...`
  String get enterAnyNotes {
    return Intl.message(
      'Enter any notes...',
      name: 'enterAnyNotes',
      desc: '',
      args: [],
    );
  }

  /// `Terminate Daily and Logout`
  String get terminateDailyAndLogout {
    return Intl.message(
      'Terminate Daily and Logout',
      name: 'terminateDailyAndLogout',
      desc: '',
      args: [],
    );
  }

  /// `Error terminating daily`
  String get errorTerminatingDaily {
    return Intl.message(
      'Error terminating daily',
      name: 'errorTerminatingDaily',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get signInToContinue {
    return Intl.message(
      'Sign in to continue',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Login failed: {error}`
  String loginFailed(Object error) {
    return Intl.message(
      'Login failed: $error',
      name: 'loginFailed',
      desc: '',
      args: [error],
    );
  }

  /// `User not authenticated`
  String get userNotAuthenticated {
    return Intl.message(
      'User not authenticated',
      name: 'userNotAuthenticated',
      desc: '',
      args: [],
    );
  }

  /// `End Session`
  String get endSession {
    return Intl.message('End Session', name: 'endSession', desc: '', args: []);
  }

  /// `End your daily shift`
  String get endYourDailyShift {
    return Intl.message(
      'End your daily shift',
      name: 'endYourDailyShift',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get simpleLogout {
    return Intl.message('Logout', name: 'simpleLogout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get areYouSureLogout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'areYouSureLogout',
      desc: '',
      args: [],
    );
  }

  /// `End Daily Session`
  String get endSessionDialogTitle {
    return Intl.message(
      'End Daily Session',
      name: 'endSessionDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm End Session`
  String get confirmEndSession {
    return Intl.message(
      'Confirm End Session',
      name: 'confirmEndSession',
      desc: '',
      args: [],
    );
  }

  /// `The daily session will be ended with balance {amount}`
  String endSessionConfirmationMessage(String amount) {
    return Intl.message(
      'The daily session will be ended with balance $amount',
      name: 'endSessionConfirmationMessage',
      desc: '',
      args: [amount],
    );
  }

  /// `Session ended successfully`
  String get endSessionSuccess {
    return Intl.message(
      'Session ended successfully',
      name: 'endSessionSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Start balance is required`
  String get startBalanceRequired {
    return Intl.message(
      'Start balance is required',
      name: 'startBalanceRequired',
      desc: '',
      args: [],
    );
  }

  /// `App Config`
  String get appConfig {
    return Intl.message('App Config', name: 'appConfig', desc: '', args: []);
  }

  /// `System Name`
  String get systemName {
    return Intl.message('System Name', name: 'systemName', desc: '', args: []);
  }

  /// `Pricing Type`
  String get pricingType {
    return Intl.message(
      'Pricing Type',
      name: 'pricingType',
      desc: '',
      args: [],
    );
  }

  /// `Fixed`
  String get fixedPricing {
    return Intl.message('Fixed', name: 'fixedPricing', desc: '', args: []);
  }

  /// `Hourly`
  String get hourlyPricing {
    return Intl.message('Hourly', name: 'hourlyPricing', desc: '', args: []);
  }

  /// `Default Fixed Price`
  String get defaultFixedPrice {
    return Intl.message(
      'Default Fixed Price',
      name: 'defaultFixedPrice',
      desc: '',
      args: [],
    );
  }

  /// `Default Hourly Rate`
  String get defaultHourlyRate {
    return Intl.message(
      'Default Hourly Rate',
      name: 'defaultHourlyRate',
      desc: '',
      args: [],
    );
  }

  /// `Currency Symbol`
  String get currencySymbol {
    return Intl.message(
      'Currency Symbol',
      name: 'currencySymbol',
      desc: '',
      args: [],
    );
  }

  /// `Barcode Enabled`
  String get barcodeEnabled {
    return Intl.message(
      'Barcode Enabled',
      name: 'barcodeEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Show Prices`
  String get showPrices {
    return Intl.message('Show Prices', name: 'showPrices', desc: '', args: []);
  }

  /// `Loading configuration...`
  String get configLoading {
    return Intl.message(
      'Loading configuration...',
      name: 'configLoading',
      desc: '',
      args: [],
    );
  }

  /// `Error loading configuration`
  String get configError {
    return Intl.message(
      'Error loading configuration',
      name: 'configError',
      desc: '',
      args: [],
    );
  }

  /// `No configuration found`
  String get noConfigFound {
    return Intl.message(
      'No configuration found',
      name: 'noConfigFound',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get enabled {
    return Intl.message('Enabled', name: 'enabled', desc: '', args: []);
  }

  /// `Disabled`
  String get disabled {
    return Intl.message('Disabled', name: 'disabled', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Invoices`
  String get invoices {
    return Intl.message('Invoices', name: 'invoices', desc: '', args: []);
  }

  /// `All Invoices`
  String get allInvoices {
    return Intl.message(
      'All Invoices',
      name: 'allInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Active Invoices`
  String get activeInvoices {
    return Intl.message(
      'Active Invoices',
      name: 'activeInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Pending Invoices`
  String get pendingInvoices {
    return Intl.message(
      'Pending Invoices',
      name: 'pendingInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Details`
  String get invoiceDetails {
    return Intl.message(
      'Invoice Details',
      name: 'invoiceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scanQrCode {
    return Intl.message('Scan QR Code', name: 'scanQrCode', desc: '', args: []);
  }

  /// `Position QR Code within the frame to scan`
  String get scanQrCodeInstructions {
    return Intl.message(
      'Position QR Code within the frame to scan',
      name: 'scanQrCodeInstructions',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get qrCode {
    return Intl.message('QR Code', name: 'qrCode', desc: '', args: []);
  }

  /// `Invalid QR Code`
  String get invalidQrCode {
    return Intl.message(
      'Invalid QR Code',
      name: 'invalidQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Search by car number`
  String get searchByCarNumber {
    return Intl.message(
      'Search by car number',
      name: 'searchByCarNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter car number`
  String get enterCarNumber {
    return Intl.message(
      'Enter car number',
      name: 'enterCarNumber',
      desc: '',
      args: [],
    );
  }

  /// `No invoices`
  String get noInvoices {
    return Intl.message('No invoices', name: 'noInvoices', desc: '', args: []);
  }

  /// `No active invoices`
  String get noActiveInvoices {
    return Intl.message(
      'No active invoices',
      name: 'noActiveInvoices',
      desc: '',
      args: [],
    );
  }

  /// `No pending invoices`
  String get noPendingInvoices {
    return Intl.message(
      'No pending invoices',
      name: 'noPendingInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Invoice ID`
  String get invoiceId {
    return Intl.message('Invoice ID', name: 'invoiceId', desc: '', args: []);
  }

  /// `Invoice Status`
  String get invoiceStatus {
    return Intl.message(
      'Invoice Status',
      name: 'invoiceStatus',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Start Time`
  String get startTime {
    return Intl.message('Start Time', name: 'startTime', desc: '', args: []);
  }

  /// `End Time`
  String get endTime {
    return Intl.message('End Time', name: 'endTime', desc: '', args: []);
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `hours`
  String get hours {
    return Intl.message('hours', name: 'hours', desc: '', args: []);
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Unpaid`
  String get unpaid {
    return Intl.message('Unpaid', name: 'unpaid', desc: '', args: []);
  }

  /// `End Invoice`
  String get endInvoice {
    return Intl.message('End Invoice', name: 'endInvoice', desc: '', args: []);
  }

  /// `Complete Invoice`
  String get completeInvoice {
    return Intl.message(
      'Complete Invoice',
      name: 'completeInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Completing invoice...`
  String get completingInvoice {
    return Intl.message(
      'Completing invoice...',
      name: 'completingInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Complete with QR`
  String get completeWithQr {
    return Intl.message(
      'Complete with QR',
      name: 'completeWithQr',
      desc: '',
      args: [],
    );
  }

  /// `Pay Invoice`
  String get payInvoice {
    return Intl.message('Pay Invoice', name: 'payInvoice', desc: '', args: []);
  }

  /// `Pickup Invoice`
  String get pickupInvoice {
    return Intl.message(
      'Pickup Invoice',
      name: 'pickupInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Invoice completed successfully`
  String get invoiceCompleted {
    return Intl.message(
      'Invoice completed successfully',
      name: 'invoiceCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Invoice paid successfully`
  String get invoicePaid {
    return Intl.message(
      'Invoice paid successfully',
      name: 'invoicePaid',
      desc: '',
      args: [],
    );
  }

  /// `Invoice picked up successfully`
  String get invoicePickedUp {
    return Intl.message(
      'Invoice picked up successfully',
      name: 'invoicePickedUp',
      desc: '',
      args: [],
    );
  }

  /// `Error completing invoice`
  String get invoiceCompletedError {
    return Intl.message(
      'Error completing invoice',
      name: 'invoiceCompletedError',
      desc: '',
      args: [],
    );
  }

  /// `Error paying invoice`
  String get invoicePaidError {
    return Intl.message(
      'Error paying invoice',
      name: 'invoicePaidError',
      desc: '',
      args: [],
    );
  }

  /// `Error picking up invoice`
  String get invoicePickedUpError {
    return Intl.message(
      'Error picking up invoice',
      name: 'invoicePickedUpError',
      desc: '',
      args: [],
    );
  }

  /// `Amount is required`
  String get amountRequired {
    return Intl.message(
      'Amount is required',
      name: 'amountRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid amount`
  String get invalidAmount {
    return Intl.message(
      'Invalid amount',
      name: 'invalidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Entered amount does not match required amount`
  String get amountMismatch {
    return Intl.message(
      'Entered amount does not match required amount',
      name: 'amountMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Pull to refresh`
  String get pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'pullToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Loading invoices...`
  String get loadingInvoices {
    return Intl.message(
      'Loading invoices...',
      name: 'loadingInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Load Invoices`
  String get loadInvoices {
    return Intl.message(
      'Load Invoices',
      name: 'loadInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Error loading invoices`
  String get invoiceError {
    return Intl.message(
      'Error loading invoices',
      name: 'invoiceError',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Rate`
  String get hourlyRate {
    return Intl.message('Hourly Rate', name: 'hourlyRate', desc: '', args: []);
  }

  /// `Final Amount`
  String get finalAmount {
    return Intl.message(
      'Final Amount',
      name: 'finalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Current Amount`
  String get currentAmount {
    return Intl.message(
      'Current Amount',
      name: 'currentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Time Elapsed`
  String get timeElapsed {
    return Intl.message(
      'Time Elapsed',
      name: 'timeElapsed',
      desc: '',
      args: [],
    );
  }

  /// `Request Car`
  String get requestCar {
    return Intl.message('Request Car', name: 'requestCar', desc: '', args: []);
  }

  /// `Car requested`
  String get carRequested {
    return Intl.message(
      'Car requested',
      name: 'carRequested',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `QR Code is required to complete this invoice`
  String get qrCodeRequired {
    return Intl.message(
      'QR Code is required to complete this invoice',
      name: 'qrCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `You must scan QR Code to complete the invoice`
  String get scanQrToComplete {
    return Intl.message(
      'You must scan QR Code to complete the invoice',
      name: 'scanQrToComplete',
      desc: '',
      args: [],
    );
  }

  /// `Invoice not found`
  String get invoiceNotFound {
    return Intl.message(
      'Invoice not found',
      name: 'invoiceNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Clear search`
  String get clearSearch {
    return Intl.message(
      'Clear search',
      name: 'clearSearch',
      desc: '',
      args: [],
    );
  }

  /// `Printer Settings`
  String get printerSettings {
    return Intl.message(
      'Printer Settings',
      name: 'printerSettings',
      desc: '',
      args: [],
    );
  }

  /// `Printer Type`
  String get printerType {
    return Intl.message(
      'Printer Type',
      name: 'printerType',
      desc: '',
      args: [],
    );
  }

  /// `Sunmi POS`
  String get printerTypeSunmi {
    return Intl.message(
      'Sunmi POS',
      name: 'printerTypeSunmi',
      desc: '',
      args: [],
    );
  }

  /// `ESC/POS Bluetooth`
  String get printerTypeEscPos {
    return Intl.message(
      'ESC/POS Bluetooth',
      name: 'printerTypeEscPos',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get printerTypeNone {
    return Intl.message('None', name: 'printerTypeNone', desc: '', args: []);
  }

  /// `Paper Width`
  String get paperWidth {
    return Intl.message('Paper Width', name: 'paperWidth', desc: '', args: []);
  }

  /// `Auto Print Options`
  String get autoPrintOptions {
    return Intl.message(
      'Auto Print Options',
      name: 'autoPrintOptions',
      desc: '',
      args: [],
    );
  }

  /// `Auto Print on Create`
  String get autoPrintOnCreate {
    return Intl.message(
      'Auto Print on Create',
      name: 'autoPrintOnCreate',
      desc: '',
      args: [],
    );
  }

  /// `Automatically print entry ticket when invoice is created`
  String get autoPrintOnCreateDesc {
    return Intl.message(
      'Automatically print entry ticket when invoice is created',
      name: 'autoPrintOnCreateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto Print on Complete`
  String get autoPrintOnComplete {
    return Intl.message(
      'Auto Print on Complete',
      name: 'autoPrintOnComplete',
      desc: '',
      args: [],
    );
  }

  /// `Automatically print exit receipt when invoice is completed`
  String get autoPrintOnCompleteDesc {
    return Intl.message(
      'Automatically print exit receipt when invoice is completed',
      name: 'autoPrintOnCompleteDesc',
      desc: '',
      args: [],
    );
  }

  /// `Test Print`
  String get testPrint {
    return Intl.message('Test Print', name: 'testPrint', desc: '', args: []);
  }

  /// `Test print successful`
  String get testPrintSuccess {
    return Intl.message(
      'Test print successful',
      name: 'testPrintSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Reprint Ticket`
  String get reprintTicket {
    return Intl.message(
      'Reprint Ticket',
      name: 'reprintTicket',
      desc: '',
      args: [],
    );
  }

  /// `Reprint Receipt`
  String get reprintReceipt {
    return Intl.message(
      'Reprint Receipt',
      name: 'reprintReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message('Disconnect', name: 'disconnect', desc: '', args: []);
  }

  /// `Printers`
  String get printers {
    return Intl.message('Printers', name: 'printers', desc: '', args: []);
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Searching for printers...`
  String get searchingForPrinters {
    return Intl.message(
      'Searching for printers...',
      name: 'searchingForPrinters',
      desc: '',
      args: [],
    );
  }

  /// `Connected printer shown at top`
  String get connectedPrinterShownAtTop {
    return Intl.message(
      'Connected printer shown at top',
      name: 'connectedPrinterShownAtTop',
      desc: '',
      args: [],
    );
  }

  /// `No printers. Press search`
  String get noPrintersPressSearch {
    return Intl.message(
      'No printers. Press search',
      name: 'noPrintersPressSearch',
      desc: '',
      args: [],
    );
  }

  /// `Connected Printer`
  String get connectedPrinter {
    return Intl.message(
      'Connected Printer',
      name: 'connectedPrinter',
      desc: '',
      args: [],
    );
  }

  /// `Please enable Bluetooth`
  String get pleaseEnableBluetooth {
    return Intl.message(
      'Please enable Bluetooth',
      name: 'pleaseEnableBluetooth',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Language`
  String get invoiceLanguage {
    return Intl.message(
      'Invoice Language',
      name: 'invoiceLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Slice Height`
  String get sliceHeight {
    return Intl.message(
      'Slice Height',
      name: 'sliceHeight',
      desc: '',
      args: [],
    );
  }

  /// `Print Settings`
  String get printSettings {
    return Intl.message(
      'Print Settings',
      name: 'printSettings',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get previewLabel {
    return Intl.message('Preview', name: 'previewLabel', desc: '', args: []);
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Preparing invoice...`
  String get preparingInvoice {
    return Intl.message(
      'Preparing invoice...',
      name: 'preparingInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Select Printer Type`
  String get selectPrinterType {
    return Intl.message(
      'Select Printer Type',
      name: 'selectPrinterType',
      desc: '',
      args: [],
    );
  }

  /// `Connection Status`
  String get connectionStatus {
    return Intl.message(
      'Connection Status',
      name: 'connectionStatus',
      desc: '',
      args: [],
    );
  }

  /// `Not Connected`
  String get notConnected {
    return Intl.message(
      'Not Connected',
      name: 'notConnected',
      desc: '',
      args: [],
    );
  }

  /// `Scanning...`
  String get scanning {
    return Intl.message('Scanning...', name: 'scanning', desc: '', args: []);
  }

  /// `Scan Devices`
  String get scanDevices {
    return Intl.message(
      'Scan Devices',
      name: 'scanDevices',
      desc: '',
      args: [],
    );
  }

  /// `Scan error`
  String get scanError {
    return Intl.message('Scan error', name: 'scanError', desc: '', args: []);
  }

  /// `Available Devices`
  String get availableDevices {
    return Intl.message(
      'Available Devices',
      name: 'availableDevices',
      desc: '',
      args: [],
    );
  }

  /// `Connected Device`
  String get connectedDevice {
    return Intl.message(
      'Connected Device',
      name: 'connectedDevice',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get ready {
    return Intl.message('Ready', name: 'ready', desc: '', args: []);
  }

  /// `Not Initialized`
  String get notInitialized {
    return Intl.message(
      'Not Initialized',
      name: 'notInitialized',
      desc: '',
      args: [],
    );
  }

  /// `Initialize Printer`
  String get initializePrinter {
    return Intl.message(
      'Initialize Printer',
      name: 'initializePrinter',
      desc: '',
      args: [],
    );
  }

  /// `Printer initialized`
  String get printerInitialized {
    return Intl.message(
      'Printer initialized',
      name: 'printerInitialized',
      desc: '',
      args: [],
    );
  }

  /// `Print sent`
  String get printSent {
    return Intl.message('Print sent', name: 'printSent', desc: '', args: []);
  }

  /// `Connected to {deviceName}`
  String connectedToDevice(String deviceName) {
    return Intl.message(
      'Connected to $deviceName',
      name: 'connectedToDevice',
      desc: '',
      args: [deviceName],
    );
  }

  /// `Connection failed`
  String get connectionFailed {
    return Intl.message(
      'Connection failed',
      name: 'connectionFailed',
      desc: '',
      args: [],
    );
  }

  /// `No printer connected. Please connect a printer first.`
  String get noPrinterConnected {
    return Intl.message(
      'No printer connected. Please connect a printer first.',
      name: 'noPrinterConnected',
      desc: '',
      args: [],
    );
  }

  /// `Sunmi print error`
  String get sunmiPrintError {
    return Intl.message(
      'Sunmi print error',
      name: 'sunmiPrintError',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth print error`
  String get bluetoothPrintError {
    return Intl.message(
      'Bluetooth print error',
      name: 'bluetoothPrintError',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth printer not connected`
  String get bluetoothPrinterNotConnected {
    return Intl.message(
      'Bluetooth printer not connected',
      name: 'bluetoothPrinterNotConnected',
      desc: '',
      args: [],
    );
  }

  /// `Please connect to a printer first`
  String get pleaseConnectToPrinterFirst {
    return Intl.message(
      'Please connect to a printer first',
      name: 'pleaseConnectToPrinterFirst',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth test print - implement ESC/POS commands`
  String get bluetoothTestPrintNotImplemented {
    return Intl.message(
      'Bluetooth test print - implement ESC/POS commands',
      name: 'bluetoothTestPrintNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Printer Not Connected`
  String get printerNotConnected {
    return Intl.message(
      'Printer Not Connected',
      name: 'printerNotConnected',
      desc: '',
      args: [],
    );
  }

  /// `You are not connected to a printer. Please connect a printer to print invoices.`
  String get printerNotConnectedMessage {
    return Intl.message(
      'You are not connected to a printer. Please connect a printer to print invoices.',
      name: 'printerNotConnectedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Go to Settings`
  String get goToSettings {
    return Intl.message(
      'Go to Settings',
      name: 'goToSettings',
      desc: '',
      args: [],
    );
  }

  /// `Continue without printing`
  String get continueWithoutPrinting {
    return Intl.message(
      'Continue without printing',
      name: 'continueWithoutPrinting',
      desc: '',
      args: [],
    );
  }

  /// `Checking authentication...`
  String get checkingAuthentication {
    return Intl.message(
      'Checking authentication...',
      name: 'checkingAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Connection error. Retrying...`
  String get connectionErrorRetrying {
    return Intl.message(
      'Connection error. Retrying...',
      name: 'connectionErrorRetrying',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
