import 'package:grocbay/constants/features.dart';

import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';

class Api {
  static String baseURL = IConstants.API_PATH;
  static String getRestaurant = baseURL + 'get-resturant';

  //home page
  static String getHomePage = baseURL + 'v3/get-home-page';

  //Signup and Logins API's
  static String preRegister = baseURL + 'v2/customer/pre-register';
  static String register = baseURL + 'customer/register';
  static String updateMobileNumber = baseURL + 'update-mobile-number';
  static String resendOtp30 = baseURL + 'customer/resend-otp-30';
  static String resendOtpCall = baseURL + 'customer/resend-otp-call';
  static String productNotify = baseURL + 'customer/notify';
  static String getProfile = baseURL + 'customer/get-profile';
  static String updateCustomerProfile = baseURL + 'profile/update-customer-profile';
  static String emailLogin = baseURL + 'customer/email-login';
  static String mobileCheck = baseURL + 'customer/mobile-check';
  static String emailCheck = baseURL + 'customer/email-check';
  static String checkLocation = baseURL + 'check-location';
  static String checkLocationmultivendor = baseURL + 'v3/check-location';
  static String addPrimaryLocation = baseURL + 'add-primary-location';
  static String getNotification = baseURL + 'get-notification/';
  static String getNotificationmultivendor = baseURL + 'get-root-notification/';
  static String updateNotification = baseURL + 'update-notification/';
  static String getMembership = /*(IConstants.isEnterprise && Features.ismultivendor)?*/(baseURL +'v3/get-membership')/*:(baseURL +'get-membership')*/;
  static String getMembershipDetail = baseURL + 'get-membership_detail';
  static String getAdsFifteen = baseURL + 'restaurant/get-ads/15/' ; //Above Main Slider
  static String getAdsOne = baseURL + 'restaurant/get-ads/1/' ; //Main Slider
  static String getFeaturedCategories = baseURL + 'get-language-categories'; //Fetch category one
  // static String getFeaturedCategories = baseURL + 'get-categories/'; //Fetch category one
  static String getAdsTwo = baseURL + 'restaurant/get-ads/2/' ; //Below Featured categories 1
  static String getAdsFive = baseURL + 'restaurant/get-ads/5/' ; //Below featured items 1
  static String getAdsNine = baseURL + 'restaurant/get-ads/9/'; //Below Featured categories 2
  static String getAdsTen = baseURL + 'restaurant/get-ads/10/' ; //Below Featured categories 3
  static String getAdsEleven = baseURL + 'restaurant/get-ads/11/' ; //Below vertical slider
  static String getAdsThree = baseURL + 'restaurant/get-ads/3/' ; //Website slider
  static String getFooter = baseURL + 'restaurant/get-ads/4/' ; //Footer image
  static String pageDetails = baseURL + 'get-page-details/'; //page details
  static String getPopupBanner = baseURL + 'restaurant/get-ads/16/' ;//popupbanner
  static String getCategories = baseURL + 'restaurant/get-categories'; //Fetch categories
  static String getSubCategories = baseURL + 'restaurant/get-sub-category/'; //Fetch subcategory
  static String getShoppingList = baseURL + 'v2/get-shopping-list/';
  static String getShoppingListItem = baseURL + 'get-shopping-list-item/';
  static String getRefereal = baseURL + 'get-refercountdetails/';
  static String getReferalMultivendor = baseURL +'v3/get-refercountdetails/';
  //Related to orders
  static String getCustomerOrder = baseURL + 'get-customer-order/';
  static String getCustomerOrderBranch = baseURL + 'get-customer-order-branch/';
  static String getCustomerRefOrderBranch = baseURL + 'get-customer-ref-order-branch';
  static String mySubscriptionList = baseURL + 'v2/my-subscription-list/';
  static String viewCustomerOrderDetails = baseURL + 'view-customer-order-details/';
  static String viewSubscriptionList = baseURL + 'v2/view-subscription-list/';
  static String getRefundProduct = baseURL + 'get-refund-product';
  static String newReturn = baseURL + 'return/new-return';
  static String cancelOrder = baseURL + 'cancel-order';
  static String cancelOrderBack = baseURL + 'cancel-order-back';
  static String addRatings = baseURL + 'add-ratings';
  static String addRatingsProduct = baseURL + 'add-product-ratings';
  static String subscriptionCreate = baseURL + 'v2/subscription-create';
  static String getSubscriptionPaymentStatus = baseURL + 'get-subscription-payment-status/';
  static String checkPromocode = baseURL + 'v3/check-promocode';
  static String checkAnavailablecoupon = baseURL + 'get-notapplicable-coupons';
  static String createTicket = baseURL + 'create-ticket';
  static String removeSubscription = baseURL + 'subscription-order-delete';
  static String pauseSubscription = baseURL + 'subscription-order-pause';
  static String resumeSubscription = baseURL + 'subscription-order-resume';
  static String upcomingSubscription = baseURL + 'get-upcoming-subscription';
  //Address api's
  static String addAddress = baseURL + 'customer/address/add-new';
  static String updateAddress = baseURL + 'customer/address/update';
  static String getAddress = (Features.ismultivendor) ? baseURL + 'v3/get-address' : baseURL + 'v3/get-address';
  static String setDefaultAddress = baseURL + 'set-default-address';
  static String removeAddress = baseURL + 'customer/address/remove';
  static String getDeliveryCharges =  baseURL + 'v3/get-delivery-charges';
  static String pickupLocation = baseURL + 'pickup-location';
  static String getDeliverySlots = baseURL + 'get-delivery-slots';
  static String getDeliverySlotsFull = baseURL + 'v3-get-delivery-slots';
  static String getPickupSlot = baseURL + 'get-pickup-slot/';
  static String getDeliveryChargesold =  baseURL + 'get-delivery-charges/';

  //Related to cart
  static String addToCart = baseURL + 'v3/add-to-cart';
  static String updateCart = baseURL + 'v3/update-cart';
  static String reorder = baseURL + 'reorder/';
  static String emptyCart = baseURL + 'empty-cart/';
  static String getCartItems = baseURL + 'get-cart-items/';
  static String cartCheck = baseURL + 'cart-check/';
  static String cartCheckMultivendor = baseURL + 'v3/cart-check/';

  //brands related API's
  static String getBrands = baseURL + 'restaurant/get-brands';
  static String getBrandsData = baseURL + 'get-brands-data/';

  //Related to payments
  static String paymentModeBranch = baseURL + 'payment-mode-branch';
  static String getLoyalty = baseURL + 'get-loyalty';
  static String checkLoyalty = baseURL + 'check-loyalty/';

  //Related to wallet
  static String walletLogs = baseURL + 'wallet/get-logs';

  //Related to shopping list
  static String createShoppingList = baseURL + 'restaurant/create-shopping-list';
  static String addItemToList = baseURL + 'v2/restaurant/add-item-to-list'/*'restaurant/add-item-to-list'*/;
  static String removeShoppingList = baseURL + 'restaurant/remove-shopping-list';

  static String getOffers = baseURL + 'get-offers';
  static String getSurveyProduct = baseURL +  "get-survey-products";
  //Not for live cart
  static String getFeatured = baseURL + 'restaurant/get-featured';
  static String getDiscounted = baseURL + 'restaurant/get-discount';
  static String getMenuitem = baseURL + 'restaurant/get-menuitem';
  static String getSerachitem = baseURL + 'restaurant/search-items';
  static String getSingleProduct = baseURL + 'single-product';
  static String getRecentProducts = baseURL + 'restaurant/get-recent-products/';
  static String getMenuitemByBrand = baseURL + 'restaurant/get-menuitem-by-brand';
  static String getItems = baseURL + 'get-items/';
  static String newOrder = baseURL + 'order/new-order';
  static String newOrderByCartSplitSeller = baseURL + /*'order/new-order/split';*/'order/new-order/seller';

  //For Live cart
  static String getFeaturedByCart = baseURL + 'v3/restaurant/get-featured-by-cart';
  static String getDiscountedByCart = baseURL + 'v3/restaurant/get-discount-by-cart';
  static String getForgetByCart = baseURL+ 'v3/restaurant/get-items-data-by-cart';
  static String getMenuitemByCart = baseURL + 'v3/restaurant/get-menuitem-by-cart';
  static String getSerachitemByCart = baseURL + 'v3/restaurant/search-items-by-cart';
  static String getSingleProductByCart = baseURL + 'single-product-by-cart';
  static String getSingleProductvarIdByCart = baseURL + 'v3/single-product-by-var';
  static String getRecentProductsByCart = baseURL + 'v3/restaurant/get-recent-products-by-cart/';
  static String getMenuitemByBrandByCart = baseURL + 'v3/restaurant/get-menuitem-by-brand-by-cart';
  static String getItemsByCart = baseURL + 'v3/get-items-by-cart/';
  static String newOrderByCart = baseURL + 'v3/order/new-order-by-cart';
  static String newOrderByCartSplit = baseURL + 'v3/order/new-order/split';
  static String getOfferByCart = baseURL + 'v3/restaurant/get-offer-by-cart';
  static String getSwapProduct = baseURL + 'v3/get-swap-product';


  //Related to payment
  static String updatePaymentStatusSplit = baseURL + 'update-payment-status-split';
  static String updateSubscriptionPayment = baseURL + 'update-subscription-payment';
  static String getOrderStatus = baseURL + 'restaurant/get-order-status/';
  static String paytmteckenapi ='https://paytmsdk.grocbay.com/paytmtoken.php?';

  static String getPromocode =baseURL + 'get-coupans';
  static String getRepeateToppings =baseURL + 'v2/restaurant/get-repeat-toppings';

  static String getStorelist = baseURL + 'get-store-list';
  static String getCustomerMultivendorRefOrderBranch = baseURL + 'v3/get-customer-ref-order-branch';

  static String addMoneyToWallet =  baseURL + 'subscription/wallet-credit';

  static String viewToppingsExistingDetails = baseURL + "check-topping";
  static String submitAnswer = baseURL + "v3/update-customerenagement-questions";

  static String btobregister = baseURL + 'customer/register-b2b';
}
