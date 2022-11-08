class ChatInfo {
  String? sdkappid;
  String? userSig;
  String? userID;

  ChatInfo.fromJSON(Map<String, dynamic> json) {
    sdkappid = json["sdkappid"].toString();
    userSig = json["userSig"].toString();
    userID = json["userID"].toString();
  }

  Map<String, String> toMap(){
    final Map<String, String> map = {};
    if(sdkappid != null){
      map["sdkappid"] = sdkappid!;
    }
    if(userSig != null){
      map["userSig"] = userSig!;
    }
    if(userID != null){
      map["userID"] = userID!;
    }
    return map;
  }
}

class CallInfo{
  String? userID;
  String? groupID;

  CallInfo();

  CallInfo.fromJSON(Map<String, dynamic> json) {
    groupID = json["groupID"].toString();
    userID = json["userID"].toString();
  }

  Map<String, String> toMap(){
    final Map<String, String> map = {};
    if(userID != null){
      map["userID"] = userID!;
    }
    if(groupID != null){
      map["groupID"] = groupID!;
    }
    return map;
  }
}