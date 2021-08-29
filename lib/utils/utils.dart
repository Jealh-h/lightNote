import 'dart:async';
import 'dart:math';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightnote/screens/login/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// 动态申请定位权限
void requestPermission() async {
  // 申请权限
  bool hasLocationPermission = await requestLocationPermission();
  if (hasLocationPermission) {
    print("定位权限申请通过");
  } else {
    print("定位权限申请不通过");
  }
}

/// 申请定位权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestLocationPermission() async {
  //获取当前的权限
  var status = await Permission.location.status;
  if (status == PermissionStatus.granted) {
    //已经授权
    return true;
  } else {
    //未授权则发起一次申请
    status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

///设置定位参数
void gaodeGetLocation() {
  ///设置Android和iOS的apiKey<br>
  ///key的申请请参考高德开放平台官网说明<br>
  ///Android: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key
  ///iOS: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key
  AMapFlutterLocation.setApiKey("adbc3b129756e212db42622df083533f", "");
  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();
  AMapLocationOption locationOption = new AMapLocationOption();

  ///是否单次定位
  locationOption.onceLocation = true;

  ///是否需要返回逆地理信息
  locationOption.needAddress = true;

  ///逆地理信息的语言类型
  locationOption.geoLanguage = GeoLanguage.ZH;

  locationOption.desiredLocationAccuracyAuthorizationMode =
      AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

  locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

  ///设置Android端连续定位的定位间隔
  locationOption.locationInterval = 2000;

  ///设置Android端的定位模式<br>
  ///可选值：<br>
  ///<li>[AMapLocationMode.Battery_Saving]</li>
  ///<li>[AMapLocationMode.Device_Sensors]</li>
  ///<li>[AMapLocationMode.Hight_Accuracy]</li>
  locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

  ///设置iOS端的定位最小更新距离<br>
  locationOption.distanceFilter = -1;

  ///设置iOS端期望的定位精度
  /// 可选值：<br>
  /// <li>[DesiredAccuracy.Best] 最高精度</li>
  /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
  /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
  /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
  /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
  locationOption.desiredAccuracy = DesiredAccuracy.Best;

  ///设置iOS端是否允许系统暂停定位
  locationOption.pausesLocationUpdatesAutomatically = false;

  ///将定位参数设置给定位插件
  _locationPlugin.setLocationOption(locationOption);

  _locationPlugin.onLocationChanged().listen((event) {
    print(event);
  });

  // 申请权限
  requestPermission();
  // 开始定位
  _locationPlugin.startLocation();
}

// 设置用户信息到shared_preferences里面
Future<void> setUserInfo(Map userInfo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("id", '${userInfo["id"]}');
  prefs.setString("email", userInfo["email"]);
  prefs.setString("username", userInfo["username"]);
  prefs.setString("avatarUrl", userInfo["avatarUrl"]);
  prefs.setString("signature", userInfo["signature"]);
}
//
// /**
//  * SP方法介绍
//  * remover(key),移除像关键，调用get会返回null
//  */

// 从sharedpreference中获取用户信息
Future<Map<String, String?>> getUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    "id": prefs.getString("id"),
    "eamil": prefs.getString("email"),
    "avatarUrl": prefs.getString("avatarUrl"),
    "username": prefs.getString("username"),
    "signature": prefs.getString("signature")
  };
}

// 退出登录
Future<void> signOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("id");
  prefs.remove("avatarUrl");
  prefs.remove("username");
  print(await getUserInfo());
  Navigator.pop(context);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

// 验证邮箱
matchEmail(String input) {
  // String regEmail = "^\w+([-+.]\w+)*\w+([-.]\w+)*\.\w+([-.]\w+)*$";
  String regexEmail =
      "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
  if (input.isEmpty) return false;
  return new RegExp(regexEmail).hasMatch(input);
}

// 获得格式化后的时间
getFormatTime() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy/MM/dd–kk:mm').format(now);
  return formattedDate;
}

String getRandId() {
  String alphabet = '0123456789';
  int strlenght = 9;

  /// 生成的字符串固定长度
  String left = '';
  for (var i = 0; i < strlenght; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}

formmatedNum(String num) {
  // return double.toStringfIXED
  var count = double.parse(num);
  return count.toStringAsFixed(2);
}

// 显示底部图片选择框
void showImgSelectModal(BuildContext context,
    void Function()? selectImgByCamera, void Function()? selectImgByGallery) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Column(
          children: [
            CupertinoButton(child: Text("相机"), onPressed: selectImgByCamera),
            CupertinoButton(child: Text("图库"), onPressed: selectImgByGallery),
            CupertinoButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      );
    },
  );
}
