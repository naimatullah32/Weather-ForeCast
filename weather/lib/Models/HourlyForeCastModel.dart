class HourlyForeCastModel {
  HourlyForeCastModel({
    double? latitude,
    double? longitude,
    double? generationtimeMs,
    int? utcOffsetSeconds,
    String? timezone,
    String? timezoneAbbreviation,
    double? elevation,
    HourlyUnits? hourlyUnits,
    Hourly? hourly,
  }) {
    _latitude = latitude;
    _longitude = longitude;
    _generationtimeMs = generationtimeMs;
    _utcOffsetSeconds = utcOffsetSeconds;
    _timezone = timezone;
    _timezoneAbbreviation = timezoneAbbreviation;
    _elevation = elevation;
    _hourlyUnits = hourlyUnits;
    _hourly = hourly;
  }

  HourlyForeCastModel.fromJson(dynamic json) {
    _latitude = json['latitude']?.toDouble();
    _longitude = json['longitude']?.toDouble();
    _generationtimeMs = json['generationtime_ms']?.toDouble();
    _utcOffsetSeconds = json['utc_offset_seconds'];
    _timezone = json['timezone'];
    _timezoneAbbreviation = json['timezone_abbreviation'];
    _elevation = json['elevation']?.toDouble();
    _hourlyUnits = json['hourly_units'] != null ? HourlyUnits.fromJson(json['hourly_units']) : null;
    _hourly = json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null;

    // Limit hourly data to 12 hours
    _hourly = _hourly?.limitTo12Hours();
  }

  double? _latitude;
  double? _longitude;
  double? _generationtimeMs;
  int? _utcOffsetSeconds;
  String? _timezone;
  String? _timezoneAbbreviation;
  double? _elevation;
  HourlyUnits? _hourlyUnits;
  Hourly? _hourly;

  HourlyForeCastModel copyWith({
    double? latitude,
    double? longitude,
    double? generationtimeMs,
    int? utcOffsetSeconds,
    String? timezone,
    String? timezoneAbbreviation,
    double? elevation,
    HourlyUnits? hourlyUnits,
    Hourly? hourly,
  }) =>
      HourlyForeCastModel(
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        generationtimeMs: generationtimeMs ?? _generationtimeMs,
        utcOffsetSeconds: utcOffsetSeconds ?? _utcOffsetSeconds,
        timezone: timezone ?? _timezone,
        timezoneAbbreviation: timezoneAbbreviation ?? _timezoneAbbreviation,
        elevation: elevation ?? _elevation,
        hourlyUnits: hourlyUnits ?? _hourlyUnits,
        hourly: hourly ?? _hourly?.limitTo12Hours(),
      );

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double? get generationtimeMs => _generationtimeMs;
  int? get utcOffsetSeconds => _utcOffsetSeconds;
  String? get timezone => _timezone;
  String? get timezoneAbbreviation => _timezoneAbbreviation;
  double? get elevation => _elevation;
  HourlyUnits? get hourlyUnits => _hourlyUnits;
  Hourly? get hourly => _hourly;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['generationtime_ms'] = _generationtimeMs;
    map['utc_offset_seconds'] = _utcOffsetSeconds;
    map['timezone'] = _timezone;
    map['timezone_abbreviation'] = _timezoneAbbreviation;
    map['elevation'] = _elevation;
    if (_hourlyUnits != null) {
      map['hourly_units'] = _hourlyUnits?.toJson();
    }
    if (_hourly != null) {
      map['hourly'] = _hourly?.toJson();
    }
    return map;
  }

}

class Hourly {
  Hourly({
    List<String>? time,
    List<double>? temperature2m,
    List<int>? relativeHumidity2m,
    List<double>? windSpeed10m,
  }) {
    _time = time;
    // Convert Kelvin to Celsius
    _temperature2m = temperature2m?.map((temp) => temp - 273.15).toList();
    _relativeHumidity2m = relativeHumidity2m;
    _windSpeed10m = windSpeed10m;
  }

  Hourly.fromJson(dynamic json) {
    _time = json['time'] != null ? List<String>.from(json['time']) : null;
    _temperature2m = json['temperature_2m'] != null
        ? List<double>.from(json['temperature_2m'].map((temp) {
      // Debugging log
      print('Original temp (Kelvin): $temp');
      double celsius = temp - 273.15;
      print('Converted temp (Celsius): $celsius');
      return celsius;
    }))
        : null;
    _relativeHumidity2m = json['relative_humidity_2m'] != null
        ? List<int>.from(json['relative_humidity_2m'])
        : null;
    _windSpeed10m = json['wind_speed_10m'] != null
        ? List<double>.from(json['wind_speed_10m'])
        : null;
  }

  List<String>? _time;
  List<double>? _temperature2m;
  List<int>? _relativeHumidity2m;
  List<double>? _windSpeed10m;

  Hourly limitTo12Hours() => Hourly(
    time: _time?.take(12).toList(),
    temperature2m: _temperature2m?.take(12).toList(),
    relativeHumidity2m: _relativeHumidity2m?.take(12).toList(),
    windSpeed10m: _windSpeed10m?.take(12).toList(),
  );

  List<String>? get time => _time;
  List<double>? get temperature2m => _temperature2m;
  List<int>? get relativeHumidity2m => _relativeHumidity2m;
  List<double>? get windSpeed10m => _windSpeed10m;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = _time;
    map['temperature_2m'] = _temperature2m?.map((temp) => temp + 273.15).toList(); // Convert back to Kelvin if needed
    map['relative_humidity_2m'] = _relativeHumidity2m;
    map['wind_speed_10m'] = _windSpeed10m;
    return map;
  }

  String getWeatherIcon(double temperatureCelsius) {
    if (temperatureCelsius <= 0) {
      return '❄️'; // Snow icon
    } else if (temperatureCelsius > 0 && temperatureCelsius <= 10) {
      return '🌧️'; // Rain icon
    } else if (temperatureCelsius > 10 && temperatureCelsius <= 20) {
      return '☁️'; // Cloud icon
    } else if (temperatureCelsius > 20 && temperatureCelsius <= 30) {
      return '🌤️'; // Partly sunny icon
    } else {
      return '☀️'; // Sunny icon
    }
  }
}

class HourlyUnits {
  HourlyUnits({
    String? time,
    String? temperature2m,
    String? relativeHumidity2m,
    String? windSpeed10m,
  }) {
    _time = time;
    _temperature2m = temperature2m;
    _relativeHumidity2m = relativeHumidity2m;
    _windSpeed10m = windSpeed10m;
  }

  HourlyUnits.fromJson(dynamic json) {
    _time = json['time'];
    _temperature2m = json['temperature_2m'];
    _relativeHumidity2m = json['relative_humidity_2m'];
    _windSpeed10m = json['wind_speed_10m'];
  }

  String? _time;
  String? _temperature2m;
  String? _relativeHumidity2m;
  String? _windSpeed10m;

  String? get time => _time;
  String? get temperature2m => _temperature2m;
  String? get relativeHumidity2m => _relativeHumidity2m;
  String? get windSpeed10m => _windSpeed10m;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = _time;
    map['temperature_2m'] = _temperature2m;
    map['relative_humidity_2m'] = _relativeHumidity2m;
    map['wind_speed_10m'] = _windSpeed10m;
    return map;
  }
}
