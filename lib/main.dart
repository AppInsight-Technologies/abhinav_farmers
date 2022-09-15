import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import '../../assets/ColorCodes.dart';
import '../../screens/PageNotFound.dart';
import './utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import './data/calculations.dart';
import 'controller/mutations/languagemutations.dart';
import 'generated/l10n.dart';
import 'handler/firebase_notification_handler.dart';
import 'models/VxModels/VxStore.dart';
import 'models/unavailabilityfield.dart';
import './providers/carouselitems.dart';
import './providers/branditems.dart';
import './providers/categoryitems.dart';
import './providers/advertise1items.dart';
import './providers/sellingitems.dart';
import './providers/itemslist.dart';
import './providers/addressitems.dart';
import './providers/deliveryslotitems.dart';
import './providers/myorderitems.dart';
import './providers/membershipitems.dart';
import './providers/notificationitems.dart';
import 'models/categoriesfields.dart';
import 'models/sellingitemsfields.dart';
import './models/unavailableproducts_field.dart';
import './providers/featuredCategory.dart';
import './providers/cartItems.dart';
import './constants/IConstants.dart';
import 'rought_genrator.dart';
import 'utils/httpOveride.dart';

const String productBoxName = "product";
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const Color black = Color(0xff2b6838);
  // Vx.setPathUrlStrategy();
  await PrefUtils.init();
  if(!PrefUtils.prefs!.containsKey("branch"))
    PrefUtils.prefs!.setString("branch", "65");
  PrefUtils.prefs!.setInt("htmlId", 1);

  FirebaseNotifications().setUpFirebase;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) async{
    if (Vx.isAndroid) {
      // var androidInfo =  DeviceInfoPlugin().androidInfo;
      // var release = androidInfo.version.release;
      // var sdkInt = androidInfo.version.sdkInt;
      // var manufacturer = androidInfo.manufacturer;
      // var model = androidInfo.model;
      // print('Android $release (SDK $sdkInt), $manufacturer $model');
      // // Android 9 (SDK 28), Xiaomi Redmi Note 7
      HttpOverrides.global = MyHttpOverrides();
    }
    print("main running");
    runApp(VxState(store: GroceStore(), child: MyApp()));

/*    await SentryFlutter.init(
          (options) {
        options.dsn = 'https://06fd44c3c22844a8b85c6e808c3ff590@o1150007.ingest.sentry.io/6222517';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        // options.tracesSampleRate = 1.0;
      },

    );*/

  });
}
class LoadingInfo extends ChangeNotifier{
  bool? _isloading ;
  get isloading =>_isloading??=true;
  set isloading(value) {
    _isloading =value;
    notifyListeners();
  }
}
final loadinginfo = LoadingInfo();
class MyApp extends StatelessWidget with Navigations{
  Uri muri = Uri.parse("/");
  String activelang = "en";

  // bool _isWeb = false;
  @override
  Widget build(BuildContext context) {
    IConstants.isEnterprise?SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values):
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
    ));
      final _router = GoRouter(
        errorPageBuilder: (context,state)=>MaterialPage(child: /*Scaffold(body: Center(
         child: Image.asset(
           Images.logoImg1,
           // color: Colors.white,
           height: 30,
           // width: 200,
         ),
        ),)*/
          PageNotFound()
        ),
        redirect: (state){
          // print("redirect subloc: ${state.subloc}");
        // if(Features.isOnBoarding&&state.path==nUri(Routename.Home).path) {
        //   if ( PrefUtils.prefs!.containsKey('introduction')&& PrefUtils.prefs!.getBool('introduction')==false) {
        //   return nUri(Routename.Introduction).path;
        //   }
        // }
          return null;
        },
        // refreshListenable: loadinginfo,
        // urlPathStrategy: UrlPathStrategy.path,
        initialLocation:Vx.isWeb? "/store/"+nUri(Routename.Home).path:"/store/${nUri(Routename.Splash).path}",
        debugLogDiagnostics:Vx.isDebugMode,
        routes: PageControler().routs,
      );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: CarouselItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: BrandItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: CategoriesItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: Advertise1ItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: SellingItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: ItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: AddressItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: DeliveryslotitemsList(),
          ),
          ChangeNotifierProvider.value(
            value: MyorderList(),
          ),
          ChangeNotifierProvider.value(
            value: MembershipitemsList(),
          ),
          ChangeNotifierProvider.value(
            value: NotificationItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: CategoriesFields(),
          ),
          ChangeNotifierProvider.value(
            value: SellingItemsFields(),
          ),
          ChangeNotifierProvider.value(
            value: CartCalculations(),
          ),
          ChangeNotifierProvider.value(
            value: unavailabilitiesfield(),
          ),
          ChangeNotifierProvider.value(
              value: unavailabilities()
          ),
          ChangeNotifierProvider.value(
              value: FeaturedCategoryList()
          ),
          ChangeNotifierProvider.value(
              value: CartItems()
          )
        ],
        child: VxBuilder<GroceStore>(
            mutations: {SetLanguage},
            builder: (BuildContext context, store, VxStatus? status) {
              return  MaterialApp.router(
                scrollBehavior: MyCustomScrollBehavior(),
                builder: (context, child) {
                  print("alang:${store.language.language.code}");
                  return MediaQuery(
                    child:  Directionality(
                        textDirection:!Vx.isWeb ? store.language.language.code =="ar" ? TextDirection.rtl : TextDirection.ltr : TextDirection.ltr ,child: child!),
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  );
                },

                locale: Locale(store.language.language.code??"en"),
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                title: IConstants.APP_NAME,
                theme: ThemeData(

                  buttonColor: Colors.white,
                  textSelectionTheme:
                  TextSelectionThemeData(selectionColor: ColorCodes.baseColorlight),
                  backgroundColor: ColorCodes.baseColorlight,
                  fontFamily: 'Lato',
                  //For web, if required disable it for mobile
                  pageTransitionsTheme: NoTransitionsOnWeb(), colorScheme: ColorScheme.fromSwatch(primarySwatch: MaterialColor(0xff009832, {
                    50: Color(0xff009832),
                    100: Color(0xff009832),
                    200: Color(0xff009832),
                    300: Color(0xff009832),
                    400: Color(0xff009832),
                    500: Color(0xff009832),
                    600: Color(0xff009832),
                    700: Color(0xff009832),
                    800: Color(0xff009832),
                    900: Color(0xff009832),
                  })).copyWith(secondary: MaterialColor(0xff35a2df, {
                    50: Color(0xff009832),
                    100: Color(0xff009832),
                    200: Color(0xff009832),
                    300: Color(0xff009832),
                    400: Color(0xff009832),
                    500: Color(0xff009832),
                    600: Color(0xff009832),
                    700: Color(0xff009832),
                    800: Color(0xff009832),
                    900: Color(0xff009832),
                  })),
                 // textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.grey, selectionHandleColor: Colors.grey,),

                ),
                routeInformationParser: _router.routeInformationParser,
                routerDelegate: _router.routerDelegate,
              );
            }
        ));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

//For Web
class NoTransitionsOnWeb extends PageTransitionsTheme {
  @override
  Widget buildTransitions<T>(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
      ) {
    if (kIsWeb) {
      return child;
    }
    return super.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
