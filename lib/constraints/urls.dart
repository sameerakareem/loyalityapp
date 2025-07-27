// class Urls{
//
//   static const usersContryCode = "+971";
//   // static const baseUrls = "http://lekkerapi.posibolt.com";
//   // static const String dummyUsername = "ADMIN LEKKER SHOP";
//   // static const String dummyPassword = "lekker@uae";
//   // static const String dummyAppId = "355333";
//   // static const String dummyAppSecret = "8158935";
//   // static const String dummyTerminal = "Terminal 1";
//
//
//   static const otpGeneratingUrl = "$baseUrls/AdempiereService/PosiboltRest/otp/generateotp/";
//   static const otpValidatingUrl = "$baseUrls/AdempiereService/PosiboltRest/otp/match?";
//   static const loyaltyUserDataUrl = "$baseUrls/AdempiereService/PosiboltRest/customerloyaltymaster/loyaltypoints?customerId=";
//   static const dummyTockenGeneratingUrls = "$baseUrls/AdempiereService/oauth/token?username=${dummyUsername}&password=${dummyPassword}&grant_type=password&terminal=${dummyTerminal}";
//   static const loyaltyHistoryDataUrl = "$baseUrls/AdempiereService/PosiboltRest/customerloyaltymaster/gettransactionhistory?customerId=";
//   static const generateVoucher = "$baseUrls/AdempiereService/PosiboltRest/customerloyaltymaster/createVoucherFromPoints";
//   static const activeVoucherHistory = "$baseUrls/AdempiereService/PosiboltRest/customerloyaltymaster/listvouchers?customerId=";
//
//   // static const baseUrls = "http://defacto.posibolt.com:8088";
//   // static const String dummyUsername = "admin";
//   // static const String dummyPassword = "vma1m0";
//   // static const String dummyAppId = "1001";
//   // static const String dummyAppSecret = "2001";
//   // static const String dummyTerminal = "Terminal 1";
//
//   //maqsoudplastics instance
//   static const baseUrls = "http://maqsoudplastics.posibolt.com";
//   static const String dummyUsername = "LOYALTY USER";
//   static const String dummyPassword = "loyalty@P0s";
//   static const String dummyAppId = "892247";
//   static const String dummyAppSecret = "9096177";
//   static const String dummyTerminal = "Terminal 1";
//
//   //testClt70 instance Details
//   static const baseUrls = "http://testclt70.posibolt.org";
//   static const String dummyUsername = "admin";
//   static const String dummyPassword = "0209";
//   static const String dummyUrls = "http://testclt70.posibolt.org";
//   static const String dummyAppId = "795613";
//   static const String dummyAppSecret = "2715577";
//   static const String dummyTerminal = "Terminal 1";
// }


import '../SharedPrefrence/sharedPrefrence.dart';


import '../SharedPrefrence/sharedPrefrence.dart';

class Urls {
  static const usersContryCode = "+971";

  // Base URLs for different instances
  static const String maqsoudBaseUrl = "http://maqsoudplastics.posibolt.com";
  static const String testclt70BaseUrl = "http://testclt70.posibolt.org";
 // static const String defactoBaseUrl = "http://defacto.posibolt.com:8088";

  // Credentials for Maqsoud instance
  static const String dummyUsername = "LOYALTY USER";
  static const String dummyPassword = "loyalty@P0s";
  static const String dummyAppId = "892247";
  static const String dummyAppSecret = "9096177";
  static const String dummyTerminal = "Terminal 1";

  // Credentials for defacto instance
  // static const String dummyUsername = "admin";
  // static const String dummyPassword = "vma1m0";
  // static const String dummyAppId = "1001";
  // static const String dummyAppSecret = "2001";
  // static const String dummyTerminal = "Terminal 1";


  // Credentials for testclt70 instance
  static const String testclt70Username = "admin";
  static const String testclt70Password = "0209";
  static const String testclt70AppId = "795613";
  static const String testclt70AppSecret = "2715577";
  static const String testclt70Terminal = "Terminal 1";

  // ✅ Fetch stored phone number
  static String getStoredPhoneNumber() {
    SharedPreference sharedPreference = SharedPreference();
    return sharedPreference.getPhoneNumber();
  }

  // ✅ Get the base URL dynamically
  static String getBaseUrl() {
    String phoneNumber = getStoredPhoneNumber();
    if (phoneNumber == "000000000") {
      print("Test instance detected. Using base URL: $testclt70BaseUrl");
      return testclt70BaseUrl;
    } else {
      print("Production instance detected. Using base URL: $maqsoudBaseUrl");
      return maqsoudBaseUrl;
    }
  }

  // ✅ **Ensure URLs update dynamically by converting them to getter functions**
  static String get otpGeneratingUrl => "${getBaseUrl()}/AdempiereService/PosiboltRest/otp/generateotp/";
  static String get otpValidatingUrl => "${getBaseUrl()}/AdempiereService/PosiboltRest/otp/match?";
  static String get loyaltyUserDataUrl => "${getBaseUrl()}/AdempiereService/PosiboltRest/customerloyaltymaster/loyaltypoints?customerId=";
  static String get dummyTockenGeneratingUrls => "${getBaseUrl()}/AdempiereService/oauth/token?username=${getUsername()}&password=${getPassword()}&grant_type=password&terminal=${getTerminal()}";
  static String get loyaltyHistoryDataUrl => "${getBaseUrl()}/AdempiereService/PosiboltRest/customerloyaltymaster/gettransactionhistory?customerId=";
  static String get generateVoucher => "${getBaseUrl()}/AdempiereService/PosiboltRest/customerloyaltymaster/createVoucherFromPoints";
  static String get activeVoucherHistory => "${getBaseUrl()}/AdempiereService/PosiboltRest/customerloyaltymaster/listvouchers?customerId=";

  // ✅ Dynamic credentials based on instance type
  static String getUsername() => getStoredPhoneNumber() == "000000000" ? testclt70Username : dummyUsername;
  static String getPassword() => getStoredPhoneNumber() == "000000000" ? testclt70Password : dummyPassword;
  static String getAppId() => getStoredPhoneNumber() == "000000000" ? testclt70AppId : dummyAppId;
  static String getAppSecret() => getStoredPhoneNumber() == "000000000" ? testclt70AppSecret : dummyAppSecret;
  static String getTerminal() => getStoredPhoneNumber() == "000000000" ? testclt70Terminal : dummyTerminal;
}
