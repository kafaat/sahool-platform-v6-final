import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final double temperature;
  final double? feelsLike;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String? description;
  final String? icon;
  final DateTime? recordedAt;

  const WeatherEntity({
    required this.temperature,
    this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    this.description,
    this.icon,
    this.recordedAt,
  });

  @override
  List<Object?> get props => [temperature, humidity, condition];

  String get temperatureFormatted => '${temperature.round()}°';
  String get feelsLikeFormatted => feelsLike != null ? '${feelsLike!.round()}°' : '--';
  String get humidityFormatted => '$humidity%';
  String get windSpeedFormatted => '${windSpeed.toStringAsFixed(1)} كم/س';

  String get conditionArabic {
    switch (condition.toLowerCase()) {
      case 'sunny': case 'clear': return 'مشمس';
      case 'cloudy': return 'غائم';
      case 'partly_cloudy': return 'غائم جزئياً';
      case 'rainy': case 'rain': return 'ممطر';
      case 'stormy': return 'عاصف';
      case 'windy': return 'رياح';
      case 'foggy': return 'ضباب';
      case 'snowy': return 'ثلج';
      default: return condition;
    }
  }
}

class ForecastEntity extends Equatable {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final String condition;
  final int? rainProbability;

  const ForecastEntity({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.condition,
    this.rainProbability,
  });

  @override
  List<Object?> get props => [date, minTemp, maxTemp, condition];

  double get avgTemp => (minTemp + maxTemp) / 2;
  String get tempRange => '${minTemp.round()}° - ${maxTemp.round()}°';
}
