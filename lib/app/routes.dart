
import 'package:groupchat/views/auth/forgot_password_screen.dart';
import 'package:groupchat/views/auth/register_screen.dart';
import 'package:groupchat/views/auth/splash_screen.dart';
import 'package:groupchat/views/categories_screens/categories_screen.dart';
import 'package:groupchat/views/categories_screens/pdf_view_screen.dart';
import 'package:groupchat/views/companies_screens/companies_screen.dart';
import 'package:groupchat/views/companies_screens/company_detail_screen.dart';
import 'package:groupchat/views/companies_screens/company_settings_screen.dart';
import 'package:groupchat/views/home_screens/admin_home_screen.dart';
import 'package:groupchat/views/home_screens/home_screen.dart';
import 'package:groupchat/views/home_screens/teachers_home_screen.dart';
import 'package:groupchat/views/places/places_detail_screen.dart';
import 'package:groupchat/views/places/places_screen.dart';
import 'package:groupchat/views/profile_screens/my_documents_screen.dart';
import 'package:groupchat/views/profile_screens/personal_info_screen.dart';
import 'package:groupchat/views/profile_screens/settings_list_screen.dart';

import '../views/auth/login_screen.dart';
import '../views/categories_screens/pdf_list_screen.dart';
import '../views/profile_screens/profile_home_screen.dart';

getRoutes(){
  return {
    LoginScreen.route: (context) => LoginScreen(),
    RegisterScreen.route: (context) => RegisterScreen(),
    SplashScreen.route: (context) => SplashScreen(),
    AdminHomeScreen.route: (context) => AdminHomeScreen(),
    HomeScreen.route: (context) => HomeScreen(),
    PlacesScreen.route: (context) => PlacesScreen(),
    PlacesDetailScreen.route: (context) => PlacesDetailScreen(),
    TeachersHomeScreen.route: (context) => TeachersHomeScreen(),
    CategoriesScreen.route: (context) => CategoriesScreen(),
    PdfListScreen.route: (context) => PdfListScreen(),
    ForgotPasswordScreen.route: (context) => ForgotPasswordScreen(),
    PdfViewScreen.route: (context) => const PdfViewScreen(),
    ProfileHomeScreen.route: (context) => ProfileHomeScreen(),
    PersonalInfoScreen.route: (context) => PersonalInfoScreen(),
    MyDocumentsScreen.route: (context) => MyDocumentsScreen(),
    SettingsListScreen.route: (context) => SettingsListScreen(),
    CompaniesScreen.route: (context) => CompaniesScreen(),
    CompanyDetailScreen.route: (context) => CompanyDetailScreen(),
    CompanySettingsScreen.route: (context) => CompanySettingsScreen()
  };
}