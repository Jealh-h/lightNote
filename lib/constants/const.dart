import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

Map<String, WeatherType> weatherBgMap = {
  "晴": WeatherType.sunny,
  "多云": WeatherType.cloudy,
  "少云": WeatherType.cloudy,
  "晴间多云": WeatherType.cloudy,
  "阴": WeatherType.overcast,
  "有风": WeatherType.cloudy,
  "平静": WeatherType.cloudy,
  "微风": WeatherType.cloudy,
  "和风": WeatherType.cloudy,
  "清风": WeatherType.cloudy,
  "强风劲风": WeatherType.foggy,
  "疾风": WeatherType.foggy,
  "大风": WeatherType.foggy,
  "烈风": WeatherType.foggy,
  "风暴": WeatherType.heavyRainy,
  "狂爆风": WeatherType.heavyRainy,
  "飓风": WeatherType.heavyRainy,
  "热带风暴": WeatherType.heavyRainy,
  "霾": WeatherType.hazy,
  "中度霾": WeatherType.hazy,
  "重度霾": WeatherType.hazy,
  "严重霾": WeatherType.hazy,
  "阵雨": WeatherType.lightRainy,
  "雷阵雨": WeatherType.thunder,
  "雷阵雨并伴有冰雹": WeatherType.thunder,
  "小雨": WeatherType.lightRainy,
  "中雨": WeatherType.middleRainy,
  "大雨": WeatherType.heavyRainy,
  "暴雨": WeatherType.heavyRainy,
  "大暴雨": WeatherType.thunder,
  "特大暴雨": WeatherType.heavyRainy,
  "强阵雨": WeatherType.heavyRainy,
  "强雷阵雨": WeatherType.heavyRainy,
  "极端降雨": WeatherType.thunder,
  "毛雨/细雨": WeatherType.lightRainy,
  "雨": WeatherType.middleRainy,
  "小雨-中雨": WeatherType.middleRainy,
  "中雨-大雨": WeatherType.middleRainy,
  "大雨暴雨": WeatherType.heavyRainy,
  "暴雨-大暴雨": WeatherType.heavyRainy,
  "大暴雨-特大暴雨": WeatherType.thunder,
  "雨雪天气": WeatherType.lightSnow,
  "雨夹雪": WeatherType.middleSnow,
  "阵雨夹雪": WeatherType.middleSnow,
  "冻雨": WeatherType.middleSnow,
  "阵雪": WeatherType.middleSnow,
  "小雪": WeatherType.lightSnow,
  "中雪": WeatherType.middleSnow,
  "大雪": WeatherType.heavySnow,
  "暴雪": WeatherType.heavySnow,
  "小雪-中雪": WeatherType.lightSnow,
  "中雪大雪": WeatherType.middleSnow,
  "大雪-暴雪": WeatherType.heavySnow,
  "尘": WeatherType.dusty,
  "扬沙": WeatherType.dusty,
  "沙尘暴": WeatherType.dusty,
  "强沙尘暴": WeatherType.dusty,
  "龙卷风": WeatherType.dusty,
  "雾": WeatherType.foggy,
  "浓雾": WeatherType.foggy,
  "强浓雾": WeatherType.foggy,
  "轻雾": WeatherType.foggy,
  "大雾": WeatherType.foggy,
  "特强浓雾": WeatherType.hazy,
  "热": WeatherType.sunny,
  "未知": WeatherType.foggy
};

const weekdays = [
  "星期天",
  "星期一",
  "星期二",
  "星期三",
  "星期四",
  "星期五",
  "星期六",
];

var colorsArr = [
  [Colors.blue.shade200, Colors.blue.shade300],
  [Colors.green.shade200, Colors.green.shade300],
  [Colors.purple.shade200, Colors.purple.shade300],
  [Colors.grey.shade300, Colors.grey.shade400],
  [Colors.blue.shade800, Colors.blue.shade900]
];

var noteBookCover = [
  "assets/images/notebook_cover1.png",
  "assets/images/notebook_cover2.png",
  "assets/images/notebook_cover3.png",
  "assets/images/notebook_cover4.png",
  "assets/images/notebook_cover5.png",
  "assets/images/notebook_cover6.png",
  "assets/images/notebook_cover7.png",
];

const consumptionType = [
  {
    "name": "服饰",
    "icon": Icon(Icons.local_mall),
  },
  {
    "name": "餐饮",
    "icon": Icon(Icons.fastfood),
  },
  {
    "name": "交通",
    "icon": Icon(Icons.directions_car),
  },
  {
    "name": "其他",
    "icon": Icon(Icons.error_outline),
  }
];

const baseUrl = "http://10.0.2.2:7001";

const defaultAvatarUrl = "http://47.99.199.187/images/default_avatar.jpg";

class User {
  String username;
  String email;
  String password;
  String avatarUrl = defaultAvatarUrl;
  User(this.username, this.email, this.avatarUrl, this.password);
}
