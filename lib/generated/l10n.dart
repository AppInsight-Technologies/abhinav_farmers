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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About us`
  String get about_us {
    return Intl.message(
      'About us',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `ADD`
  String get add {
    return Intl.message(
      'ADD',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add Address`
  String get add_address {
    return Intl.message(
      'Add Address',
      name: 'add_address',
      desc: '',
      args: [],
    );
  }

  /// `Address Book`
  String get address_book {
    return Intl.message(
      'Address Book',
      name: 'address_book',
      desc: '',
      args: [],
    );
  }

  /// `address of your choice`
  String get address_of_your_choice {
    return Intl.message(
      'address of your choice',
      name: 'address_of_your_choice',
      desc: '',
      args: [],
    );
  }

  /// `By continuing you agree to the `
  String get agreed_terms {
    return Intl.message(
      'By continuing you agree to the ',
      name: 'agreed_terms',
      desc: '',
      args: [],
    );
  }

  /// `All Categories`
  String get all_categories {
    return Intl.message(
      'All Categories',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `Get your order delivered to an address of your choice`
  String get also_address {
    return Intl.message(
      'Get your order delivered to an address of your choice',
      name: 'also_address',
      desc: '',
      args: [],
    );
  }

  /// `GroBay `
  String get app_name {
    return Intl.message(
      'GroBay ',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `App version`
  String get app_version {
    return Intl.message(
      'App version',
      name: 'app_version',
      desc: '',
      args: [],
    );
  }

  /// `Available Points`
  String get available_points {
    return Intl.message(
      'Available Points',
      name: 'available_points',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `BUY ONCE`
  String get buy_once {
    return Intl.message(
      'BUY ONCE',
      name: 'buy_once',
      desc: '',
      args: [],
    );
  }

  /// `Call me Instead`
  String get call_me_instead {
    return Intl.message(
      'Call me Instead',
      name: 'call_me_instead',
      desc: '',
      args: [],
    );
  }

  /// `We'll call or text you a OTP to confirm.`
  String get call_or_text_for_confirmation {
    return Intl.message(
      'We\'ll call or text you a OTP to confirm.',
      name: 'call_or_text_for_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `CHOOSE LOCATION`
  String get choose_location {
    return Intl.message(
      'CHOOSE LOCATION',
      name: 'choose_location',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Preferred Language`
  String get chose_your_preferred_language {
    return Intl.message(
      'Choose Your Preferred Language',
      name: 'chose_your_preferred_language',
      desc: '',
      args: [],
    );
  }

  /// `Confirm location & Proceed`
  String get confirm_location_proceed {
    return Intl.message(
      'Confirm location & Proceed',
      name: 'confirm_location_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Country/Region`
  String get country_region {
    return Intl.message(
      'Country/Region',
      name: 'country_region',
      desc: '',
      args: [],
    );
  }

  /// `Customer Support`
  String get customer_support {
    return Intl.message(
      'Customer Support',
      name: 'customer_support',
      desc: '',
      args: [],
    );
  }

  /// `Default Address:`
  String get default_address {
    return Intl.message(
      'Default Address:',
      name: 'default_address',
      desc: '',
      args: [],
    );
  }

  /// `DELETE`
  String get delete {
    return Intl.message(
      'DELETE',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Don't have any item in the notification list`
  String get dont_have_any_notification {
    return Intl.message(
      'Don\'t have any item in the notification list',
      name: 'dont_have_any_notification',
      desc: '',
      args: [],
    );
  }

  /// `DOWNLOAD APP`
  String get download_our_app {
    return Intl.message(
      'DOWNLOAD APP',
      name: 'download_our_app',
      desc: '',
      args: [],
    );
  }

  /// `Download the app for the best`
  String get download_app_for_best {
    return Intl.message(
      'Download the app for the best',
      name: 'download_app_for_best',
      desc: '',
      args: [],
    );
  }

  /// `EDIT`
  String get edit {
    return Intl.message(
      'EDIT',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Eligible For Express Delivery`
  String get eligible_for_express_delivery {
    return Intl.message(
      'Eligible For Express Delivery',
      name: 'eligible_for_express_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mobile number`
  String get enter_yor_mobile_number {
    return Intl.message(
      'Enter your mobile number',
      name: 'enter_yor_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Existing customer?`
  String get existing_customer {
    return Intl.message(
      'Existing customer?',
      name: 'existing_customer',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get explore {
    return Intl.message(
      'Explore',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Explore by Category`
  String get explore_by_cat {
    return Intl.message(
      'Explore by Category',
      name: 'explore_by_cat',
      desc: '',
      args: [],
    );
  }

  /// `Extra delivery fee`
  String get extra_delivery_fee {
    return Intl.message(
      'Extra delivery fee',
      name: 'extra_delivery_fee',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filter {
    return Intl.message(
      'Filters',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `For Your Convenience`
  String get for_your_convenience {
    return Intl.message(
      'For Your Convenience',
      name: 'for_your_convenience',
      desc: '',
      args: [],
    );
  }

  /// `Free Delivery`
  String get free_delivery {
    return Intl.message(
      'Free Delivery',
      name: 'free_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Get membership & other benefits`
  String get get_membership_and_other {
    return Intl.message(
      'Get membership & other benefits',
      name: 'get_membership_and_other',
      desc: '',
      args: [],
    );
  }

  /// `Get social with us`
  String get get_social_with_us {
    return Intl.message(
      'Get social with us',
      name: 'get_social_with_us',
      desc: '',
      args: [],
    );
  }

  /// `Go To Home`
  String get go_to_home {
    return Intl.message(
      'Go To Home',
      name: 'go_to_home',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Home Delivery`
  String get home_delivery {
    return Intl.message(
      'Home Delivery',
      name: 'home_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get invite {
    return Intl.message(
      'Invite',
      name: 'invite',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Let's Begin`
  String get lets_get_you_started {
    return Intl.message(
      'Let\'s Begin',
      name: 'lets_get_you_started',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get log_out {
    return Intl.message(
      'Log Out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get login {
    return Intl.message(
      'LOGIN',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Login/ Sign Up`
  String get login_register {
    return Intl.message(
      'Login/ Sign Up',
      name: 'login_register',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN USING OTP`
  String get login_using_otp {
    return Intl.message(
      'LOGIN USING OTP',
      name: 'login_using_otp',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty`
  String get loyalty {
    return Intl.message(
      'Loyalty',
      name: 'loyalty',
      desc: '',
      args: [],
    );
  }

  /// `Membership`
  String get membership {
    return Intl.message(
      'Membership',
      name: 'membership',
      desc: '',
      args: [],
    );
  }

  /// `Membership Price`
  String get membership_price {
    return Intl.message(
      'Membership Price',
      name: 'membership_price',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get mobile_number {
    return Intl.message(
      'Mobile number',
      name: 'mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `MORE`
  String get more {
    return Intl.message(
      'MORE',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `My Addresses`
  String get my_address {
    return Intl.message(
      'My Addresses',
      name: 'my_address',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message(
      'My Orders',
      name: 'my_orders',
      desc: '',
      args: [],
    );
  }

  /// `My shopping list`
  String get my_shopping_list {
    return Intl.message(
      'My shopping list',
      name: 'my_shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `My Subscription`
  String get my_subscription {
    return Intl.message(
      'My Subscription',
      name: 'my_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Notify Me`
  String get notify_me {
    return Intl.message(
      'Notify Me',
      name: 'notify_me',
      desc: '',
      args: [],
    );
  }

  /// `% OFF`
  String get off {
    return Intl.message(
      '% OFF',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `OFFERS`
  String get offers {
    return Intl.message(
      'OFFERS',
      name: 'offers',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message(
      'OR',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get order_status {
    return Intl.message(
      'Order Status',
      name: 'order_status',
      desc: '',
      args: [],
    );
  }

  /// `Pack Sizes`
  String get pack_size {
    return Intl.message(
      'Pack Sizes',
      name: 'pack_size',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Please check OTP sent to your mobile number`
  String get please_check_otp_sent_to_your_mobile_number {
    return Intl.message(
      'Please check OTP sent to your mobile number',
      name: 'please_check_otp_sent_to_your_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `  Please enter name`
  String get please_enter_name {
    return Intl.message(
      '  Please enter name',
      name: 'please_enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a Mobile number`
  String get please_enter_phone_number {
    return Intl.message(
      'Please enter a Mobile number',
      name: 'please_enter_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get please_enter_valid_email_address {
    return Intl.message(
      'Please enter a valid email address',
      name: 'please_enter_valid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Popular Brands`
  String get popular_brands {
    return Intl.message(
      'Popular Brands',
      name: 'popular_brands',
      desc: '',
      args: [],
    );
  }

  /// `Popular Searches`
  String get popular_search {
    return Intl.message(
      'Popular Searches',
      name: 'popular_search',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & others`
  String get privacy_others {
    return Intl.message(
      'Privacy & others',
      name: 'privacy_others',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Checkout`
  String get proceed_to_pay {
    return Intl.message(
      'Proceed to Checkout',
      name: 'proceed_to_pay',
      desc: '',
      args: [],
    );
  }

  /// `Product catalogue and offers are location specific`
  String get product_and_location_specified {
    return Intl.message(
      'Product catalogue and offers are location specific',
      name: 'product_and_location_specified',
      desc: '',
      args: [],
    );
  }

  /// `Rate us on Appstore`
  String get rate_us_on_app_store {
    return Intl.message(
      'Rate us on Appstore',
      name: 'rate_us_on_app_store',
      desc: '',
      args: [],
    );
  }

  /// `Rate us on Play Store`
  String get rate_us_on_play_store {
    return Intl.message(
      'Rate us on Play Store',
      name: 'rate_us_on_play_store',
      desc: '',
      args: [],
    );
  }

  /// `Referral Code`
  String get refer_earn {
    return Intl.message(
      'Referral Code',
      name: 'refer_earn',
      desc: '',
      args: [],
    );
  }

  /// `Referrals count`
  String get referer_count {
    return Intl.message(
      'Referrals count',
      name: 'referer_count',
      desc: '',
      args: [],
    );
  }

  /// `Refund Policy`
  String get refund_policy {
    return Intl.message(
      'Refund Policy',
      name: 'refund_policy',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resend_otp {
    return Intl.message(
      'Resend Code',
      name: 'resend_otp',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code in`
  String get resend_otp_in {
    return Intl.message(
      'Resend Code in',
      name: 'resend_otp_in',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get result {
    return Intl.message(
      'Results',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Return policy`
  String get return_policy {
    return Intl.message(
      'Return policy',
      name: 'return_policy',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get returns {
    return Intl.message(
      'Return',
      name: 'returns',
      desc: '',
      args: [],
    );
  }

  /// `Saved Addresses`
  String get saved_address {
    return Intl.message(
      'Saved Addresses',
      name: 'saved_address',
      desc: '',
      args: [],
    );
  }

  /// `Search From 10,000+ products`
  String get search_from_products {
    return Intl.message(
      'Search From 10,000+ products',
      name: 'search_from_products',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery location`
  String get select_delivery_location {
    return Intl.message(
      'Select delivery location',
      name: 'select_delivery_location',
      desc: '',
      args: [],
    );
  }

  /// `Select Delivery Type`
  String get select_delivery_type {
    return Intl.message(
      'Select Delivery Type',
      name: 'select_delivery_type',
      desc: '',
      args: [],
    );
  }

  /// `Select a self pick-up point near you and pick your order at your convenience`
  String get select_self_pickup_point {
    return Intl.message(
      'Select a self pick-up point near you and pick your order at your convenience',
      name: 'select_self_pickup_point',
      desc: '',
      args: [],
    );
  }

  /// `Self Pick Up`
  String get self_pickup {
    return Intl.message(
      'Self Pick Up',
      name: 'self_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Shop by Brands`
  String get shop_by_brands {
    return Intl.message(
      'Shop by Brands',
      name: 'shop_by_brands',
      desc: '',
      args: [],
    );
  }

  /// `SHOP BY CATEGORY`
  String get shop_by_category {
    return Intl.message(
      'SHOP BY CATEGORY',
      name: 'shop_by_category',
      desc: '',
      args: [],
    );
  }

  /// `Shopping list`
  String get shopping_list {
    return Intl.message(
      'Shopping list',
      name: 'shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Facebook`
  String get sign_in_with_facebook {
    return Intl.message(
      'Sign in with Facebook',
      name: 'sign_in_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get sign_in_with_google {
    return Intl.message(
      'Sign in with Google',
      name: 'sign_in_with_google',
      desc: '',
      args: [],
    );
  }

  /// ` SKIP`
  String get skip {
    return Intl.message(
      ' SKIP',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Start Shopping`
  String get start_shopping {
    return Intl.message(
      'Start Shopping',
      name: 'start_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get sub_total {
    return Intl.message(
      'Sub Total',
      name: 'sub_total',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscribe {
    return Intl.message(
      'Subscribe',
      name: 'subscribe',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select one of the delivery modes`
  String get tap_to_select_one_delivery_mode {
    return Intl.message(
      'Tap to select one of the delivery modes',
      name: 'tap_to_select_one_delivery_mode',
      desc: '',
      args: [],
    );
  }

  /// `Tell us your e-mail`
  String get tell_us_your_email {
    return Intl.message(
      'Tell us your e-mail',
      name: 'tell_us_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Term & Conditions`
  String get term_and_condition {
    return Intl.message(
      'Term & Conditions',
      name: 'term_and_condition',
      desc: '',
      args: [],
    );
  }

  /// ` terms of service`
  String get terms_of_service {
    return Intl.message(
      ' terms of service',
      name: 'terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get terms_of_use {
    return Intl.message(
      'Terms of Use',
      name: 'terms_of_use',
      desc: '',
      args: [],
    );
  }

  /// `There is no transaction`
  String get there_is_no_transaction {
    return Intl.message(
      'There is no transaction',
      name: 'there_is_no_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Useful Links`
  String get useful_link {
    return Intl.message(
      'Useful Links',
      name: 'useful_link',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get view_all {
    return Intl.message(
      'View All',
      name: 'view_all',
      desc: '',
      args: [],
    );
  }

  /// `VIEW DETAILS`
  String get view_details {
    return Intl.message(
      'VIEW DETAILS',
      name: 'view_details',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Balance`
  String get wallet_balance {
    return Intl.message(
      'Wallet Balance',
      name: 'wallet_balance',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Policy`
  String get wallet_policy {
    return Intl.message(
      'Wallet Policy',
      name: 'wallet_policy',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcome {
    return Intl.message(
      'Welcome to',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `* What should we call you?`
  String get what_should_we_call_you {
    return Intl.message(
      '* What should we call you?',
      name: 'what_should_we_call_you',
      desc: '',
      args: [],
    );
  }

  /// `You are not logged in, please log in to continue`
  String get you_are_not_logged_in {
    return Intl.message(
      'You are not logged in, please log in to continue',
      name: 'you_are_not_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `You have no past orders`
  String get you_have_no_order {
    return Intl.message(
      'You have no past orders',
      name: 'you_have_no_order',
      desc: '',
      args: [],
    );
  }

  /// `Share your Code`
  String get your_code {
    return Intl.message(
      'Share your Code',
      name: 'your_code',
      desc: '',
      args: [],
    );
  }

  /// `Earned through referrals`
  String get your_earning {
    return Intl.message(
      'Earned through referrals',
      name: 'your_earning',
      desc: '',
      args: [],
    );
  }

  /// `YOUR LOCATION`
  String get your_location {
    return Intl.message(
      'YOUR LOCATION',
      name: 'your_location',
      desc: '',
      args: [],
    );
  }

  /// `your order at your convenient`
  String get your_order_doorstep {
    return Intl.message(
      'your order at your convenient',
      name: 'your_order_doorstep',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid otp!!!`
  String get please_enter_valid_otp {
    return Intl.message(
      'Please enter a valid otp!!!',
      name: 'please_enter_valid_otp',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, we don't deliver in`
  String get sorry_wedidnt_deliever {
    return Intl.message(
      'Sorry, we don\'t deliver in',
      name: 'sorry_wedidnt_deliever',
      desc: '',
      args: [],
    );
  }

  /// `Change Location`
  String get change_location {
    return Intl.message(
      'Change Location',
      name: 'change_location',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get no_internet {
    return Intl.message(
      'No internet connection',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `Ugh! Something's not right with your internet`
  String get not_right_internet {
    return Intl.message(
      'Ugh! Something\'s not right with your internet',
      name: 'not_right_internet',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message(
      'Try Again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Availability Check`
  String get Availability_Check {
    return Intl.message(
      'Availability Check',
      name: 'Availability_Check',
      desc: '',
      args: [],
    );
  }

  /// `Changing area`
  String get changing_area {
    return Intl.message(
      'Changing area',
      name: 'changing_area',
      desc: '',
      args: [],
    );
  }

  /// `Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.`
  String get product_price_availability {
    return Intl.message(
      'Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.',
      name: 'product_price_availability',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get reason {
    return Intl.message(
      'Reason',
      name: 'reason',
      desc: '',
      args: [],
    );
  }

  /// `Refund`
  String get refund {
    return Intl.message(
      'Refund',
      name: 'refund',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'v1.live' key

  /// `Business Name`
  String get business_name {
    return Intl.message(
      'Business Name',
      name: 'business_name',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Contact Number`
  String get contactnumber {
    return Intl.message(
      'Contact Number',
      name: 'contactnumber',
      desc: '',
      args: [],
    );
  }

  /// `Email/Write to us at`
  String get email {
    return Intl.message(
      'Email/Write to us at',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Call Now`
  String get call {
    return Intl.message(
      'Call Now',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Whatsapp Chat`
  String get whatsapp_chat {
    return Intl.message(
      'Whatsapp Chat',
      name: 'whatsapp_chat',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get not_available {
    return Intl.message(
      'Not available',
      name: 'not_available',
      desc: '',
      args: [],
    );
  }

  /// `Note: `
  String get note {
    return Intl.message(
      'Note: ',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `By clicking on confirm, we will remove the unavailable items from your basket and you can add similar product of unavailable items.`
  String get by_clicking_confirm {
    return Intl.message(
      'By clicking on confirm, we will remove the unavailable items from your basket and you can add similar product of unavailable items.',
      name: 'by_clicking_confirm',
      desc: '',
      args: [],
    );
  }

  /// `CONFIRM`
  String get confirm {
    return Intl.message(
      'CONFIRM',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Create shopping list`
  String get create_shopping_list {
    return Intl.message(
      'Create shopping list',
      name: 'create_shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `ADD TO LIST`
  String get add_to_list {
    return Intl.message(
      'ADD TO LIST',
      name: 'add_to_list',
      desc: '',
      args: [],
    );
  }

  /// `Create New`
  String get create_new {
    return Intl.message(
      'Create New',
      name: 'create_new',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get cart_add {
    return Intl.message(
      'Add',
      name: 'cart_add',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signin {
    return Intl.message(
      'Sign in',
      name: 'signin',
      desc: '',
      args: [],
    );
  }

  /// `We'll call or text you to confirm your number. Standard message data rates apply.`
  String get we_will_call_or_text {
    return Intl.message(
      'We\'ll call or text you to confirm your number. Standard message data rates apply.',
      name: 'we_will_call_or_text',
      desc: '',
      args: [],
    );
  }

  /// `Add your info`
  String get add_info {
    return Intl.message(
      'Add your info',
      name: 'add_info',
      desc: '',
      args: [],
    );
  }

  /// `We'll email you as a reservation confirmation`
  String get we_will_email {
    return Intl.message(
      'We\'ll email you as a reservation confirmation',
      name: 'we_will_email',
      desc: '',
      args: [],
    );
  }

  /// `CONTINUE`
  String get continue_button {
    return Intl.message(
      'CONTINUE',
      name: 'continue_button',
      desc: '',
      args: [],
    );
  }

  /// `Signup using OTP`
  String get signup_otp {
    return Intl.message(
      'Signup using OTP',
      name: 'signup_otp',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get enter_otp {
    return Intl.message(
      'Enter OTP',
      name: 'enter_otp',
      desc: '',
      args: [],
    );
  }

  /// `Call in`
  String get call_in {
    return Intl.message(
      'Call in',
      name: 'call_in',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty!`
  String get cart_empty {
    return Intl.message(
      'Your cart is empty!',
      name: 'cart_empty',
      desc: '',
      args: [],
    );
  }

  /// `Products unavailable`
  String get product_unavailable {
    return Intl.message(
      'Products unavailable',
      name: 'product_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Bill Details`
  String get bill_details {
    return Intl.message(
      'Bill Details',
      name: 'bill_details',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charges Extra`
  String get delivery_charge_extra {
    return Intl.message(
      'Delivery Charges Extra',
      name: 'delivery_charge_extra',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge `
  String get delivery_charge {
    return Intl.message(
      'Delivery Charge ',
      name: 'delivery_charge',
      desc: '',
      args: [],
    );
  }

  /// `Select Time Slot`
  String get select_TimeSlot {
    return Intl.message(
      'Select Time Slot',
      name: 'select_TimeSlot',
      desc: '',
      args: [],
    );
  }

  /// `Shipment`
  String get shipment {
    return Intl.message(
      'Shipment',
      name: 'shipment',
      desc: '',
      args: [],
    );
  }

  /// `Delivery in`
  String get delivery_in {
    return Intl.message(
      'Delivery in',
      name: 'delivery_in',
      desc: '',
      args: [],
    );
  }

  /// `Choose a delivery address`
  String get choose_delivery_address {
    return Intl.message(
      'Choose a delivery address',
      name: 'choose_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get add_new_address {
    return Intl.message(
      'Add New Address',
      name: 'add_new_address',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time slot as per your convience. Your order will be delivered during the time slot.`
  String get please_select_delivery_slot {
    return Intl.message(
      'Please select a time slot as per your convience. Your order will be delivered during the time slot.',
      name: 'please_select_delivery_slot',
      desc: '',
      args: [],
    );
  }

  /// `You are not Logged in, Please Login to Continue with Proceed To Checkout`
  String get not_yet_logged_in {
    return Intl.message(
      'You are not Logged in, Please Login to Continue with Proceed To Checkout',
      name: 'not_yet_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get select_delivery_address {
    return Intl.message(
      'Delivery Address',
      name: 'select_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change_caps {
    return Intl.message(
      'Change',
      name: 'change_caps',
      desc: '',
      args: [],
    );
  }

  /// `You are in a new location!`
  String get your_in_new_location {
    return Intl.message(
      'You are in a new location!',
      name: 'your_in_new_location',
      desc: '',
      args: [],
    );
  }

  /// `Select Address`
  String get select_address {
    return Intl.message(
      'Select Address',
      name: 'select_address',
      desc: '',
      args: [],
    );
  }

  /// `Standard Delivery`
  String get slot_based_delivery {
    return Intl.message(
      'Standard Delivery',
      name: 'slot_based_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Express Delivery`
  String get express_delivery {
    return Intl.message(
      'Express Delivery',
      name: 'express_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Currently there is no slots available`
  String get currently_no_slot {
    return Intl.message(
      'Currently there is no slots available',
      name: 'currently_no_slot',
      desc: '',
      args: [],
    );
  }

  /// `CONFIRM ORDER`
  String get confirm_order {
    return Intl.message(
      'CONFIRM ORDER',
      name: 'confirm_order',
      desc: '',
      args: [],
    );
  }

  /// `Currently there is no store address available`
  String get currently_no_store {
    return Intl.message(
      'Currently there is no store address available',
      name: 'currently_no_store',
      desc: '',
      args: [],
    );
  }

  /// `Select Store for Pickup`
  String get select_store_pickup {
    return Intl.message(
      'Select Store for Pickup',
      name: 'select_store_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Your Time Slot`
  String get select_your_timeslot {
    return Intl.message(
      'Your Time Slot',
      name: 'select_your_timeslot',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get date {
    return Intl.message(
      'Date:',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Currently there is no slots available for this address`
  String get currently_no_time_address {
    return Intl.message(
      'Currently there is no slots available for this address',
      name: 'currently_no_time_address',
      desc: '',
      args: [],
    );
  }

  /// `My Basket`
  String get my_basket {
    return Intl.message(
      'My Basket',
      name: 'my_basket',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signin_apple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signin_apple',
      desc: '',
      args: [],
    );
  }

  /// `Delivery on`
  String get delivery_on {
    return Intl.message(
      'Delivery on',
      name: 'delivery_on',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Total: `
  String get total {
    return Intl.message(
      'Total: ',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `item`
  String get item {
    return Intl.message(
      'item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `View Cart`
  String get view_cart {
    return Intl.message(
      'View Cart',
      name: 'view_cart',
      desc: '',
      args: [],
    );
  }

  /// `That's all folks!`
  String get thats_all_folk {
    return Intl.message(
      'That\'s all folks!',
      name: 'thats_all_folk',
      desc: '',
      args: [],
    );
  }

  /// `Edit your info`
  String get edit_info {
    return Intl.message(
      'Edit your info',
      name: 'edit_info',
      desc: '',
      args: [],
    );
  }

  /// `Enter Verification Code`
  String get enter_verification_code {
    return Intl.message(
      'Enter Verification Code',
      name: 'enter_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a verification code to `
  String get send_verification_codeto {
    return Intl.message(
      'We have sent a verification code to ',
      name: 'send_verification_codeto',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE PROFILE`
  String get update_profile {
    return Intl.message(
      'UPDATE PROFILE',
      name: 'update_profile',
      desc: '',
      args: [],
    );
  }

  /// `Your number`
  String get your_number {
    return Intl.message(
      'Your number',
      name: 'your_number',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// ` privacy policy`
  String get privacy_policy {
    return Intl.message(
      ' privacy policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// ` Hours`
  String get hours {
    return Intl.message(
      ' Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `Please select delivery address!`
  String get please_select_delivery_address {
    return Intl.message(
      'Please select delivery address!',
      name: 'please_select_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a address`
  String get please_provide_address {
    return Intl.message(
      'Please provide a address',
      name: 'please_provide_address',
      desc: '',
      args: [],
    );
  }

  /// `Minimum order amount is `
  String get min_order_amount {
    return Intl.message(
      'Minimum order amount is ',
      name: 'min_order_amount',
      desc: '',
      args: [],
    );
  }

  /// `Maximum order amount is `
  String get max_order_amount {
    return Intl.message(
      'Maximum order amount is ',
      name: 'max_order_amount',
      desc: '',
      args: [],
    );
  }

  /// `Please select time slot!`
  String get pleasse_select_time_slot {
    return Intl.message(
      'Please select time slot!',
      name: 'pleasse_select_time_slot',
      desc: '',
      args: [],
    );
  }

  /// `Sign in failed!`
  String get sign_in_failed {
    return Intl.message(
      'Sign in failed!',
      name: 'sign_in_failed',
      desc: '',
      args: [],
    );
  }

  /// `Sign in cancelled by user!`
  String get sign_in_cancelledbyuser {
    return Intl.message(
      'Sign in cancelled by user!',
      name: 'sign_in_cancelledbyuser',
      desc: '',
      args: [],
    );
  }

  /// `Apple SignIn is not available for your device!`
  String get apple_signin_not_available_forthis_device {
    return Intl.message(
      'Apple SignIn is not available for your device!',
      name: 'apple_signin_not_available_forthis_device',
      desc: '',
      args: [],
    );
  }

  /// `Email id already exists!!!`
  String get email_exist {
    return Intl.message(
      'Email id already exists!!!',
      name: 'email_exist',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a list name.`
  String get please_enter_list_name {
    return Intl.message(
      'Please enter a list name.',
      name: 'please_enter_list_name',
      desc: '',
      args: [],
    );
  }

  /// `Shopping list name`
  String get shopping_list_name {
    return Intl.message(
      'Shopping list name',
      name: 'shopping_list_name',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Any request? We promise to pass it on`
  String get any_request {
    return Intl.message(
      'Any request? We promise to pass it on',
      name: 'any_request',
      desc: '',
      args: [],
    );
  }

  /// ` and`
  String get and {
    return Intl.message(
      ' and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number already exists!!!`
  String get mobile_exists {
    return Intl.message(
      'Mobile number already exists!!!',
      name: 'mobile_exists',
      desc: '',
      args: [],
    );
  }

  /// `Please select atleast one list!`
  String get please_select_atleastonelist {
    return Intl.message(
      'Please select atleast one list!',
      name: 'please_select_atleastonelist',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get email_address {
    return Intl.message(
      'Email address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a email address.`
  String get please_enter_email {
    return Intl.message(
      'Please enter a email address.',
      name: 'please_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `What's your email?`
  String get what_your_email {
    return Intl.message(
      'What\'s your email?',
      name: 'what_your_email',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message(
      'NEXT',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Apply promo code`
  String get apply_promocode {
    return Intl.message(
      'Apply promo code',
      name: 'apply_promocode',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Placing order...`
  String get placing_order {
    return Intl.message(
      'Placing order...',
      name: 'placing_order',
      desc: '',
      args: [],
    );
  }

  /// `currently there are no payment methods available`
  String get currently_no_payment {
    return Intl.message(
      'currently there are no payment methods available',
      name: 'currently_no_payment',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Pay`
  String get proceed_pay {
    return Intl.message(
      'Proceed to Pay',
      name: 'proceed_pay',
      desc: '',
      args: [],
    );
  }

  /// `Payment Options`
  String get payment_option {
    return Intl.message(
      'Payment Options',
      name: 'payment_option',
      desc: '',
      args: [],
    );
  }

  /// `Your order qualifies for a hamper !`
  String get thank_you_shopping {
    return Intl.message(
      'Your order qualifies for a hamper !',
      name: 'thank_you_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Your savings`
  String get your_savings {
    return Intl.message(
      'Your savings',
      name: 'your_savings',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount Payable`
  String get amount_payable {
    return Intl.message(
      'Total Amount Payable',
      name: 'amount_payable',
      desc: '',
      args: [],
    );
  }

  /// `(Incl. of all taxes)`
  String get incl_tax {
    return Intl.message(
      '(Incl. of all taxes)',
      name: 'incl_tax',
      desc: '',
      args: [],
    );
  }

  /// `Your Cart Value`
  String get your_cart_value {
    return Intl.message(
      'Your Cart Value',
      name: 'your_cart_value',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charges`
  String get payment_delivery_charge {
    return Intl.message(
      'Delivery Charges',
      name: 'payment_delivery_charge',
      desc: '',
      args: [],
    );
  }

  /// `Discount applied`
  String get discount_applied {
    return Intl.message(
      'Discount applied',
      name: 'discount_applied',
      desc: '',
      args: [],
    );
  }

  /// `Membership savings:`
  String get membership_savings {
    return Intl.message(
      'Membership savings:',
      name: 'membership_savings',
      desc: '',
      args: [],
    );
  }

  /// `Promo (`
  String get promo {
    return Intl.message(
      'Promo (',
      name: 'promo',
      desc: '',
      args: [],
    );
  }

  /// `You Saved (`
  String get you_saved {
    return Intl.message(
      'You Saved (',
      name: 'you_saved',
      desc: '',
      args: [],
    );
  }

  /// `Coins`
  String get coins {
    return Intl.message(
      'Coins',
      name: 'coins',
      desc: '',
      args: [],
    );
  }

  /// `Out Of Stock`
  String get out_of_stock {
    return Intl.message(
      'Out Of Stock',
      name: 'out_of_stock',
      desc: '',
      args: [],
    );
  }

  /// `Pay Using Saving Coins`
  String get pay_using_supercoin {
    return Intl.message(
      'Pay Using Saving Coins',
      name: 'pay_using_supercoin',
      desc: '',
      args: [],
    );
  }

  /// `Balance:  `
  String get balance {
    return Intl.message(
      'Balance:  ',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Minimum order amount should be `
  String get minimum_order_amount {
    return Intl.message(
      'Minimum order amount should be ',
      name: 'minimum_order_amount',
      desc: '',
      args: [],
    );
  }

  /// `Our delivery personnel will carry a swipe machine & orders can be paid via Debit/Credit card at the time of delivery.`
  String get our_delivery_personnel {
    return Intl.message(
      'Our delivery personnel will carry a swipe machine & orders can be paid via Debit/Credit card at the time of delivery.',
      name: 'our_delivery_personnel',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Tip: To ensure a contactless delivery, we recommend you use an online payment method.`
  String get tips_to_ensure {
    return Intl.message(
      'Tip: To ensure a contactless delivery, we recommend you use an online payment method.',
      name: 'tips_to_ensure',
      desc: '',
      args: [],
    );
  }

  /// `Currently there is no payment methods`
  String get no_payment {
    return Intl.message(
      'Currently there is no payment methods',
      name: 'no_payment',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Promocode!!!`
  String get please_enter_valid_promo {
    return Intl.message(
      'Please enter a valid Promocode!!!',
      name: 'please_enter_valid_promo',
      desc: '',
      args: [],
    );
  }

  /// `Please select a payment method!!!`
  String get please_select_paymentmenthods {
    return Intl.message(
      'Please select a payment method!!!',
      name: 'please_select_paymentmenthods',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message(
      'Unavailable',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you can't add more of this item!`
  String get cant_add_more_item {
    return Intl.message(
      'Sorry, you can\'t add more of this item!',
      name: 'cant_add_more_item',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, Out of Stock!`
  String get sorry_outofstock {
    return Intl.message(
      'Sorry, Out of Stock!',
      name: 'sorry_outofstock',
      desc: '',
      args: [],
    );
  }

  /// `There is no transaction`
  String get no_transaction {
    return Intl.message(
      'There is no transaction',
      name: 'no_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Total Balance:`
  String get total_balance {
    return Intl.message(
      'Total Balance:',
      name: 'total_balance',
      desc: '',
      args: [],
    );
  }

  /// `Total Points:`
  String get total_points {
    return Intl.message(
      'Total Points:',
      name: 'total_points',
      desc: '',
      args: [],
    );
  }

  /// `CHECK YOUR ORDER`
  String get check_order {
    return Intl.message(
      'CHECK YOUR ORDER',
      name: 'check_order',
      desc: '',
      args: [],
    );
  }

  /// `Thank You for Choosing `
  String get thank_choosing {
    return Intl.message(
      'Thank You for Choosing ',
      name: 'thank_choosing',
      desc: '',
      args: [],
    );
  }

  /// `Order Placed Successfully!`
  String get order_place_success {
    return Intl.message(
      'Order Placed Successfully!',
      name: 'order_place_success',
      desc: '',
      args: [],
    );
  }

  /// `Your order is being processed by our delivery team and you should receive a confirmation from us shortly!`
  String get order_being_processed {
    return Intl.message(
      'Your order is being processed by our delivery team and you should receive a confirmation from us shortly!',
      name: 'order_being_processed',
      desc: '',
      args: [],
    );
  }

  /// `Order Cancelled!`
  String get order_cancel {
    return Intl.message(
      'Order Cancelled!',
      name: 'order_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmation`
  String get order_confirmation {
    return Intl.message(
      'Order Confirmation',
      name: 'order_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Grocery Shopping Experiance`
  String get grocery_experience {
    return Intl.message(
      'Grocery Shopping Experiance',
      name: 'grocery_experience',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Your shopping list is empty`
  String get shopping_list_empty {
    return Intl.message(
      'Your shopping list is empty',
      name: 'shopping_list_empty',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Lists`
  String get shopping_lists {
    return Intl.message(
      'Shopping Lists',
      name: 'shopping_lists',
      desc: '',
      args: [],
    );
  }

  /// `Add items to continue shopping`
  String get add_item_shopping {
    return Intl.message(
      'Add items to continue shopping',
      name: 'add_item_shopping',
      desc: '',
      args: [],
    );
  }

  /// `snap error . . . . ..`
  String get snap_error {
    return Intl.message(
      'snap error . . . . ..',
      name: 'snap_error',
      desc: '',
      args: [],
    );
  }

  /// `Saved:`
  String get saved {
    return Intl.message(
      'Saved:',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Removing List...`
  String get removing_list {
    return Intl.message(
      'Removing List...',
      name: 'removing_list',
      desc: '',
      args: [],
    );
  }

  /// `Please select any one option`
  String get please_select_any_option {
    return Intl.message(
      'Please select any one option',
      name: 'please_select_any_option',
      desc: '',
      args: [],
    );
  }

  /// `You will be notified via SMS/Push notification, when the product is available`
  String get you_will_notify {
    return Intl.message(
      'You will be notified via SMS/Push notification, when the product is available',
      name: 'you_will_notify',
      desc: '',
      args: [],
    );
  }

  /// `Loading..`
  String get loading {
    return Intl.message(
      'Loading..',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Location...' key

  /// `Choose from over 1000+ items ranging from Farm Fresh Veggies to Imported Fruits and avail attractive discounts on the same.`
  String get choose_over {
    return Intl.message(
      'Choose from over 1000+ items ranging from Farm Fresh Veggies to Imported Fruits and avail attractive discounts on the same.',
      name: 'choose_over',
      desc: '',
      args: [],
    );
  }

  /// `#NoMoreKhitPit`
  String get no_more_kit_pit {
    return Intl.message(
      '#NoMoreKhitPit',
      name: 'no_more_kit_pit',
      desc: '',
      args: [],
    );
  }

  /// `No More Khit-pit`
  String get no_more_kitpit {
    return Intl.message(
      'No More Khit-pit',
      name: 'no_more_kitpit',
      desc: '',
      args: [],
    );
  }

  /// `Shop from the comforts of your home and avoid Congested & Muddy markets, Improper Weighment & Packing, Traffic & Parking Problem aur Daily ka Khit-pit.`
  String get shop_form_comforts {
    return Intl.message(
      'Shop from the comforts of your home and avoid Congested & Muddy markets, Improper Weighment & Packing, Traffic & Parking Problem aur Daily ka Khit-pit.',
      name: 'shop_form_comforts',
      desc: '',
      args: [],
    );
  }

  /// `#GharBaiteOrderKaro`
  String get ghar_baite_order {
    return Intl.message(
      '#GharBaiteOrderKaro',
      name: 'ghar_baite_order',
      desc: '',
      args: [],
    );
  }

  /// `Need Help? We are here.`
  String get need_help_we_are_here {
    return Intl.message(
      'Need Help? We are here.',
      name: 'need_help_we_are_here',
      desc: '',
      args: [],
    );
  }

  /// `Signup with `
  String get signup_with_grocbay {
    return Intl.message(
      'Signup with ',
      name: 'signup_with_grocbay',
      desc: '',
      args: [],
    );
  }

  /// ` today`
  String get today {
    return Intl.message(
      ' today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Our experts are here to help you with your order. Your feedback and experience is of utmost importance to our team.`
  String get our_experts {
    return Intl.message(
      'Our experts are here to help you with your order. Your feedback and experience is of utmost importance to our team.',
      name: 'our_experts',
      desc: '',
      args: [],
    );
  }

  /// `#HeretoHelp`
  String get here_to_help {
    return Intl.message(
      '#HeretoHelp',
      name: 'here_to_help',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get intro_skip {
    return Intl.message(
      'Skip',
      name: 'intro_skip',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `New Update Available`
  String get new_update {
    return Intl.message(
      'New Update Available',
      name: 'new_update',
      desc: '',
      args: [],
    );
  }

  /// `There is a newer version of app available please update it now.`
  String get there_is_newer_version {
    return Intl.message(
      'There is a newer version of app available please update it now.',
      name: 'there_is_newer_version',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get update_now {
    return Intl.message(
      'Update Now',
      name: 'update_now',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message(
      'Later',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Let's first check that we deliver to your address`
  String get lets_check {
    return Intl.message(
      'Let\'s first check that we deliver to your address',
      name: 'lets_check',
      desc: '',
      args: [],
    );
  }

  /// `Ready to order from our shop?`
  String get ready_to_order {
    return Intl.message(
      'Ready to order from our shop?',
      name: 'ready_to_order',
      desc: '',
      args: [],
    );
  }

  /// `SET DELIVERY LOCATION`
  String get set_delivery_location {
    return Intl.message(
      'SET DELIVERY LOCATION',
      name: 'set_delivery_location',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mobile number`
  String get please_enter_your_mobile {
    return Intl.message(
      'Please enter your mobile number',
      name: 'please_enter_your_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Signup`
  String get signup {
    return Intl.message(
      'Signup',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid mobile number`
  String get valid_phone_number {
    return Intl.message(
      'Please enter valid mobile number',
      name: 'valid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Apply referral Code`
  String get apply_referal_code {
    return Intl.message(
      'Apply referral Code',
      name: 'apply_referal_code',
      desc: '',
      args: [],
    );
  }

  /// `Download Our App`
  String get download_app {
    return Intl.message(
      'Download Our App',
      name: 'download_app',
      desc: '',
      args: [],
    );
  }

  /// `Copyright ©2021 All rights reserved |`
  String get copyright {
    return Intl.message(
      'Copyright ©2021 All rights reserved |',
      name: 'copyright',
      desc: '',
      args: [],
    );
  }

  /// `Could not open the map.`
  String get could_not_open_app {
    return Intl.message(
      'Could not open the map.',
      name: 'could_not_open_app',
      desc: '',
      args: [],
    );
  }

  /// `We'll call or text you to confirm your number.`
  String get we_will_call_text_signup {
    return Intl.message(
      'We\'ll call or text you to confirm your number.',
      name: 'we_will_call_text_signup',
      desc: '',
      args: [],
    );
  }

  /// `Creating List...`
  String get creating_list {
    return Intl.message(
      'Creating List...',
      name: 'creating_list',
      desc: '',
      args: [],
    );
  }

  /// `Select Option`
  String get select_option {
    return Intl.message(
      'Select Option',
      name: 'select_option',
      desc: '',
      args: [],
    );
  }

  /// `All Product`
  String get all_product {
    return Intl.message(
      'All Product',
      name: 'all_product',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to return or exchange`
  String get do_you_want_return_exchange {
    return Intl.message(
      'Do you want to return or exchange',
      name: 'do_you_want_return_exchange',
      desc: '',
      args: [],
    );
  }

  /// `Exchange`
  String get exchange {
    return Intl.message(
      'Exchange',
      name: 'exchange',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Slot`
  String get delivery_slot {
    return Intl.message(
      'Delivery Slot',
      name: 'delivery_slot',
      desc: '',
      args: [],
    );
  }

  /// `Order placed on `
  String get ordered_on {
    return Intl.message(
      'Order placed on ',
      name: 'ordered_on',
      desc: '',
      args: [],
    );
  }

  /// `Payment Details`
  String get payment_details {
    return Intl.message(
      'Payment Details',
      name: 'payment_details',
      desc: '',
      args: [],
    );
  }

  /// `Ordered Id`
  String get ordered_ID {
    return Intl.message(
      'Ordered Id',
      name: 'ordered_ID',
      desc: '',
      args: [],
    );
  }

  /// `Invoice No`
  String get invoice_no {
    return Intl.message(
      'Invoice No',
      name: 'invoice_no',
      desc: '',
      args: [],
    );
  }

  /// `Ordered Items`
  String get ordered_items {
    return Intl.message(
      'Ordered Items',
      name: 'ordered_items',
      desc: '',
      args: [],
    );
  }

  /// `FREE`
  String get free {
    return Intl.message(
      'FREE',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Discount Applied (loyalty)`
  String get discount_applied_order {
    return Intl.message(
      'Discount Applied (loyalty)',
      name: 'discount_applied_order',
      desc: '',
      args: [],
    );
  }

  /// `Item Details`
  String get item_details {
    return Intl.message(
      'Item Details',
      name: 'item_details',
      desc: '',
      args: [],
    );
  }

  /// `Return or Exchange`
  String get return_exchange {
    return Intl.message(
      'Return or Exchange',
      name: 'return_exchange',
      desc: '',
      args: [],
    );
  }

  /// `REPEAT ORDER`
  String get repeat_order {
    return Intl.message(
      'REPEAT ORDER',
      name: 'repeat_order',
      desc: '',
      args: [],
    );
  }

  /// `Orders Details`
  String get order_details {
    return Intl.message(
      'Orders Details',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `Enjoying`
  String get enjoying {
    return Intl.message(
      'Enjoying',
      name: 'enjoying',
      desc: '',
      args: [],
    );
  }

  /// `No, Thanks`
  String get no_thanks {
    return Intl.message(
      'No, Thanks',
      name: 'no_thanks',
      desc: '',
      args: [],
    );
  }

  /// `Qty:`
  String get qty {
    return Intl.message(
      'Qty:',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Price:`
  String get price {
    return Intl.message(
      'Price:',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `If you enjoy using `
  String get if_enjoying {
    return Intl.message(
      'If you enjoy using ',
      name: 'if_enjoying',
      desc: '',
      args: [],
    );
  }

  /// `app, would you mind rating us on App Store then?`
  String get wouldyou_mind_rating_appstore {
    return Intl.message(
      'app, would you mind rating us on App Store then?',
      name: 'wouldyou_mind_rating_appstore',
      desc: '',
      args: [],
    );
  }

  /// `app, would you mind rating us on Play Store then?`
  String get wouldyou_mind_rating_playstore {
    return Intl.message(
      'app, would you mind rating us on Play Store then?',
      name: 'wouldyou_mind_rating_playstore',
      desc: '',
      args: [],
    );
  }

  /// `Rate Us`
  String get rate_us {
    return Intl.message(
      'Rate Us',
      name: 'rate_us',
      desc: '',
      args: [],
    );
  }

  /// `Location unavailable`
  String get location_unavailable {
    return Intl.message(
      'Location unavailable',
      name: 'location_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Please enable the location from device settings.`
  String get location_enable {
    return Intl.message(
      'Please enable the location from device settings.',
      name: 'location_enable',
      desc: '',
      args: [],
    );
  }

  /// ` is not yet available at you current location!!!`
  String get not_yet_available {
    return Intl.message(
      ' is not yet available at you current location!!!',
      name: 'not_yet_available',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get map_cancel {
    return Intl.message(
      'CANCEL',
      name: 'map_cancel',
      desc: '',
      args: [],
    );
  }

  /// `home`
  String get markerID {
    return Intl.message(
      'home',
      name: 'markerID',
      desc: '',
      args: [],
    );
  }

  /// `Your Products will be delivered here`
  String get product_delivered_here {
    return Intl.message(
      'Your Products will be delivered here',
      name: 'product_delivered_here',
      desc: '',
      args: [],
    );
  }

  /// `SUBMIT`
  String get submit {
    return Intl.message(
      'SUBMIT',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `more items`
  String get more_items {
    return Intl.message(
      'more items',
      name: 'more_items',
      desc: '',
      args: [],
    );
  }

  /// `Reasons (Optional)`
  String get reason_optionla {
    return Intl.message(
      'Reasons (Optional)',
      name: 'reason_optionla',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get saving {
    return Intl.message(
      'Saving...',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `House /Flat /Block No.`
  String get house_flat_no {
    return Intl.message(
      'House /Flat /Block No.',
      name: 'house_flat_no',
      desc: '',
      args: [],
    );
  }

  /// `Please enter House no`
  String get please_enter_houseno {
    return Intl.message(
      'Please enter House no',
      name: 'please_enter_houseno',
      desc: '',
      args: [],
    );
  }

  /// `Save this address as`
  String get save_as {
    return Intl.message(
      'Save this address as',
      name: 'save_as',
      desc: '',
      args: [],
    );
  }

  /// `Work`
  String get work {
    return Intl.message(
      'Work',
      name: 'work',
      desc: '',
      args: [],
    );
  }

  /// `Office`
  String get office {
    return Intl.message(
      'Office',
      name: 'office',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Save & Proceed`
  String get save_proceed {
    return Intl.message(
      'Save & Proceed',
      name: 'save_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Enter Address`
  String get enter_address {
    return Intl.message(
      'Enter Address',
      name: 'enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Locate me`
  String get locate_me {
    return Intl.message(
      'Locate me',
      name: 'locate_me',
      desc: '',
      args: [],
    );
  }

  /// `PLACE ORDER`
  String get place_order {
    return Intl.message(
      'PLACE ORDER',
      name: 'place_order',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `provide image`
  String get provide_image {
    return Intl.message(
      'provide image',
      name: 'provide_image',
      desc: '',
      args: [],
    );
  }

  /// `Successfully submitted`
  String get success_submit {
    return Intl.message(
      'Successfully submitted',
      name: 'success_submit',
      desc: '',
      args: [],
    );
  }

  /// `Uploading.......`
  String get uploading {
    return Intl.message(
      'Uploading.......',
      name: 'uploading',
      desc: '',
      args: [],
    );
  }

  /// ` to call you further details?`
  String get call_further_details {
    return Intl.message(
      ' to call you further details?',
      name: 'call_further_details',
      desc: '',
      args: [],
    );
  }

  /// `Do you want `
  String get do_you_want {
    return Intl.message(
      'Do you want ',
      name: 'do_you_want',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address?`
  String get are_sure_delete {
    return Intl.message(
      'Are you sure you want to delete this address?',
      name: 'are_sure_delete',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get yes {
    return Intl.message(
      'YES',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `NO`
  String get no {
    return Intl.message(
      'NO',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Deleting...`
  String get deleting {
    return Intl.message(
      'Deleting...',
      name: 'deleting',
      desc: '',
      args: [],
    );
  }

  /// `Save addresses to make home delivery more convenient.`
  String get save_address_convenient {
    return Intl.message(
      'Save addresses to make home delivery more convenient.',
      name: 'save_address_convenient',
      desc: '',
      args: [],
    );
  }

  /// `Search Products`
  String get search_product {
    return Intl.message(
      'Search Products',
      name: 'search_product',
      desc: '',
      args: [],
    );
  }

  /// `Type to search products`
  String get type_to_search_product {
    return Intl.message(
      'Type to search products',
      name: 'type_to_search_product',
      desc: '',
      args: [],
    );
  }

  /// `Search for the products...`
  String get search_for_product {
    return Intl.message(
      'Search for the products...',
      name: 'search_for_product',
      desc: '',
      args: [],
    );
  }

  /// `Plan:`
  String get plan {
    return Intl.message(
      'Plan:',
      name: 'plan',
      desc: '',
      args: [],
    );
  }

  /// `Renewal and Next Payment`
  String get renewal_payment {
    return Intl.message(
      'Renewal and Next Payment',
      name: 'renewal_payment',
      desc: '',
      args: [],
    );
  }

  /// `Your membership will expire on `
  String get membership_expire {
    return Intl.message(
      'Your membership will expire on ',
      name: 'membership_expire',
      desc: '',
      args: [],
    );
  }

  /// `. You will be informed via email or SMS and can renew only after expiry.`
  String get inform_via_sms {
    return Intl.message(
      '. You will be informed via email or SMS and can renew only after expiry.',
      name: 'inform_via_sms',
      desc: '',
      args: [],
    );
  }

  /// `Select the membership plan which suits your needs`
  String get select_membership {
    return Intl.message(
      'Select the membership plan which suits your needs',
      name: 'select_membership',
      desc: '',
      args: [],
    );
  }

  /// ` month`
  String get membership_month {
    return Intl.message(
      ' month',
      name: 'membership_month',
      desc: '',
      args: [],
    );
  }

  /// `Your order with Membership is processing!`
  String get membership_processing {
    return Intl.message(
      'Your order with Membership is processing!',
      name: 'membership_processing',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Payment?`
  String get cancel_payment {
    return Intl.message(
      'Cancel Payment?',
      name: 'cancel_payment',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get paytm_yes {
    return Intl.message(
      'Yes',
      name: 'paytm_yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get paytm_no {
    return Intl.message(
      'No',
      name: 'paytm_no',
      desc: '',
      args: [],
    );
  }

  /// `Choose a pickup address`
  String get choose_pickup_address {
    return Intl.message(
      'Choose a pickup address',
      name: 'choose_pickup_address',
      desc: '',
      args: [],
    );
  }

  /// `Processing...`
  String get processing {
    return Intl.message(
      'Processing...',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Choose Items to `
  String get choose_item_to {
    return Intl.message(
      'Choose Items to ',
      name: 'choose_item_to',
      desc: '',
      args: [],
    );
  }

  /// `Why are you returning this?`
  String get why_returning {
    return Intl.message(
      'Why are you returning this?',
      name: 'why_returning',
      desc: '',
      args: [],
    );
  }

  /// `Quality not adequate`
  String get quantity_adequate {
    return Intl.message(
      'Quality not adequate',
      name: 'quantity_adequate',
      desc: '',
      args: [],
    );
  }

  /// `Quality not adequate`
  String get qty_not_adequate {
    return Intl.message(
      'Quality not adequate',
      name: 'qty_not_adequate',
      desc: '',
      args: [],
    );
  }

  /// `Wrong item was sent`
  String get wrong_item_sent {
    return Intl.message(
      'Wrong item was sent',
      name: 'wrong_item_sent',
      desc: '',
      args: [],
    );
  }

  /// `Item defective`
  String get item_defective {
    return Intl.message(
      'Item defective',
      name: 'item_defective',
      desc: '',
      args: [],
    );
  }

  /// `Product damaged`
  String get product_damaged {
    return Intl.message(
      'Product damaged',
      name: 'product_damaged',
      desc: '',
      args: [],
    );
  }

  /// `Pickup address`
  String get pickup_address {
    return Intl.message(
      'Pickup address',
      name: 'pickup_address',
      desc: '',
      args: [],
    );
  }

  /// `Choose date`
  String get choose_date {
    return Intl.message(
      'Choose date',
      name: 'choose_date',
      desc: '',
      args: [],
    );
  }

  /// `PROCEED`
  String get proceed {
    return Intl.message(
      'PROCEED',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `option expired for this product`
  String get option_expired {
    return Intl.message(
      'option expired for this product',
      name: 'option_expired',
      desc: '',
      args: [],
    );
  }

  /// `Please select the item!!!`
  String get please_select_item {
    return Intl.message(
      'Please select the item!!!',
      name: 'please_select_item',
      desc: '',
      args: [],
    );
  }

  /// `Any store request? We will try our best to co-operate`
  String get any_store_request {
    return Intl.message(
      'Any store request? We will try our best to co-operate',
      name: 'any_store_request',
      desc: '',
      args: [],
    );
  }

  /// `No active subscription yet`
  String get no_active_subscription_yet {
    return Intl.message(
      'No active subscription yet',
      name: 'no_active_subscription_yet',
      desc: '',
      args: [],
    );
  }

  /// `Start a subscription now to get grocery deliveries to your doorstep.`
  String get start_subscription_doorstep {
    return Intl.message(
      'Start a subscription now to get grocery deliveries to your doorstep.',
      name: 'start_subscription_doorstep',
      desc: '',
      args: [],
    );
  }

  /// `Start Subscription`
  String get start_subscription {
    return Intl.message(
      'Start Subscription',
      name: 'start_subscription',
      desc: '',
      args: [],
    );
  }

  /// `View Subscription Details`
  String get view_subscription_detail {
    return Intl.message(
      'View Subscription Details',
      name: 'view_subscription_detail',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this Subscription?`
  String get are_you_want_delete_subscription {
    return Intl.message(
      'Are you sure you want to delete this Subscription?',
      name: 'are_you_want_delete_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Subscription: `
  String get subscription {
    return Intl.message(
      'Subscription: ',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get subscription_delete {
    return Intl.message(
      'Delete',
      name: 'subscription_delete',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer Details`
  String get manufacture_details {
    return Intl.message(
      'Manufacturer Details',
      name: 'manufacture_details',
      desc: '',
      args: [],
    );
  }

  /// `from App Store `
  String get from_app_store {
    return Intl.message(
      'from App Store ',
      name: 'from_app_store',
      desc: '',
      args: [],
    );
  }

  /// ` from Google Play Store`
  String get from_google_play_store {
    return Intl.message(
      ' from Google Play Store',
      name: 'from_google_play_store',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Product MRP: `
  String get product_mrp {
    return Intl.message(
      'Product MRP: ',
      name: 'product_mrp',
      desc: '',
      args: [],
    );
  }

  /// `Selling Price: `
  String get selling_price {
    return Intl.message(
      'Selling Price: ',
      name: 'selling_price',
      desc: '',
      args: [],
    );
  }

  /// `(Inclusive of all taxes)`
  String get inclusive_of_all_tax {
    return Intl.message(
      '(Inclusive of all taxes)',
      name: 'inclusive_of_all_tax',
      desc: '',
      args: [],
    );
  }

  /// `Unlock`
  String get unlock {
    return Intl.message(
      'Unlock',
      name: 'unlock',
      desc: '',
      args: [],
    );
  }

  /// `Select your quantity`
  String get select_your_quantity {
    return Intl.message(
      'Select your quantity',
      name: 'select_your_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Add item to list...`
  String get add_item_to_list {
    return Intl.message(
      'Add item to list...',
      name: 'add_item_to_list',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total: `
  String get grand_total {
    return Intl.message(
      'Grand Total: ',
      name: 'grand_total',
      desc: '',
      args: [],
    );
  }

  /// `Add to`
  String get add_to {
    return Intl.message(
      'Add to',
      name: 'add_to',
      desc: '',
      args: [],
    );
  }

  /// ` Subscription Wallet`
  String get subscription_wallet {
    return Intl.message(
      ' Subscription Wallet',
      name: 'subscription_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Payment`
  String get subscription_payment_option {
    return Intl.message(
      'Subscription Payment',
      name: 'subscription_payment_option',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription value`
  String get your_subscription_value {
    return Intl.message(
      'Your subscription value',
      name: 'your_subscription_value',
      desc: '',
      args: [],
    );
  }

  /// `Online Payment`
  String get online_payment {
    return Intl.message(
      'Online Payment',
      name: 'online_payment',
      desc: '',
      args: [],
    );
  }

  /// `You cannot add more than 5 dates!!`
  String get you_cannot_add_more_than_5_dates {
    return Intl.message(
      'You cannot add more than 5 dates!!',
      name: 'you_cannot_add_more_than_5_dates',
      desc: '',
      args: [],
    );
  }

  /// `Select Delivery Days`
  String get select_delivery_dates {
    return Intl.message(
      'Select Delivery Days',
      name: 'select_delivery_dates',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Start Date`
  String get subscription_starts_date {
    return Intl.message(
      'Subscription Start Date',
      name: 'subscription_starts_date',
      desc: '',
      args: [],
    );
  }

  /// `Choose Days`
  String get choose_days {
    return Intl.message(
      'Choose Days',
      name: 'choose_days',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Weekdays`
  String get weekdays {
    return Intl.message(
      'Weekdays',
      name: 'weekdays',
      desc: '',
      args: [],
    );
  }

  /// `Weekends`
  String get weekends {
    return Intl.message(
      'Weekends',
      name: 'weekends',
      desc: '',
      args: [],
    );
  }

  /// `Please select days`
  String get please_select_days {
    return Intl.message(
      'Please select days',
      name: 'please_select_days',
      desc: '',
      args: [],
    );
  }

  /// `Choose deliveries`
  String get chose_delivery {
    return Intl.message(
      'Choose deliveries',
      name: 'chose_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Deliveries`
  String get deliveries {
    return Intl.message(
      'Deliveries',
      name: 'deliveries',
      desc: '',
      args: [],
    );
  }

  /// `SELECT DELIVERIES`
  String get select_deliveries {
    return Intl.message(
      'SELECT DELIVERIES',
      name: 'select_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Please add delivery address`
  String get please_add_delivery_address {
    return Intl.message(
      'Please add delivery address',
      name: 'please_add_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Please select Repeat type`
  String get please_select_repeat_type {
    return Intl.message(
      'Please select Repeat type',
      name: 'please_select_repeat_type',
      desc: '',
      args: [],
    );
  }

  /// `Quantity per day`
  String get quantity_per_day {
    return Intl.message(
      'Quantity per day',
      name: 'quantity_per_day',
      desc: '',
      args: [],
    );
  }

  /// `Recharge / Top Up`
  String get recharge_or_topup {
    return Intl.message(
      'Recharge / Top Up',
      name: 'recharge_or_topup',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get start_dat {
    return Intl.message(
      'Start Date',
      name: 'start_dat',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get end_date {
    return Intl.message(
      'End Date',
      name: 'end_date',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Confirmation`
  String get subscription_confirmation {
    return Intl.message(
      'Subscription Confirmation',
      name: 'subscription_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `CHECK YOUR SUBSCRIPTION`
  String get check_your_subscription {
    return Intl.message(
      'CHECK YOUR SUBSCRIPTION',
      name: 'check_your_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Your Subscription Successful`
  String get your_subscription_successful {
    return Intl.message(
      'Your Subscription Successful',
      name: 'your_subscription_successful',
      desc: '',
      args: [],
    );
  }

  /// `Your Subscription will start from `
  String get your_subscription_will_start_from {
    return Intl.message(
      'Your Subscription will start from ',
      name: 'your_subscription_will_start_from',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Order Cancelled!`
  String get subscription_canceled {
    return Intl.message(
      'Subscription Order Cancelled!',
      name: 'subscription_canceled',
      desc: '',
      args: [],
    );
  }

  /// `Coming soon...`
  String get coming_soon {
    return Intl.message(
      'Coming soon...',
      name: 'coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Wallet Screen`
  String get subscription_wallet_screen {
    return Intl.message(
      'Subscription Wallet Screen',
      name: 'subscription_wallet_screen',
      desc: '',
      args: [],
    );
  }

  /// `Reserved Balance`
  String get reserved_balance {
    return Intl.message(
      'Reserved Balance',
      name: 'reserved_balance',
      desc: '',
      args: [],
    );
  }

  /// `Add Money`
  String get add_money {
    return Intl.message(
      'Add Money',
      name: 'add_money',
      desc: '',
      args: [],
    );
  }

  /// `1000`
  String get thousand {
    return Intl.message(
      '1000',
      name: 'thousand',
      desc: '',
      args: [],
    );
  }

  /// `2000`
  String get two_thousand {
    return Intl.message(
      '2000',
      name: 'two_thousand',
      desc: '',
      args: [],
    );
  }

  /// `3000`
  String get three_thousand {
    return Intl.message(
      '3000',
      name: 'three_thousand',
      desc: '',
      args: [],
    );
  }

  /// `4000`
  String get four_thousand {
    return Intl.message(
      '4000',
      name: 'four_thousand',
      desc: '',
      args: [],
    );
  }

  /// `Payment Mode`
  String get payment_mode {
    return Intl.message(
      'Payment Mode',
      name: 'payment_mode',
      desc: '',
      args: [],
    );
  }

  /// `Wallet History`
  String get wallet_history {
    return Intl.message(
      'Wallet History',
      name: 'wallet_history',
      desc: '',
      args: [],
    );
  }

  /// `Your recent transactions will show here`
  String get recent_transaction {
    return Intl.message(
      'Your recent transactions will show here',
      name: 'recent_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Please return amount to add`
  String get please_return_amount_add {
    return Intl.message(
      'Please return amount to add',
      name: 'please_return_amount_add',
      desc: '',
      args: [],
    );
  }

  /// `Your wallet amount is less than total amount. Please add sufficient amount`
  String get wallet_amount_less {
    return Intl.message(
      'Your wallet amount is less than total amount. Please add sufficient amount',
      name: 'wallet_amount_less',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment mode`
  String get select_payment_mode {
    return Intl.message(
      'Select Payment mode',
      name: 'select_payment_mode',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `RETURN STATUS`
  String get return_status {
    return Intl.message(
      'RETURN STATUS',
      name: 'return_status',
      desc: '',
      args: [],
    );
  }

  /// `Frequency of deliveries`
  String get repeat {
    return Intl.message(
      'Frequency of deliveries',
      name: 'repeat',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge`
  String get delivery_charge_order {
    return Intl.message(
      'Delivery Charge',
      name: 'delivery_charge_order',
      desc: '',
      args: [],
    );
  }

  /// `Enter Promo Code`
  String get enter_promo {
    return Intl.message(
      'Enter Promo Code',
      name: 'enter_promo',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get total_amount {
    return Intl.message(
      'Total Amount',
      name: 'total_amount',
      desc: '',
      args: [],
    );
  }

  /// `Your total savings`
  String get your_total_saving {
    return Intl.message(
      'Your total savings',
      name: 'your_total_saving',
      desc: '',
      args: [],
    );
  }

  /// `Due Amount`
  String get due_amount {
    return Intl.message(
      'Due Amount',
      name: 'due_amount',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get view_details_order {
    return Intl.message(
      'View Details',
      name: 'view_details_order',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get custom {
    return Intl.message(
      'Custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get Monday {
    return Intl.message(
      'Monday',
      name: 'Monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get Tuesday {
    return Intl.message(
      'Tuesday',
      name: 'Tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get Wednesday {
    return Intl.message(
      'Wednesday',
      name: 'Wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get Thursday {
    return Intl.message(
      'Thursday',
      name: 'Thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get Friday {
    return Intl.message(
      'Friday',
      name: 'Friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get Saturday {
    return Intl.message(
      'Saturday',
      name: 'Saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get Sunday {
    return Intl.message(
      'Sunday',
      name: 'Sunday',
      desc: '',
      args: [],
    );
  }

  /// `mon`
  String get Mon {
    return Intl.message(
      'mon',
      name: 'Mon',
      desc: '',
      args: [],
    );
  }

  /// `tue`
  String get Tue {
    return Intl.message(
      'tue',
      name: 'Tue',
      desc: '',
      args: [],
    );
  }

  /// `wed`
  String get Wed {
    return Intl.message(
      'wed',
      name: 'Wed',
      desc: '',
      args: [],
    );
  }

  /// `thu`
  String get Thu {
    return Intl.message(
      'thu',
      name: 'Thu',
      desc: '',
      args: [],
    );
  }

  /// `fri`
  String get Fri {
    return Intl.message(
      'fri',
      name: 'Fri',
      desc: '',
      args: [],
    );
  }

  /// `sat`
  String get Sat {
    return Intl.message(
      'sat',
      name: 'Sat',
      desc: '',
      args: [],
    );
  }

  /// `sun`
  String get Sun {
    return Intl.message(
      'sun',
      name: 'Sun',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Details`
  String get delivery_details {
    return Intl.message(
      'Delivery Details',
      name: 'delivery_details',
      desc: '',
      args: [],
    );
  }

  /// `Cutoff Time : `
  String get cron_time {
    return Intl.message(
      'Cutoff Time : ',
      name: 'cron_time',
      desc: '',
      args: [],
    );
  }

  /// `Number of Deliveries : `
  String get no_deliveries {
    return Intl.message(
      'Number of Deliveries : ',
      name: 'no_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `1 items`
  String get one_item {
    return Intl.message(
      '1 items',
      name: 'one_item',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Details`
  String get subscription_detail {
    return Intl.message(
      'Subscription Details',
      name: 'subscription_detail',
      desc: '',
      args: [],
    );
  }

  /// `Pause Subscription for 10 Days`
  String get pause_subscription {
    return Intl.message(
      'Pause Subscription for 10 Days',
      name: 'pause_subscription',
      desc: '',
      args: [],
    );
  }

  /// `SubsScription Resumes on`
  String get subscription_resume_on {
    return Intl.message(
      'SubsScription Resumes on',
      name: 'subscription_resume_on',
      desc: '',
      args: [],
    );
  }

  /// `MRP: `
  String get subscribe_mrp {
    return Intl.message(
      'MRP: ',
      name: 'subscribe_mrp',
      desc: '',
      args: [],
    );
  }

  /// `Select Dates`
  String get select_dates {
    return Intl.message(
      'Select Dates',
      name: 'select_dates',
      desc: '',
      args: [],
    );
  }

  /// `From `
  String get from_dates {
    return Intl.message(
      'From ',
      name: 'from_dates',
      desc: '',
      args: [],
    );
  }

  /// `To `
  String get to_date {
    return Intl.message(
      'To ',
      name: 'to_date',
      desc: '',
      args: [],
    );
  }

  /// `No items found!`
  String get no_item_found {
    return Intl.message(
      'No items found!',
      name: 'no_item_found',
      desc: '',
      args: [],
    );
  }

  /// `Order ID`
  String get refund_orderid {
    return Intl.message(
      'Order ID',
      name: 'refund_orderid',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get refund_order_date {
    return Intl.message(
      'Order Date',
      name: 'refund_order_date',
      desc: '',
      args: [],
    );
  }

  /// `Order Amount`
  String get refund_order_amount {
    return Intl.message(
      'Order Amount',
      name: 'refund_order_amount',
      desc: '',
      args: [],
    );
  }

  /// `Short Delivery`
  String get short_delivery {
    return Intl.message(
      'Short Delivery',
      name: 'short_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Total Refund`
  String get total_refund {
    return Intl.message(
      'Total Refund',
      name: 'total_refund',
      desc: '',
      args: [],
    );
  }

  /// `Refund Mode`
  String get refund_mode {
    return Intl.message(
      'Refund Mode',
      name: 'refund_mode',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Refund Amount`
  String get refund_amount {
    return Intl.message(
      'Refund Amount',
      name: 'refund_amount',
      desc: '',
      args: [],
    );
  }

  /// `Refund Details`
  String get refund_details {
    return Intl.message(
      'Refund Details',
      name: 'refund_details',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `Hi `
  String get hi {
    return Intl.message(
      'Hi ',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `Order `
  String get order {
    return Intl.message(
      'Order ',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty earned`
  String get loyalty_earned {
    return Intl.message(
      'Loyalty earned',
      name: 'loyalty_earned',
      desc: '',
      args: [],
    );
  }

  /// `Membership savings`
  String get membership_confirmation {
    return Intl.message(
      'Membership savings',
      name: 'membership_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Promo code discounts`
  String get promo_discount {
    return Intl.message(
      'Promo code discounts',
      name: 'promo_discount',
      desc: '',
      args: [],
    );
  }

  /// `Total Savings`
  String get total_savings {
    return Intl.message(
      'Total Savings',
      name: 'total_savings',
      desc: '',
      args: [],
    );
  }

  /// `Share & Get `
  String get share_get {
    return Intl.message(
      'Share & Get ',
      name: 'share_get',
      desc: '',
      args: [],
    );
  }

  /// `In your wallet!! Invite your friends \n to `
  String get inwallet_invite_friends {
    return Intl.message(
      'In your wallet!! Invite your friends \n to ',
      name: 'inwallet_invite_friends',
      desc: '',
      args: [],
    );
  }

  /// ` with your unique referal code.`
  String get with_unique_referal {
    return Intl.message(
      ' with your unique referal code.',
      name: 'with_unique_referal',
      desc: '',
      args: [],
    );
  }

  /// `Share Now`
  String get share_now {
    return Intl.message(
      'Share Now',
      name: 'share_now',
      desc: '',
      args: [],
    );
  }

  /// `Thank You for \n your order with `
  String get thanks_choosing_confirm {
    return Intl.message(
      'Thank You for \n your order with ',
      name: 'thanks_choosing_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty Coins`
  String get loyalty_coins {
    return Intl.message(
      'Loyalty Coins',
      name: 'loyalty_coins',
      desc: '',
      args: [],
    );
  }

  /// `Choose your preferred language`
  String get Choose_your_preferred_language {
    return Intl.message(
      'Choose your preferred language',
      name: 'Choose_your_preferred_language',
      desc: '',
      args: [],
    );
  }

  /// `Swap Products`
  String get Swap_Products {
    return Intl.message(
      'Swap Products',
      name: 'Swap_Products',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled Delivery`
  String get scheduled_delivery {
    return Intl.message(
      'Scheduled Delivery',
      name: 'scheduled_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Order`
  String get cancel_order {
    return Intl.message(
      'Cancel Order',
      name: 'cancel_order',
      desc: '',
      args: [],
    );
  }

  /// `Rate Order`
  String get rate_order {
    return Intl.message(
      'Rate Order',
      name: 'rate_order',
      desc: '',
      args: [],
    );
  }

  /// `Cash on Delivery`
  String get cash_delivery {
    return Intl.message(
      'Cash on Delivery',
      name: 'cash_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comments {
    return Intl.message(
      'Comment',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Rate your order`
  String get rate_your_order {
    return Intl.message(
      'Rate your order',
      name: 'rate_your_order',
      desc: '',
      args: [],
    );
  }

  /// `That's all!`
  String get thats_all {
    return Intl.message(
      'That\'s all!',
      name: 'thats_all',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get ordering_help {
    return Intl.message(
      'Help',
      name: 'ordering_help',
      desc: '',
      args: [],
    );
  }

  /// `ORDERS & MORE`
  String get order_more {
    return Intl.message(
      'ORDERS & MORE',
      name: 'order_more',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Select Pickup Point`
  String get select_pickup_point {
    return Intl.message(
      'Select Pickup Point',
      name: 'select_pickup_point',
      desc: '',
      args: [],
    );
  }

  /// `Membership saving`
  String get membership_earned {
    return Intl.message(
      'Membership saving',
      name: 'membership_earned',
      desc: '',
      args: [],
    );
  }

  /// `Promo code discount`
  String get promocode_discount {
    return Intl.message(
      'Promo code discount',
      name: 'promocode_discount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up Bonus`
  String get Sign_Up_Bonus {
    return Intl.message(
      'Sign Up Bonus',
      name: 'Sign_Up_Bonus',
      desc: '',
      args: [],
    );
  }

  /// `Added to your wallet`
  String get Added_to_your_wallet {
    return Intl.message(
      'Added to your wallet',
      name: 'Added_to_your_wallet',
      desc: '',
      args: [],
    );
  }

  /// `YAY!`
  String get yay {
    return Intl.message(
      'YAY!',
      name: 'yay',
      desc: '',
      args: [],
    );
  }

  /// `Total Order Amount`
  String get total_order_amount {
    return Intl.message(
      'Total Order Amount',
      name: 'total_order_amount',
      desc: '',
      args: [],
    );
  }

  /// `Order Qty : `
  String get order_qty {
    return Intl.message(
      'Order Qty : ',
      name: 'order_qty',
      desc: '',
      args: [],
    );
  }

  /// `Order Amount `
  String get order_amt {
    return Intl.message(
      'Order Amount ',
      name: 'order_amt',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty Balance `
  String get loyalty_balance {
    return Intl.message(
      'Loyalty Balance ',
      name: 'loyalty_balance',
      desc: '',
      args: [],
    );
  }

  /// `Excellent`
  String get excellent {
    return Intl.message(
      'Excellent',
      name: 'excellent',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get good {
    return Intl.message(
      'Good',
      name: 'good',
      desc: '',
      args: [],
    );
  }

  /// `Average`
  String get average {
    return Intl.message(
      'Average',
      name: 'average',
      desc: '',
      args: [],
    );
  }

  /// `Bad`
  String get bad {
    return Intl.message(
      'Bad',
      name: 'bad',
      desc: '',
      args: [],
    );
  }

  /// `Very Bad`
  String get verybad {
    return Intl.message(
      'Very Bad',
      name: 'verybad',
      desc: '',
      args: [],
    );
  }

  /// `Shop more`
  String get Shop_more {
    return Intl.message(
      'Shop more',
      name: 'Shop_more',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get Shop {
    return Intl.message(
      'Shop',
      name: 'Shop',
      desc: '',
      args: [],
    );
  }

  /// `more to get free delivery`
  String get more_to_get {
    return Intl.message(
      'more to get free delivery',
      name: 'more_to_get',
      desc: '',
      args: [],
    );
  }

  /// `Yay!Free Delivery`
  String get Yay {
    return Intl.message(
      'Yay!Free Delivery',
      name: 'Yay',
      desc: '',
      args: [],
    );
  }

  /// `Your wallet balance is 0`
  String get wallet_toast {
    return Intl.message(
      'Your wallet balance is 0',
      name: 'wallet_toast',
      desc: '',
      args: [],
    );
  }

  /// `Resume`
  String get resume {
    return Intl.message(
      'Resume',
      name: 'resume',
      desc: '',
      args: [],
    );
  }

  /// `Plan Expired`
  String get expired {
    return Intl.message(
      'Plan Expired',
      name: 'expired',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to resume this Subscription?`
  String get resume_subs {
    return Intl.message(
      'Are you sure you want to resume this Subscription?',
      name: 'resume_subs',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failure {
    return Intl.message(
      'Failed',
      name: 'failure',
      desc: '',
      args: [],
    );
  }

  /// `Pause Subscription`
  String get Pause_Subscription {
    return Intl.message(
      'Pause Subscription',
      name: 'Pause_Subscription',
      desc: '',
      args: [],
    );
  }

  /// `All Subscription will be extended on your Order`
  String get All_Subscription {
    return Intl.message(
      'All Subscription will be extended on your Order',
      name: 'All_Subscription',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription has been paused as requested. Tap on Resume to continue the services.`
  String get pauseNote {
    return Intl.message(
      'Your subscription has been paused as requested. Tap on Resume to continue the services.',
      name: 'pauseNote',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Paused`
  String get pauseTitle {
    return Intl.message(
      'Subscription Paused',
      name: 'pauseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Subscription has been resumed`
  String get Resumemsg {
    return Intl.message(
      'Your Subscription has been resumed',
      name: 'Resumemsg',
      desc: '',
      args: [],
    );
  }

  /// `If you are not Add Address yet, Please Add Address`
  String get not_add_address_in {
    return Intl.message(
      'If you are not Add Address yet, Please Add Address',
      name: 'not_add_address_in',
      desc: '',
      args: [],
    );
  }

  /// `Know More`
  String get know_more {
    return Intl.message(
      'Know More',
      name: 'know_more',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty Redemption`
  String get loyalty_redemption {
    return Intl.message(
      'Loyalty Redemption',
      name: 'loyalty_redemption',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get not_available_location {
    return Intl.message(
      'Not Available',
      name: 'not_available_location',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get location_available {
    return Intl.message(
      'Available',
      name: 'location_available',
      desc: '',
      args: [],
    );
  }

  /// `Continue Shopping`
  String get continue_shopping {
    return Intl.message(
      'Continue Shopping',
      name: 'continue_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_small {
    return Intl.message(
      'Login',
      name: 'login_small',
      desc: '',
      args: [],
    );
  }

  /// `Cashback applied`
  String get cash_back {
    return Intl.message(
      'Cashback applied',
      name: 'cash_back',
      desc: '',
      args: [],
    );
  }

  /// `saving with this coupon`
  String get saving_with_this_coupon {
    return Intl.message(
      'saving with this coupon',
      name: 'saving_with_this_coupon',
      desc: '',
      args: [],
    );
  }

  /// `This page doesn’t exist.`
  String get page_not_found {
    return Intl.message(
      'This page doesn’t exist.',
      name: 'page_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you entered a page which doesn’t exist anymore.`
  String get page_anymore {
    return Intl.message(
      'Looks like you entered a page which doesn’t exist anymore.',
      name: 'page_anymore',
      desc: '',
      args: [],
    );
  }

  /// `Let’s take you back to home.`
  String get lets_back_home {
    return Intl.message(
      'Let’s take you back to home.',
      name: 'lets_back_home',
      desc: '',
      args: [],
    );
  }

  /// `Selected Slot is full`
  String get Selected_Slot_full {
    return Intl.message(
      'Selected Slot is full',
      name: 'Selected_Slot_full',
      desc: '',
      args: [],
    );
  }

  /// `Search stores and products`
  String get search_store_prouct {
    return Intl.message(
      'Search stores and products',
      name: 'search_store_prouct',
      desc: '',
      args: [],
    );
  }

  /// `All Shops Nearby`
  String get all_shop_nearby {
    return Intl.message(
      'All Shops Nearby',
      name: 'all_shop_nearby',
      desc: '',
      args: [],
    );
  }

  /// `Select payment method`
  String get select_payment_method {
    return Intl.message(
      'Select payment method',
      name: 'select_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Item Total`
  String get item_total {
    return Intl.message(
      'Item Total',
      name: 'item_total',
      desc: '',
      args: [],
    );
  }

  /// `Any instruction? Eg:Don't ring the door bell`
  String get any_instruct_multivendor {
    return Intl.message(
      'Any instruction? Eg:Don\'t ring the door bell',
      name: 'any_instruct_multivendor',
      desc: '',
      args: [],
    );
  }

  /// `Available Quantities`
  String get available_quantity {
    return Intl.message(
      'Available Quantities',
      name: 'available_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Choose Variant`
  String get choose_variant {
    return Intl.message(
      'Choose Variant',
      name: 'choose_variant',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get delivery_fee {
    return Intl.message(
      'Delivery Fee',
      name: 'delivery_fee',
      desc: '',
      args: [],
    );
  }

  /// `To pay`
  String get to_pay {
    return Intl.message(
      'To pay',
      name: 'to_pay',
      desc: '',
      args: [],
    );
  }

  /// `My Bag`
  String get my_bag {
    return Intl.message(
      'My Bag',
      name: 'my_bag',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get my_profile {
    return Intl.message(
      'My Profile',
      name: 'my_profile',
      desc: '',
      args: [],
    );
  }

  /// `Edit personal info, Change password`
  String get edit_info_prof {
    return Intl.message(
      'Edit personal info, Change password',
      name: 'edit_info_prof',
      desc: '',
      args: [],
    );
  }

  /// `View, Modify & Track orders`
  String get view_ord_prof {
    return Intl.message(
      'View, Modify & Track orders',
      name: 'view_ord_prof',
      desc: '',
      args: [],
    );
  }

  /// `Edit, Add or remove addresses`
  String get edit_add_prof {
    return Intl.message(
      'Edit, Add or remove addresses',
      name: 'edit_add_prof',
      desc: '',
      args: [],
    );
  }

  /// `wallet history`
  String get wallet_history_prof {
    return Intl.message(
      'wallet history',
      name: 'wallet_history_prof',
      desc: '',
      args: [],
    );
  }

  /// `Invite your friends and earn rewards`
  String get invite_prof {
    return Intl.message(
      'Invite your friends and earn rewards',
      name: 'invite_prof',
      desc: '',
      args: [],
    );
  }

  /// `Get in touch with us`
  String get get_in_touch_prof {
    return Intl.message(
      'Get in touch with us',
      name: 'get_in_touch_prof',
      desc: '',
      args: [],
    );
  }

  /// `Login or Signup`
  String get login_prof {
    return Intl.message(
      'Login or Signup',
      name: 'login_prof',
      desc: '',
      args: [],
    );
  }

  /// `subscription wallet`
  String get subscribed_wallet {
    return Intl.message(
      'subscription wallet',
      name: 'subscribed_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Delivered from`
  String get delivery_from {
    return Intl.message(
      'Delivered from',
      name: 'delivery_from',
      desc: '',
      args: [],
    );
  }

  /// `Online Ordering Help`
  String get online_order_help {
    return Intl.message(
      'Online Ordering Help',
      name: 'online_order_help',
      desc: '',
      args: [],
    );
  }

  /// `INVOICE`
  String get invoice {
    return Intl.message(
      'INVOICE',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Truecaller`
  String get signin_truecaller {
    return Intl.message(
      'Sign in with Truecaller',
      name: 'signin_truecaller',
      desc: '',
      args: [],
    );
  }

  /// `Refer & Earn`
  String get refer_and_earn {
    return Intl.message(
      'Refer & Earn',
      name: 'refer_and_earn',
      desc: '',
      args: [],
    );
  }

  /// `SAVE CHANGES`
  String get save_changes {
    return Intl.message(
      'SAVE CHANGES',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Verify Phone`
  String get verify_phone {
    return Intl.message(
      'Verify Phone',
      name: 'verify_phone',
      desc: '',
      args: [],
    );
  }

  /// `Code is sent to`
  String get code_sent {
    return Intl.message(
      'Code is sent to',
      name: 'code_sent',
      desc: '',
      args: [],
    );
  }

  /// `SAVE ADDRESS`
  String get save_address {
    return Intl.message(
      'SAVE ADDRESS',
      name: 'save_address',
      desc: '',
      args: [],
    );
  }

  /// `Express`
  String get express {
    return Intl.message(
      'Express',
      name: 'express',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get trending {
    return Intl.message(
      'Trending',
      name: 'trending',
      desc: '',
      args: [],
    );
  }

  /// `Your Item Value`
  String get your_itemvalue {
    return Intl.message(
      'Your Item Value',
      name: 'your_itemvalue',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get see_all {
    return Intl.message(
      'See All',
      name: 'see_all',
      desc: '',
      args: [],
    );
  }

  /// `Ratings & Reviews`
  String get rating_review {
    return Intl.message(
      'Ratings & Reviews',
      name: 'rating_review',
      desc: '',
      args: [],
    );
  }

  /// `Rate Product`
  String get rate_product {
    return Intl.message(
      'Rate Product',
      name: 'rate_product',
      desc: '',
      args: [],
    );
  }

  /// `Write a Review`
  String get write_review {
    return Intl.message(
      'Write a Review',
      name: 'write_review',
      desc: '',
      args: [],
    );
  }

  /// `All Review`
  String get all_review {
    return Intl.message(
      'All Review',
      name: 'all_review',
      desc: '',
      args: [],
    );
  }

  /// `Product Reviews`
  String get product_review {
    return Intl.message(
      'Product Reviews',
      name: 'product_review',
      desc: '',
      args: [],
    );
  }

  /// `Customer Survey`
  String get customer_survey {
    return Intl.message(
      'Customer Survey',
      name: 'customer_survey',
      desc: '',
      args: [],
    );
  }

  /// `Apply Coupons`
  String get apply_coupon {
    return Intl.message(
      'Apply Coupons',
      name: 'apply_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Survey Product`
  String get survey_product {
    return Intl.message(
      'Survey Product',
      name: 'survey_product',
      desc: '',
      args: [],
    );
  }

  /// `BULK`
  String get bulk {
    return Intl.message(
      'BULK',
      name: 'bulk',
      desc: '',
      args: [],
    );
  }

  /// `Order Quickly with Picture`
  String get order_quick {
    return Intl.message(
      'Order Quickly with Picture',
      name: 'order_quick',
      desc: '',
      args: [],
    );
  }

  /// `SUPPORT`
  String get support {
    return Intl.message(
      'SUPPORT',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Get in touch with us`
  String get get_in_touch {
    return Intl.message(
      'Get in touch with us',
      name: 'get_in_touch',
      desc: '',
      args: [],
    );
  }

  /// `TAKE A PHOTO`
  String get take_photo {
    return Intl.message(
      'TAKE A PHOTO',
      name: 'take_photo',
      desc: '',
      args: [],
    );
  }

  /// `ADD FILE`
  String get add_file {
    return Intl.message(
      'ADD FILE',
      name: 'add_file',
      desc: '',
      args: [],
    );
  }

  /// `Upload file from the local drive`
  String get upload_file {
    return Intl.message(
      'Upload file from the local drive',
      name: 'upload_file',
      desc: '',
      args: [],
    );
  }

  /// `Please remove outofstock/Unavailable items before proceeding`
  String get remove_outofstock {
    return Intl.message(
      'Please remove outofstock/Unavailable items before proceeding',
      name: 'remove_outofstock',
      desc: '',
      args: [],
    );
  }

  /// `Saving gets bigger with Membership`
  String get savings_better {
    return Intl.message(
      'Saving gets bigger with Membership',
      name: 'savings_better',
      desc: '',
      args: [],
    );
  }

  /// `Browse plans starting with`
  String get browse_plan {
    return Intl.message(
      'Browse plans starting with',
      name: 'browse_plan',
      desc: '',
      args: [],
    );
  }

  /// `Extra`
  String get extra_order {
    return Intl.message(
      'Extra',
      name: 'extra_order',
      desc: '',
      args: [],
    );
  }

  /// `Membership Applied!`
  String get membership_applied {
    return Intl.message(
      'Membership Applied!',
      name: 'membership_applied',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clear_all {
    return Intl.message(
      'Clear All',
      name: 'clear_all',
      desc: '',
      args: [],
    );
  }

  /// `Refine by`
  String get refine_by {
    return Intl.message(
      'Refine by',
      name: 'refine_by',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sort_by {
    return Intl.message(
      'Sort by',
      name: 'sort_by',
      desc: '',
      args: [],
    );
  }

  /// `Enter Coupon Code`
  String get enter_couponcode {
    return Intl.message(
      'Enter Coupon Code',
      name: 'enter_couponcode',
      desc: '',
      args: [],
    );
  }

  /// `Available Coupons`
  String get available_coupon {
    return Intl.message(
      'Available Coupons',
      name: 'available_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save_member {
    return Intl.message(
      'Save',
      name: 'save_member',
      desc: '',
      args: [],
    );
  }

  /// `Change Plan`
  String get change_plan {
    return Intl.message(
      'Change Plan',
      name: 'change_plan',
      desc: '',
      args: [],
    );
  }

  /// ` on this order!`
  String get on_order {
    return Intl.message(
      ' on this order!',
      name: 'on_order',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Search for area, street name...`
  String get search_for_area {
    return Intl.message(
      'Search for area, street name...',
      name: 'search_for_area',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get current_location {
    return Intl.message(
      'Current Location',
      name: 'current_location',
      desc: '',
      args: [],
    );
  }

  /// `Using GPS`
  String get using_gps {
    return Intl.message(
      'Using GPS',
      name: 'using_gps',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Location`
  String get confirm_location {
    return Intl.message(
      'Confirm Location',
      name: 'confirm_location',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you haven't added anything to the cart yet.`
  String get looks_like {
    return Intl.message(
      'Looks like you haven\'t added anything to the cart yet.',
      name: 'looks_like',
      desc: '',
      args: [],
    );
  }

  /// `No Product Found`
  String get no_product {
    return Intl.message(
      'No Product Found',
      name: 'no_product',
      desc: '',
      args: [],
    );
  }

  /// `Sorry! we couldn't find that product`
  String get find_item {
    return Intl.message(
      'Sorry! we couldn\'t find that product',
      name: 'find_item',
      desc: '',
      args: [],
    );
  }

  /// `Pick Subscription option`
  String get pick_subscription_option {
    return Intl.message(
      'Pick Subscription option',
      name: 'pick_subscription_option',
      desc: '',
      args: [],
    );
  }

  /// `Regular Subscription`
  String get regular_subscription {
    return Intl.message(
      'Regular Subscription',
      name: 'regular_subscription',
      desc: '',
      args: [],
    );
  }

  /// `*Original price `
  String get original_price {
    return Intl.message(
      '*Original price ',
      name: 'original_price',
      desc: '',
      args: [],
    );
  }

  /// ` per pack`
  String get per_pack {
    return Intl.message(
      ' per pack',
      name: 'per_pack',
      desc: '',
      args: [],
    );
  }

  /// `Membership Savings `
  String get membership_saving {
    return Intl.message(
      'Membership Savings ',
      name: 'membership_saving',
      desc: '',
      args: [],
    );
  }

  /// `Request a Product`
  String get request_a_product {
    return Intl.message(
      'Request a Product',
      name: 'request_a_product',
      desc: '',
      args: [],
    );
  }

  /// `we at`
  String get we_at {
    return Intl.message(
      'we at',
      name: 'we_at',
      desc: '',
      args: [],
    );
  }

  /// `strive to bring you the best assortment, let us know which product we are missing?`
  String get strive_to_bring {
    return Intl.message(
      'strive to bring you the best assortment, let us know which product we are missing?',
      name: 'strive_to_bring',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Type your answer here`
  String get type_your_answer {
    return Intl.message(
      'Type your answer here',
      name: 'type_your_answer',
      desc: '',
      args: [],
    );
  }

  /// `Your suggestion has been sent`
  String get your_suggestion_sent {
    return Intl.message(
      'Your suggestion has been sent',
      name: 'your_suggestion_sent',
      desc: '',
      args: [],
    );
  }

  /// `Order groceries, foods, veggies and more on our `
  String get Order_groceries {
    return Intl.message(
      'Order groceries, foods, veggies and more on our ',
      name: 'Order_groceries',
      desc: '',
      args: [],
    );
  }

  /// ` app`
  String get app {
    return Intl.message(
      ' app',
      name: 'app',
      desc: '',
      args: [],
    );
  }

  /// `Download `
  String get download_now {
    return Intl.message(
      'Download ',
      name: 'download_now',
      desc: '',
      args: [],
    );
  }

  /// ` now`
  String get now {
    return Intl.message(
      ' now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Select a Location`
  String get Selesct_loc {
    return Intl.message(
      'Select a Location',
      name: 'Selesct_loc',
      desc: '',
      args: [],
    );
  }

  /// `SET AS DEFAULT`
  String get set_as_default {
    return Intl.message(
      'SET AS DEFAULT',
      name: 'set_as_default',
      desc: '',
      args: [],
    );
  }

  /// `Building / Flat Name`
  String get building_flat {
    return Intl.message(
      'Building / Flat Name',
      name: 'building_flat',
      desc: '',
      args: [],
    );
  }

  /// `Address 1`
  String get address_one {
    return Intl.message(
      'Address 1',
      name: 'address_one',
      desc: '',
      args: [],
    );
  }

  /// `How to reach (optional)`
  String get how_to_reach {
    return Intl.message(
      'How to reach (optional)',
      name: 'how_to_reach',
      desc: '',
      args: [],
    );
  }

  /// `Choose Current Location`
  String get choose_current_location {
    return Intl.message(
      'Choose Current Location',
      name: 'choose_current_location',
      desc: '',
      args: [],
    );
  }

  /// `You have already taken survey with Free product`
  String get survey_taken {
    return Intl.message(
      'You have already taken survey with Free product',
      name: 'survey_taken',
      desc: '',
      args: [],
    );
  }

  /// `You have already taken survey, add free product to cart`
  String get survey_taken_add {
    return Intl.message(
      'You have already taken survey, add free product to cart',
      name: 'survey_taken_add',
      desc: '',
      args: [],
    );
  }

  /// `You have already selected Free product`
  String get already_selected_free_prodct {
    return Intl.message(
      'You have already selected Free product',
      name: 'already_selected_free_prodct',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get add_product {
    return Intl.message(
      'Add Product',
      name: 'add_product',
      desc: '',
      args: [],
    );
  }

  /// `Please select any answer`
  String get select_answer {
    return Intl.message(
      'Please select any answer',
      name: 'select_answer',
      desc: '',
      args: [],
    );
  }

  /// `No Survey Questions found`
  String get no_question {
    return Intl.message(
      'No Survey Questions found',
      name: 'no_question',
      desc: '',
      args: [],
    );
  }

  /// `Search for an item`
  String get search_for_item {
    return Intl.message(
      'Search for an item',
      name: 'search_for_item',
      desc: '',
      args: [],
    );
  }

  /// `You are eligible for free membership`
  String get eligible_membership {
    return Intl.message(
      'You are eligible for free membership',
      name: 'eligible_membership',
      desc: '',
      args: [],
    );
  }

  /// `Press Again to Exit!`
  String get press_again_exit {
    return Intl.message(
      'Press Again to Exit!',
      name: 'press_again_exit',
      desc: '',
      args: [],
    );
  }

  /// `You have selected Membership of price `
  String get selected_membership {
    return Intl.message(
      'You have selected Membership of price ',
      name: 'selected_membership',
      desc: '',
      args: [],
    );
  }

  /// ` for the duration of `
  String get for_duration {
    return Intl.message(
      ' for the duration of ',
      name: 'for_duration',
      desc: '',
      args: [],
    );
  }

  /// `Download `
  String get download {
    return Intl.message(
      'Download ',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// ` from Google Play Store and use my referral code (`
  String get from_googleplay {
    return Intl.message(
      ' from Google Play Store and use my referral code (',
      name: 'from_googleplay',
      desc: '',
      args: [],
    );
  }

  /// `Page Not Found`
  String get not_found_page {
    return Intl.message(
      'Page Not Found',
      name: 'not_found_page',
      desc: '',
      args: [],
    );
  }

  /// `applied`
  String get applied {
    return Intl.message(
      'applied',
      name: 'applied',
      desc: '',
      args: [],
    );
  }

  /// `savings with this coupon`
  String get saving_coupon {
    return Intl.message(
      'savings with this coupon',
      name: 'saving_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Keep using `
  String get keep_using {
    return Intl.message(
      'Keep using ',
      name: 'keep_using',
      desc: '',
      args: [],
    );
  }

  /// ` and save more with each order`
  String get save_more_order {
    return Intl.message(
      ' and save more with each order',
      name: 'save_more_order',
      desc: '',
      args: [],
    );
  }

  /// `Offer applied on the bill`
  String get offer_applied {
    return Intl.message(
      'Offer applied on the bill',
      name: 'offer_applied',
      desc: '',
      args: [],
    );
  }

  /// `Apply Coupon`
  String get apply_coupon_payment {
    return Intl.message(
      'Apply Coupon',
      name: 'apply_coupon_payment',
      desc: '',
      args: [],
    );
  }

  /// `Not Available Coupons`
  String get not_available_promo {
    return Intl.message(
      'Not Available Coupons',
      name: 'not_available_promo',
      desc: '',
      args: [],
    );
  }

  /// ` ratings & `
  String get rating {
    return Intl.message(
      ' ratings & ',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// ` reviews`
  String get review {
    return Intl.message(
      ' reviews',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Search stores and products`
  String get search_store {
    return Intl.message(
      'Search stores and products',
      name: 'search_store',
      desc: '',
      args: [],
    );
  }

  /// `Top up your daily essentials`
  String get topup_essential {
    return Intl.message(
      'Top up your daily essentials',
      name: 'topup_essential',
      desc: '',
      args: [],
    );
  }

  /// `Trending in your area`
  String get trending_area {
    return Intl.message(
      'Trending in your area',
      name: 'trending_area',
      desc: '',
      args: [],
    );
  }

  /// ` Km`
  String get km {
    return Intl.message(
      ' Km',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// ` Items`
  String get items_shopping {
    return Intl.message(
      ' Items',
      name: 'items_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Owner Name`
  String get owner_name {
    return Intl.message(
      'Owner Name',
      name: 'owner_name',
      desc: '',
      args: [],
    );
  }

  /// `Pincode`
  String get pin_code {
    return Intl.message(
      'Pincode',
      name: 'pin_code',
      desc: '',
      args: [],
    );
  }

  /// `Gst Id`
  String get gst_id {
    return Intl.message(
      'Gst Id',
      name: 'gst_id',
      desc: '',
      args: [],
    );
  }

  /// `Upload document for KYC Verification `
  String get upload_document {
    return Intl.message(
      'Upload document for KYC Verification ',
      name: 'upload_document',
      desc: '',
      args: [],
    );
  }

  /// `(GSTN/PanCard/Udyog/Aadhar Documents)`
  String get gstn {
    return Intl.message(
      '(GSTN/PanCard/Udyog/Aadhar Documents)',
      name: 'gstn',
      desc: '',
      args: [],
    );
  }

  /// `Upload file from the local drive `
  String get upload_file_localdrive {
    return Intl.message(
      'Upload file from the local drive ',
      name: 'upload_file_localdrive',
      desc: '',
      args: [],
    );
  }

  /// `Need Help ? `
  String get need_help {
    return Intl.message(
      'Need Help ? ',
      name: 'need_help',
      desc: '',
      args: [],
    );
  }

  /// ` Call Us`
  String get call_us {
    return Intl.message(
      ' Call Us',
      name: 'call_us',
      desc: '',
      args: [],
    );
  }

  /// `Enter Business Name`
  String get enter_business_name {
    return Intl.message(
      'Enter Business Name',
      name: 'enter_business_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Owner Name`
  String get enter_owner_name {
    return Intl.message(
      'Enter Owner Name',
      name: 'enter_owner_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Pincode`
  String get enter_pincode {
    return Intl.message(
      'Enter Pincode',
      name: 'enter_pincode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Gst No`
  String get enter_gst {
    return Intl.message(
      'Enter Gst No',
      name: 'enter_gst',
      desc: '',
      args: [],
    );
  }

  /// `xyz@gmail.com`
  String get xyz_gmail {
    return Intl.message(
      'xyz@gmail.com',
      name: 'xyz_gmail',
      desc: '',
      args: [],
    );
  }

  /// `ex: Monthly Grocery`
  String get monthly_grocery {
    return Intl.message(
      'ex: Monthly Grocery',
      name: 'monthly_grocery',
      desc: '',
      args: [],
    );
  }

  /// `Nearby Stores`
  String get nearby_shop {
    return Intl.message(
      'Nearby Stores',
      name: 'nearby_shop',
      desc: '',
      args: [],
    );
  }

  /// `M`
  String get m {
    return Intl.message(
      'M',
      name: 'm',
      desc: '',
      args: [],
    );
  }

  /// `T`
  String get t {
    return Intl.message(
      'T',
      name: 't',
      desc: '',
      args: [],
    );
  }

  /// `W`
  String get w {
    return Intl.message(
      'W',
      name: 'w',
      desc: '',
      args: [],
    );
  }

  /// `F`
  String get f {
    return Intl.message(
      'F',
      name: 'f',
      desc: '',
      args: [],
    );
  }

  /// `S`
  String get s {
    return Intl.message(
      'S',
      name: 's',
      desc: '',
      args: [],
    );
  }

  /// ` plan for `
  String get plan_for {
    return Intl.message(
      ' plan for ',
      name: 'plan_for',
      desc: '',
      args: [],
    );
  }

  /// `days at SPECIAL subscription Price of `
  String get days_spl {
    return Intl.message(
      'days at SPECIAL subscription Price of ',
      name: 'days_spl',
      desc: '',
      args: [],
    );
  }

  /// `You are qualified for free Product!`
  String get qualified_free_product {
    return Intl.message(
      'You are qualified for free Product!',
      name: 'qualified_free_product',
      desc: '',
      args: [],
    );
  }

  /// `Pending Deliveries Amount: `
  String get pending_delamount {
    return Intl.message(
      'Pending Deliveries Amount: ',
      name: 'pending_delamount',
      desc: '',
      args: [],
    );
  }

  /// `Failure`
  String get failure_subscription {
    return Intl.message(
      'Failure',
      name: 'failure_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success_subscription {
    return Intl.message(
      'Success',
      name: 'success_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Selected Subscription Plan: `
  String get selected_sub_plan {
    return Intl.message(
      'Selected Subscription Plan: ',
      name: 'selected_sub_plan',
      desc: '',
      args: [],
    );
  }

  /// `You have already taken Survey`
  String get already_taken_survey {
    return Intl.message(
      'You have already taken Survey',
      name: 'already_taken_survey',
      desc: '',
      args: [],
    );
  }

  /// `You have already taken Survey and selected Free product`
  String get survey_free {
    return Intl.message(
      'You have already taken Survey and selected Free product',
      name: 'survey_free',
      desc: '',
      args: [],
    );
  }

  /// `1 Items`
  String get one_product {
    return Intl.message(
      '1 Items',
      name: 'one_product',
      desc: '',
      args: [],
    );
  }

  /// `Free Product`
  String get free_product {
    return Intl.message(
      'Free Product',
      name: 'free_product',
      desc: '',
      args: [],
    );
  }

  /// `Customize`
  String get customise {
    return Intl.message(
      'Customize',
      name: 'customise',
      desc: '',
      args: [],
    );
  }

  /// `ADD ITEMS`
  String get add_items {
    return Intl.message(
      'ADD ITEMS',
      name: 'add_items',
      desc: '',
      args: [],
    );
  }

  /// `Your Previous customization`
  String get previous_customisation {
    return Intl.message(
      'Your Previous customization',
      name: 'previous_customisation',
      desc: '',
      args: [],
    );
  }

  /// `I'LL CHOOSE`
  String get i_will_choose {
    return Intl.message(
      'I\'LL CHOOSE',
      name: 'i_will_choose',
      desc: '',
      args: [],
    );
  }

  /// `REPEAT`
  String get repeat_topppings {
    return Intl.message(
      'REPEAT',
      name: 'repeat_topppings',
      desc: '',
      args: [],
    );
  }

  /// `Remove item from cart`
  String get remove_cart {
    return Intl.message(
      'Remove item from cart',
      name: 'remove_cart',
      desc: '',
      args: [],
    );
  }

  /// `This item has multiple customization added, Proceed to cart to remove item?`
  String get multiple_customization {
    return Intl.message(
      'This item has multiple customization added, Proceed to cart to remove item?',
      name: 'multiple_customization',
      desc: '',
      args: [],
    );
  }

  /// `No Item Found`
  String get no_items_found {
    return Intl.message(
      'No Item Found',
      name: 'no_items_found',
      desc: '',
      args: [],
    );
  }

  /// `Working `
  String get working_from {
    return Intl.message(
      'Working ',
      name: 'working_from',
      desc: '',
      args: [],
    );
  }

  /// `Gst No:`
  String get gst_no {
    return Intl.message(
      'Gst No:',
      name: 'gst_no',
      desc: '',
      args: [],
    );
  }

  /// `Mobile :`
  String get mobile {
    return Intl.message(
      'Mobile :',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Bill to/Ship to:`
  String get bill_to {
    return Intl.message(
      'Bill to/Ship to:',
      name: 'bill_to',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Id:`
  String get invoice_id {
    return Intl.message(
      'Invoice Id:',
      name: 'invoice_id',
      desc: '',
      args: [],
    );
  }

  /// `Email : `
  String get invoice_email {
    return Intl.message(
      'Email : ',
      name: 'invoice_email',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Date :`
  String get delivery_date {
    return Intl.message(
      'Delivery Date :',
      name: 'delivery_date',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Time :`
  String get delivery_time {
    return Intl.message(
      'Delivery Time :',
      name: 'delivery_time',
      desc: '',
      args: [],
    );
  }

  /// `Order Date :`
  String get order_date {
    return Intl.message(
      'Order Date :',
      name: 'order_date',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type : `
  String get payment_type {
    return Intl.message(
      'Payment Type : ',
      name: 'payment_type',
      desc: '',
      args: [],
    );
  }

  /// `You Saved  `
  String get you_saved_invoice {
    return Intl.message(
      'You Saved  ',
      name: 'you_saved_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Payment : `
  String get wallet_payment {
    return Intl.message(
      'Wallet Payment : ',
      name: 'wallet_payment',
      desc: '',
      args: [],
    );
  }

  /// `| Cash/Online Payment : `
  String get cash_payment {
    return Intl.message(
      '| Cash/Online Payment : ',
      name: 'cash_payment',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for ordering with`
  String get thank_for_order {
    return Intl.message(
      'Thank you for ordering with',
      name: 'thank_for_order',
      desc: '',
      args: [],
    );
  }

  /// `Show Less`
  String get show_less {
    return Intl.message(
      'Show Less',
      name: 'show_less',
      desc: '',
      args: [],
    );
  }

  /// `Show More`
  String get show_more {
    return Intl.message(
      'Show More',
      name: 'show_more',
      desc: '',
      args: [],
    );
  }

  /// `Whole Uncut:`
  String get whole_uncut {
    return Intl.message(
      'Whole Uncut:',
      name: 'whole_uncut',
      desc: '',
      args: [],
    );
  }

  /// `500 G`
  String get gram {
    return Intl.message(
      '500 G',
      name: 'gram',
      desc: '',
      args: [],
    );
  }

  /// `G Weight:`
  String get g_weight {
    return Intl.message(
      'G Weight:',
      name: 'g_weight',
      desc: '',
      args: [],
    );
  }

  /// `N Weight:`
  String get n_weight {
    return Intl.message(
      'N Weight:',
      name: 'n_weight',
      desc: '',
      args: [],
    );
  }

  /// `Savings `
  String get savings {
    return Intl.message(
      'Savings ',
      name: 'savings',
      desc: '',
      args: [],
    );
  }

  /// `*Comment`
  String get comment {
    return Intl.message(
      '*Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Please enter comment`
  String get enter_comment {
    return Intl.message(
      'Please enter comment',
      name: 'enter_comment',
      desc: '',
      args: [],
    );
  }

  /// `Review added successfully, it is sent for approval.`
  String get review_added {
    return Intl.message(
      'Review added successfully, it is sent for approval.',
      name: 'review_added',
      desc: '',
      args: [],
    );
  }

  /// ` ratings & `
  String get ratings {
    return Intl.message(
      ' ratings & ',
      name: 'ratings',
      desc: '',
      args: [],
    );
  }

  /// `View all Reviews`
  String get view_review {
    return Intl.message(
      'View all Reviews',
      name: 'view_review',
      desc: '',
      args: [],
    );
  }

  /// `Rate our Product`
  String get rate_our_product {
    return Intl.message(
      'Rate our Product',
      name: 'rate_our_product',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get product_desc {
    return Intl.message(
      'Product Description',
      name: 'product_desc',
      desc: '',
      args: [],
    );
  }

  /// `Important Information`
  String get imp_info {
    return Intl.message(
      'Important Information',
      name: 'imp_info',
      desc: '',
      args: [],
    );
  }

  /// `Gross Weight:`
  String get gross_weight {
    return Intl.message(
      'Gross Weight:',
      name: 'gross_weight',
      desc: '',
      args: [],
    );
  }

  /// `Net Weight:`
  String get net_weight {
    return Intl.message(
      'Net Weight:',
      name: 'net_weight',
      desc: '',
      args: [],
    );
  }

  /// `SUBSCRIBE`
  String get subscribe_caps {
    return Intl.message(
      'SUBSCRIBE',
      name: 'subscribe_caps',
      desc: '',
      args: [],
    );
  }

  /// `BUY GROCBAY MEMBERSHIP`
  String get buy_membership {
    return Intl.message(
      'BUY GROCBAY MEMBERSHIP',
      name: 'buy_membership',
      desc: '',
      args: [],
    );
  }

  /// `Please select any plan`
  String get select_any_plan {
    return Intl.message(
      'Please select any plan',
      name: 'select_any_plan',
      desc: '',
      args: [],
    );
  }

  /// `Select Delivery Location`
  String get set_delivery_locations {
    return Intl.message(
      'Select Delivery Location',
      name: 'set_delivery_locations',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get use {
    return Intl.message(
      'Use',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `  Please enter owner Name`
  String get please_enter_owner_name {
    return Intl.message(
      '  Please enter owner Name',
      name: 'please_enter_owner_name',
      desc: '',
      args: [],
    );
  }

  /// `  Please Pincode`
  String get please_enter_pincode {
    return Intl.message(
      '  Please Pincode',
      name: 'please_enter_pincode',
      desc: '',
      args: [],
    );
  }

  /// `  Please Gst No`
  String get please_enter_gst {
    return Intl.message(
      '  Please Gst No',
      name: 'please_enter_gst',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit_address {
    return Intl.message(
      'Edit',
      name: 'edit_address',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_address {
    return Intl.message(
      'Delete',
      name: 'delete_address',
      desc: '',
      args: [],
    );
  }

  /// `Alternativedays`
  String get alternative {
    return Intl.message(
      'Alternativedays',
      name: 'alternative',
      desc: '',
      args: [],
    );
  }

  /// `Select Menu Preference`
  String get select_menu_pref {
    return Intl.message(
      'Select Menu Preference',
      name: 'select_menu_pref',
      desc: '',
      args: [],
    );
  }

  /// `Please recharge your wallet for uninterrupted services`
  String get please_recharge_wallet {
    return Intl.message(
      'Please recharge your wallet for uninterrupted services',
      name: 'please_recharge_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Subscription Box`
  String get choose_sub_box {
    return Intl.message(
      'Choose Your Subscription Box',
      name: 'choose_sub_box',
      desc: '',
      args: [],
    );
  }

  /// `Top up Wallet to activate Subscription and uninterrupted Delivery`
  String get wallet_message {
    return Intl.message(
      'Top up Wallet to activate Subscription and uninterrupted Delivery',
      name: 'wallet_message',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Orders`
  String get upcoming_order {
    return Intl.message(
      'Upcoming Orders',
      name: 'upcoming_order',
      desc: '',
      args: [],
    );
  }

  /// `Active Subscriptions`
  String get active_subscription {
    return Intl.message(
      'Active Subscriptions',
      name: 'active_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Add Item`
  String get add_item {
    return Intl.message(
      'Add Item',
      name: 'add_item',
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
