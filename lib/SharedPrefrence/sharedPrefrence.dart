
import 'package:get_storage/get_storage.dart';

class SharedPreference{

  final storage = GetStorage();
  void saveLoyalityUsersName(String name,String lastName,int bParrtnerId,String bpartnerValue,String loyaltyNumber)async{
    storage.write('name', name);
    storage.write('lastname',lastName);
    storage.write('bpartnerId', bParrtnerId);
    storage.write('bpartnervalue', bpartnerValue);
    storage.write('loyaltyNo', loyaltyNumber);
  }
   void saveTockenData(String access_token1,String access_tocken_type){
    storage.write('access_token',access_token1);
    storage.write('access_tocken_type', access_tocken_type);
  }

  void eraseAllSharedPreferenceData() async{
    await storage.erase();
  }

  String getLoyaltyUsersName(){
    return storage.read('name') ?? "";
  }
  String getLoyaltyUsersLastName(){
    return storage.read('lastname') ?? "";
  }
  int getLoyaltyUsersBpartnerId(){
    return storage.read('bpartnerId') ?? 0;
  }
  String getLoyaltyUsersBpartnerValue(){
    return storage.read('bpartnervalue') ?? "";
  }
  String getLoyaltyUsersLoyaltyNumber(){
    return storage.read('loyaltyNo') ?? "";
  }
  void savePhoneNumber(String phoneNumber) {
    storage.write('savedPhoneNumber', phoneNumber);
  }
  String getPhoneNumber() {
    return storage.read('savedPhoneNumber') ?? "";
  }
}