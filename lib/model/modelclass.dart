import 'dart:convert';

class Token {
  String access_token;
  String token_type;
  int expires_in;
  DateTime? createTime;
  String? url;

  Token({required this.access_token,required this.token_type,required this.expires_in});

  static Token setInstance (Map map, String url) {
    Token token = Token(access_token:map['access_token'],token_type:map['token_type'],expires_in:map['expires_in']);
    token.createTime = DateTime.now();
    token.url = url;
    return token;
  }
  bool isValid() {
    DateTime time = DateTime.now();
    Duration duration = time.difference(createTime!);
    return duration.inSeconds <= expires_in;
  }
}

ResponseClass responseClassFromJson(String str) => ResponseClass.fromJson(json.decode(str));
String responseClassToJson(ResponseClass data) => json.encode(data.toJson());

class ResponseClass {
  ResponseClass({
    required this.responseCode,
    required this.detailedMessage,
    this.record,
    this.recordNo,
    required this.message,
  });

  int responseCode;
  String detailedMessage;
  dynamic record;
  dynamic recordNo;
  String message;

  factory ResponseClass.fromJson(Map<String, dynamic> json) => ResponseClass(
    responseCode: json["responseCode"],
    detailedMessage: json["detailedMessage"],
    record: json["record"],
    recordNo: json["recordNo"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "detailedMessage": detailedMessage,
    "record": record,
    "recordNo": recordNo,
    "message": message,
  };
}

LoyaltyUserPersonalInfo loyaltyUserPersonalInfoFromJson(String str) => LoyaltyUserPersonalInfo.fromJson(json.decode(str));
String loyaltyUserPersonalInfoToJson(LoyaltyUserPersonalInfo data) => json.encode(data.toJson());

class LoyaltyUserPersonalInfo {
  LoyaltyUserPersonalInfo({
    this.name,
    this.lastname,
    this.bpartnerId,
    this.bpartnerValue,
    this.loyaltyNo,
  });

  String? name;
  String? lastname;
  int? bpartnerId;
  String? bpartnerValue;
  String? loyaltyNo;
  factory LoyaltyUserPersonalInfo.fromJson(Map<String, dynamic> json) => LoyaltyUserPersonalInfo(
    name: json["name"],
    lastname: json["lastname"],
    bpartnerId: json["bpartnerId"],
    bpartnerValue: json["bpartnerValue"],
    loyaltyNo: json["loyaltyNo"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lastname": lastname,
    "bpartnerId": bpartnerId,
    "bpartnerValue": bpartnerValue,
    "loyaltyNo": loyaltyNo,
  };
}

LoyalityUserData loyalityUserDataFromJson(String str) => LoyalityUserData.fromJson(json.decode(str));
String loyalityUserDataToJson(LoyalityUserData data) => json.encode(data.toJson());

class LoyalityUserData {
  LoyalityUserData({
    required this.phone,
    required this.loyaltyNo,
    required this.phone2,
    required this.customerName,
    required this.points,
    required this.valueNumber,
    required this.pointsRequired,
    required this.minPointsRequired

  });

  String phone;
  String loyaltyNo;
  String phone2;
  String customerName;
  double points;
  double valueNumber;
  double pointsRequired;
  double minPointsRequired;


  factory LoyalityUserData.fromJson(Map<String, dynamic> json) => LoyalityUserData(
    phone: json["phone"],
    loyaltyNo: json["loyaltyNo"],
    phone2: json["phone2"],
    customerName: json["customerName"],
    points: double.parse(json["points"].toString()),
    valueNumber: double.parse(json["valueNumber"].toString()),
    pointsRequired: double.parse(json["pointsRequired"].toString()),
    minPointsRequired: double.parse(json["minPointsRequired"].toString()),

  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "loyaltyNo": loyaltyNo,
    "phone2": phone2,
    "customerName": customerName,
    "points": points,
    "valueNumber": valueNumber,
    "pointsRequired": pointsRequired,
    "minPointsRequired": minPointsRequired,


  };
}


List<LoyalityHistoryData> loyalityHistoryDataDataFromJson(String str) {
  final jsonData = json.decode(str);
  return List<LoyalityHistoryData>.from(jsonData.map((item) => LoyalityHistoryData.fromJson(item)));
}

String loyalityHistoryDataDataToJson(List<LoyalityHistoryData> data) {
  return json.encode(List<dynamic>.from(data.map((item) => item.toJson())));
}

class LoyalityHistoryData {
  LoyalityHistoryData({
    required this.dateAcc,
    required this.loyaltyNo,
    required this.pointsEarned,
    required this.customerName,
    required this.pointsRedeemed,
    required this.invoiceNo,
    required this.orgName,
  });

  String invoiceNo;
  String loyaltyNo;
  String customerName;
  String dateAcc;
  double pointsEarned;
  double pointsRedeemed;
  String orgName;

  factory LoyalityHistoryData.fromJson(Map<String, dynamic> json) => LoyalityHistoryData(
    invoiceNo: json["invoiceNo"] ?? "",
    loyaltyNo: json["loyaltyNo"] ?? "",
    customerName: json["customerName"] ?? "",
    dateAcc: json["dateAcc"] ?? "",
    pointsEarned: double.parse(json["pointsEarned"].toString()),
    pointsRedeemed: double.parse(json["pointsRedeemed"].toString()),
    orgName: json["orgName"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "invoiceNo": invoiceNo,
    "loyaltyNo": loyaltyNo,
    "customerName": customerName,
    "dateAcc": dateAcc,
    "pointsEarned": pointsEarned,
    "pointsRedeemed": pointsRedeemed,
    "orgName": orgName,
  };
}

//generateVoucher
List<VoucherDetails> voucherDetailsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<VoucherDetails>.from(jsonData.map((item) => VoucherDetails.fromJson(item)));
}

String voucherDetailsToJson(List<VoucherDetails> data) {
  return json.encode(List<dynamic>.from(data.map((item) => item.toJson())));
}

class VoucherDetails {
  VoucherDetails({
    required this.customerId,
    required this.pointsValue,
    required this.points,
  });

  int customerId;
  double pointsValue;
  double points;

  factory VoucherDetails.fromJson(Map<String, dynamic> json) => VoucherDetails(
    customerId: json["customerId"],
    pointsValue: json["pointsValue"],
    points: json["points"],
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "pointsValue": pointsValue,
    "points": points,
  };
}

//active voucher
List<ActiveVoucherModel> activeVoucherModelFromJson(String str) {
  final jsonData = json.decode(str);
  return List<ActiveVoucherModel>.from(jsonData.map((item) => ActiveVoucherModel.fromJson(item)));
}

String activeVoucherModelToJson(List<ActiveVoucherModel> data) {
  return json.encode(List<dynamic>.from(data.map((item) => item.toJson())));
}

class ActiveVoucherModel {
  ActiveVoucherModel({
    required this.voucherNo,
    required this.voucherAmt,
    required this.redeemedAmt,
    required this.redeemed,
    required this.dateCreated,
    required this.dateRedeemed

  });

  String voucherNo;
  double voucherAmt;
  double redeemedAmt;
  bool redeemed;
  String? dateCreated;
  String? dateRedeemed;

  factory ActiveVoucherModel.fromJson(Map<String, dynamic> json) => ActiveVoucherModel(
    voucherNo: json["voucherNo"],
    voucherAmt: double.parse(json["voucherAmt"].toString()),
    redeemedAmt: double.parse(json["redeemedAmt"].toString()),
    redeemed: json["redeemed"],
      dateCreated: json["dateCreated"] as String? ?? "", // Set empty string if null
      dateRedeemed: json["dateRedeemed"] as String? ?? "",


  );

  Map<String, dynamic> toJson() => {
    "voucherNo": voucherNo,
    "voucherAmt": voucherAmt,
    "redeemedAmt": redeemedAmt,
    "redeemed": redeemed,
    "dateCreated": dateCreated ?? "",
    "dateRedeemed": dateRedeemed ?? "",


  };
}
