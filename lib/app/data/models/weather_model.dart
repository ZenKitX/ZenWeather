/// 天气数据模型
class WeatherModel {
  final LocationInfo location;
  final CurrentWeather current;
  final List<HourlyForecast>? hourly;
  final List<DailyForecast>? daily;

  WeatherModel({
    required this.location,
    required this.current,
    this.hourly,
    this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: LocationInfo.fromJson(json['location'] ?? {}),
      current: CurrentWeather.fromJson(json['current'] ?? {}),
      hourly: json['forecast']?['forecastday']?[0]?['hour'] != null
          ? (json['forecast']['forecastday'][0]['hour'] as List)
              .map((e) => HourlyForecast.fromJson(e))
              .toList()
          : null,
      daily: json['forecast']?['forecastday'] != null
          ? (json['forecast']['forecastday'] as List)
              .map((e) => DailyForecast.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'current': current.toJson(),
      'hourly': hourly?.map((e) => e.toJson()).toList(),
      'daily': daily?.map((e) => e.toJson()).toList(),
    };
  }
}

/// 位置信息
class LocationInfo {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime;

  LocationInfo({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.localtime,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      localtime: json['localtime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'localtime': localtime,
    };
  }
}

/// 当前天气
class CurrentWeather {
  final double tempC;
  final double tempF;
  final String condition;
  final String conditionText;
  final String icon;
  final double windKph;
  final double windMph;
  final int humidity;
  final double feelslikeC;
  final double feelslikeF;
  final double visKm;
  final double visMiles;
  final double pressureMb;
  final double pressureIn;
  final double uv;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.conditionText,
    required this.icon,
    required this.windKph,
    required this.windMph,
    required this.humidity,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
    required this.pressureMb,
    required this.pressureIn,
    required this.uv,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: (json['temp_c'] ?? 0).toDouble(),
      tempF: (json['temp_f'] ?? 0).toDouble(),
      condition: json['condition']?['code']?.toString() ?? '',
      conditionText: json['condition']?['text'] ?? '',
      icon: json['condition']?['icon'] ?? '',
      windKph: (json['wind_kph'] ?? 0).toDouble(),
      windMph: (json['wind_mph'] ?? 0).toDouble(),
      humidity: json['humidity'] ?? 0,
      feelslikeC: (json['feelslike_c'] ?? 0).toDouble(),
      feelslikeF: (json['feelslike_f'] ?? 0).toDouble(),
      visKm: (json['vis_km'] ?? 0).toDouble(),
      visMiles: (json['vis_miles'] ?? 0).toDouble(),
      pressureMb: (json['pressure_mb'] ?? 0).toDouble(),
      pressureIn: (json['pressure_in'] ?? 0).toDouble(),
      uv: (json['uv'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_c': tempC,
      'temp_f': tempF,
      'condition': {'code': condition, 'text': conditionText, 'icon': icon},
      'wind_kph': windKph,
      'wind_mph': windMph,
      'humidity': humidity,
      'feelslike_c': feelslikeC,
      'feelslike_f': feelslikeF,
      'vis_km': visKm,
      'vis_miles': visMiles,
      'pressure_mb': pressureMb,
      'pressure_in': pressureIn,
      'uv': uv,
    };
  }
}

/// 小时预报
class HourlyForecast {
  final String time;
  final double tempC;
  final double tempF;
  final String condition;
  final String conditionText;
  final String icon;
  final double windKph;
  final int chanceOfRain;

  HourlyForecast({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.conditionText,
    required this.icon,
    required this.windKph,
    required this.chanceOfRain,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'] ?? '',
      tempC: (json['temp_c'] ?? 0).toDouble(),
      tempF: (json['temp_f'] ?? 0).toDouble(),
      condition: json['condition']?['code']?.toString() ?? '',
      conditionText: json['condition']?['text'] ?? '',
      icon: json['condition']?['icon'] ?? '',
      windKph: (json['wind_kph'] ?? 0).toDouble(),
      chanceOfRain: json['chance_of_rain'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temp_c': tempC,
      'temp_f': tempF,
      'condition': {'code': condition, 'text': conditionText, 'icon': icon},
      'wind_kph': windKph,
      'chance_of_rain': chanceOfRain,
    };
  }
}

/// 每日预报
class DailyForecast {
  final String date;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final String condition;
  final String conditionText;
  final String icon;
  final double maxWindKph;
  final int chanceOfRain;

  DailyForecast({
    required this.date,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.condition,
    required this.conditionText,
    required this.icon,
    required this.maxWindKph,
    required this.chanceOfRain,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final day = json['day'] ?? {};
    return DailyForecast(
      date: json['date'] ?? '',
      maxTempC: (day['maxtemp_c'] ?? 0).toDouble(),
      maxTempF: (day['maxtemp_f'] ?? 0).toDouble(),
      minTempC: (day['mintemp_c'] ?? 0).toDouble(),
      minTempF: (day['mintemp_f'] ?? 0).toDouble(),
      condition: day['condition']?['code']?.toString() ?? '',
      conditionText: day['condition']?['text'] ?? '',
      icon: day['condition']?['icon'] ?? '',
      maxWindKph: (day['maxwind_kph'] ?? 0).toDouble(),
      chanceOfRain: day['daily_chance_of_rain'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': {
        'maxtemp_c': maxTempC,
        'maxtemp_f': maxTempF,
        'mintemp_c': minTempC,
        'mintemp_f': minTempF,
        'condition': {'code': condition, 'text': conditionText, 'icon': icon},
        'maxwind_kph': maxWindKph,
        'daily_chance_of_rain': chanceOfRain,
      },
    };
  }
}
