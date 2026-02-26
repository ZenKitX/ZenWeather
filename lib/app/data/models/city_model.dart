/// 城市模型
class CityModel {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String? currentTemp;
  final String? weatherCondition;
  final String? weatherIcon;

  CityModel({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    this.currentTemp,
    this.weatherCondition,
    this.weatherIcon,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      currentTemp: json['current_temp'],
      weatherCondition: json['weather_condition'],
      weatherIcon: json['weather_icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'current_temp': currentTemp,
      'weather_condition': weatherCondition,
      'weather_icon': weatherIcon,
    };
  }

  /// 获取完整地址
  String get fullAddress {
    if (region.isNotEmpty && region != name) {
      return '$name, $region, $country';
    }
    return '$name, $country';
  }

  /// 获取简短地址
  String get shortAddress {
    if (region.isNotEmpty && region != name) {
      return '$name, $region';
    }
    return name;
  }

  /// 复制并更新天气信息
  CityModel copyWithWeather({
    String? currentTemp,
    String? weatherCondition,
    String? weatherIcon,
  }) {
    return CityModel(
      name: name,
      region: region,
      country: country,
      lat: lat,
      lon: lon,
      currentTemp: currentTemp ?? this.currentTemp,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherIcon: weatherIcon ?? this.weatherIcon,
    );
  }
}
