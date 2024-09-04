
import 'package:groupchat/views/admin_screens/add_emergency_number_screen.dart';
import 'package:groupchat/views/admin_screens/add_new_country_screen.dart';
import 'package:groupchat/views/admin_screens/add_news_screen.dart';
import 'package:groupchat/views/admin_screens/all_news_screen.dart';
import 'package:groupchat/views/admin_screens/all_places_screen.dart';
import 'package:groupchat/views/admin_screens/manage_business_list_screen.dart';
import 'package:groupchat/views/admin_screens/manage_places_screen.dart';
import 'package:groupchat/views/auth/forgot_password_screen.dart';
import 'package:groupchat/views/auth/register_screen.dart';
import 'package:groupchat/views/auth/splash_screen.dart';
import 'package:groupchat/views/categories_screens/categories_screen.dart';
import 'package:groupchat/views/categories_screens/pdf_view_screen.dart';
import 'package:groupchat/views/companies_screens/companies_screen.dart';
import 'package:groupchat/views/companies_screens/company_detail_screen.dart';
import 'package:groupchat/views/companies_screens/company_settings_screen.dart';
import 'package:groupchat/views/admin_screens/add_new_company_screen.dart';
import 'package:groupchat/views/admin_screens/admin_home_screen.dart';
import 'package:groupchat/views/home_screens/contacts_info_screen.dart';
import 'package:groupchat/views/home_screens/home_screen.dart';
import 'package:groupchat/views/home_screens/privacy_policy_screen.dart';
import 'package:groupchat/views/home_screens/teachers_home_screen.dart';
import 'package:groupchat/views/news_screens/news_details_screen.dart';
import 'package:groupchat/views/news_screens/news_screen.dart';
import 'package:groupchat/views/profile_screens/my_documents_screen.dart';
import 'package:groupchat/views/profile_screens/personal_info_screen.dart';
import 'package:groupchat/views/profile_screens/settings_list_screen.dart';

import '../views/auth/login_screen.dart';
import '../views/categories_screens/pdf_list_screen.dart';
import '../views/places_screens/places_detail_screen.dart';
import '../views/places_screens/places_screen.dart';
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
    CompanySettingsScreen.route: (context) => CompanySettingsScreen(),
    NewsScreen.route: (context) => NewsScreen(),
    NewsDetailsScreen.route: (context) => NewsDetailsScreen(),
    PrivacyPolicyScreen.route: (context) => PrivacyPolicyScreen(),
    ContactsInfoScreen.route: (context) => ContactsInfoScreen(),
    AddNewCompanyScreen.route: (context) => AddNewCompanyScreen(),
    ManageBusinessListScreen.route: (context) => ManageBusinessListScreen(),
    AddNewCountryScreen.route: (context) => AddNewCountryScreen(),
    ManagePlacesScreen.route: (context) => ManagePlacesScreen(),
    AllPlacesScreen.route: (context) => AllPlacesScreen(),
    AddNewsScreen.route: (context) => AddNewsScreen(),
    AllNewsScreen.route: (context) => AllNewsScreen(),
    AddEmergencyNumbersScreen.route: (context) => AddEmergencyNumbersScreen()
  };
}